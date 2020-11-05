//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var chatsTableView: UITableView!
    
    // MARK: - UI vars
    
    let reuseIdentificator = String(describing: ConversationTableViewCell.self)
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search text"
        search.searchBar.textField?.backgroundColor = ThemeManager.shared.theme?.searchBarBackgroundColor
        search.searchBar.backgroundColor = .clear
        return search
    }()
    
    lazy var settingsButtonItem: UIBarButtonItem = {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(handleSettingsButtonTap))
        settingsButton.tintColor = UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65)
        
        return settingsButton
    }()
    
    lazy var avatarView: AvataViewPlaceholder = {
        let avatarView = AvataViewPlaceholder(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let incidentTap = UITapGestureRecognizer()
        incidentTap.addTarget(self, action: #selector(self.handleAvatarButtonItemTap))
        avatarView.addGestureRecognizer(incidentTap)
        
        return avatarView
    }()
    
    lazy var profileLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        return indicator
    }()
    
    private var firstLoad = true
    private var isProfileLoading = false {
        didSet {
            if isProfileLoading {
                //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileLoadingIndicator)
                avatarView.clearBackground()
                profileLoadingIndicator.isHidden = false
                profileLoadingIndicator.startAnimating()
            } else {
                profileLoadingIndicator.stopAnimating()
                if Profile.shared.isLoaded() {
                    avatarView.userName = Profile.shared.currentUser.name
                    //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
                    avatarView.isHidden = false
                    avatarView.setDefaultBackground()
                    profileLoadingIndicator.isHidden = true
                } else {
                    avatarView.isHidden = true
                }
                
            }
        }
    }
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = view.center
        return indicator
    }()
    
    private var isChannelsLoading = false {
        didSet {
            if isChannelsLoading {
                loadingIndicator.startAnimating()
                loadingIndicator.backgroundColor = UIColor.white
            } else {
                loadingIndicator.stopAnimating()
                loadingIndicator.hidesWhenStopped = true
            }
        }
    }
    
    lazy var coreDataManager: CoreDataStack = {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.coreDataStack
        }
        
        return CoreDataStack()
    }()
    
    lazy var fetchController: NSFetchedResultsController<Channel_db> = {
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Channel_db.lastActivity), ascending: false)
        request.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var dataManager: DataManager = {
        return DataManager(coreDataStack: self.coreDataManager)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            isProfileLoading = true
            let operationsProfileManager = ProfileOperationDataManager(profile: Profile.shared)
            operationsProfileManager.load {
                DispatchQueue.main.async {
                    self.isProfileLoading = false
                }
            }
        }
        
        firstLoad = false
    }
    
    private func setupView() {
        avatarView.addSubview(profileLoadingIndicator)
        view.addSubview(loadingIndicator)
        chatsTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentificator)
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.sectionIndexBackgroundColor = UIColor.white
    }
    
    private func loadData() {
        do {
            try fetchController.performFetch()
        } catch {
            Log.debug("Fetch channels request failed")
        }
        
        dataManager.fetchChannels(completion: nil)
    }
    
    @objc
    private func handleSettingsButtonTap() {
        let themesVC = ThemesViewController()
        
        themesVC.delegate = self
        
//        themesVC.selectTheme = {[weak self] (theme) in
//            self?.selectTheme(theme: theme)
//        }
        
        show(themesVC, sender: self)
    }
    
    @objc
    private func handleAvatarButtonItemTap() {
        navigateToProfileView()
    }
    
    override func applyTheme(theme: ThemeProtocol) {
        super.applyTheme(theme: theme)
        
        chatsTableView.backgroundColor = theme.mainBackgroundColor
    }
    
    @objc
    func addChannel() {
        let alertController = UIAlertController(title: "Добавить канал", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Имя канала"
        }

        let saveAction = UIAlertAction(title: "Создать", style: .default, handler: { [weak self] (_) in
            guard let channelTextField = alertController.textFields?[0], let newChannelName = channelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return
            }
            
            if newChannelName.isEmpty {
                self?.errorAlert("Для создания канала необходимо указать его имя")
                return
            }
            
            self?.isChannelsLoading = true
            self?.dataManager.addChannel(name: newChannelName) { [weak self] (error) in
                DispatchQueue.main.async { [weak self] in
                    self?.isChannelsLoading = false
                    if error != nil {
                        self?.errorAlert("Канал \(newChannelName) не создан. Повторите попытку позже")
                    }
                    
                }
            }
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil )
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Navigation

extension ConversationsListViewController {
    private func setupNavigation() {
        title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.leftBarButtonItem = settingsButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: avatarView),
            UIBarButtonItem(image: UIImage(named: "new-channel"), style: .plain, target: self, action: #selector(addChannel))
        ]
   }
    
    func navigateToProfileView() {
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NewProfileViewController") as? ProfileViewController
            else { return }
        myVC.profileDelegate = self
        
        let navController = UINavigationController(rootViewController: myVC)
        navController.applyTheme()

        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func navigateToChatDetails(_ channel: Channel_db) {
        let conversationViewController = ConversationViewController()
        conversationViewController.channel = channel
        
        show(conversationViewController, sender: self)
    }
}

// MARK: - UISearchResultsUpdating

extension ConversationsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        Log.debug(text)
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let theme = ThemeManager.shared.theme else {
            return
        }
        view.tintColor = theme.tableViewSectionBackgroundColor

        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = theme.mainTextColor
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
        //return fetchController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentificator, for: indexPath) as? ConversationTableViewCell,
            let channel = (fetchController.object(at: indexPath)).makeChannel() else {
            return UITableViewCell()
        }
        
        cell.configure(with: channel)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelDb = fetchController.object(at: indexPath)
        
        navigateToChatDetails(channelDb)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let data = fetchController.object(at: indexPath)
            if let identifier = data.identifier {
                dataManager.removeChannel(withIdentifier: identifier)
            }
        }
    }
}

// MARK: - ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func selectTheme(theme: ThemeProtocol) {
        navigationController?.applyTheme()
        searchController.searchBar.textField?.backgroundColor = theme.searchBarBackgroundColor
        chatsTableView.reloadData()
    }
}

// MARK: - ProfileProviderDelegate

extension ConversationsListViewController: ProfileProviderDelegate {
    func setNewProfile(user: User) {
        if avatarView.userName != user.name {
            avatarView.userName = user.name
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                chatsTableView.insertRows(at: [indexPath], with: .none)
            }
        case .update:
            if let indexPath = indexPath,
               let cell = chatsTableView.cellForRow(at: indexPath) as? ConversationTableViewCell,
                let channel = (fetchController.object(at: indexPath)).makeChannel() {
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                chatsTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                chatsTableView.deleteRows(at: [indexPath], with: .none)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatsTableView.endUpdates()
    }
}
