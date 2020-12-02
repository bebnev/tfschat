//
//  ChannelListViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import CoreData

class ChannelListViewController: AbstractViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: SearchController = {
        let controller = SearchController(themeManager: self.presentationAssembly?.themeManager, searchResultsController: nil)
        controller.searchResultsUpdater = self
        return controller
    }()
    
    lazy var avatarView: AvataViewPlaceholder = {
        let avatarView = AvataViewPlaceholder(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        avatarView.isAccessibilityElement = true
        avatarView.accessibilityIdentifier = "ChannelListAvatarView"
        let incidentTap = UITapGestureRecognizer()
        incidentTap.addTarget(self, action: #selector(self.handleAvatarButtonItemTap))
        avatarView.addGestureRecognizer(incidentTap)

        return avatarView
    }()
    
    lazy var profileLoadingIndicator: LoadingIndicator = LoadingIndicator()
    lazy var loadingIndicator: LoadingIndicator = {
        let view = LoadingIndicator()
        view.center = self.view.center
        view.activityIndicator?.backgroundColor = .white
        
        return view
    }()
    
    private var isLoading = false {
        didSet {
            if isLoading {
                loadingIndicator.start()
            } else {
                loadingIndicator.stop()
            }
        }
    }
    
    private var isProfileLoading = false {
        didSet {
            if isProfileLoading {
                //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileLoadingIndicator)
                avatarView.clearBackground()
                profileLoadingIndicator.start()
            } else {
                profileLoadingIndicator.stop()
                if let name = presentationAssembly?.profileManager.profile?.name {
                    avatarView.userName = name
                    avatarView.isHidden = false
                    avatarView.setDefaultBackground()
                } else {
                    avatarView.isHidden = true
                }
            }
        }
    }
    
    lazy var fetchController: NSFetchedResultsController<Channel_db>? = {
        guard let dataService = self.dataService else { return nil }
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Channel_db.lastActivity), ascending: false)
        request.sortDescriptors = [sort]

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataService.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self

        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello world"
        
        configureNavigation()
        configureView()
        loadData()
    }
    
    override func applyTheme(theme: ITheme) {
        super.applyTheme(theme: theme)

        tableView.backgroundColor = theme.mainBackgroundColor
    }
    
    private func configureNavigation() {
        title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(handleSettingsButtonTap))
        settingsButton.tintColor = UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65)
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: avatarView),
            UIBarButtonItem(image: UIImage(named: "new-channel"), style: .plain, target: self, action: #selector(addChannel))
        ]
    }
    
    private func configureView() {
        avatarView.addSubview(profileLoadingIndicator)
        view.addSubview(loadingIndicator)
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexBackgroundColor = UIColor.white
    }
    
    private func loadData() {
        do {
            try fetchController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let presentationAssembly = presentationAssembly else { return }
        
        isProfileLoading = true
        presentationAssembly.profileManager.fetchWithOperation { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.isProfileLoading = false
            }
        }
        
        dataService?.fetchChannels(completion: nil)
    }
    
    @objc
    private func handleSettingsButtonTap() {
        let themesVC = presentationAssembly?.viewControllerFactory.makeThemeListViewController()
        
        presentationAssembly?.themeManager.delegate = self

        presentationAssembly?.router.push(themesVC)
    }
    
    @objc
    private func handleAvatarButtonItemTap() {
        guard let profileVC = presentationAssembly?.viewControllerFactory.makeProfileViewController() else { return }
        profileVC.delegate = self
        let navController = UINavigationController(rootViewController: profileVC)
        navController.applyTheme(theme: presentationAssembly?.themeManager.theme)
        
        let segue = BottomCardSegue(identifier: nil, source: self, destination: navController)
        prepare(for: segue, sender: nil)
        segue.perform()
    }
    
    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addChannel() {
        guard let presentationAssembly = presentationAssembly else {return}
        let alertController = UIAlertController(title: "Добавить канал", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Имя канала"
        }

        let saveAction = UIAlertAction(title: "Создать", style: .default, handler: { [weak self] (_) in
            guard let channelTextField = alertController.textFields?[0], let newChannelName = channelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return
            }

            if newChannelName.isEmpty {
                self?.present(presentationAssembly.alertManager.error(message: "Для создания канала необходимо указать его имя"), animated: true, completion: nil)
                return
            }

            self?.isLoading = true
            self?.dataService?.addChannel(name: newChannelName) { [weak self] (error) in
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    if error != nil {
                        self?.present(
                            presentationAssembly.alertManager.error(message: "Канал \(newChannelName) не создан. Повторите попытку позже"),
                            animated: true, completion: nil)
                    }

                }
            }
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil )

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
