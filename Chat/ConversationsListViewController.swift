//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationsListViewController: BaseViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var chatsTableView: UITableView!
    
    // MARK:- fake data
    
    let fakeData = FakeDataLoader();
    
    // MARK:- UI vars
    
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
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileLoadingIndicator)
                profileLoadingIndicator.startAnimating()
            } else {
                profileLoadingIndicator.stopAnimating()
                if Profile.shared.isLoaded() {
                    avatarView.userName = Profile.shared.currentUser.name
                    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
                } else {
                    navigationItem.rightBarButtonItem = nil
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFakeData()
        setupNavigation()
        setupView()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            isProfileLoading = true
            // load method works only in OperationsManager
            let operationsProfileManager = ProfileOperationDataManager(profile: Profile.shared)
            operationsProfileManager.load {
                DispatchQueue.main.async {
                    self.isProfileLoading = false
                }
            }
        }
        
        firstLoad = false
    }
    
    private func loadFakeData() {
        fakeData.load()
    }
    
    private func setupView() {
        chatsTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentificator)
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.sectionIndexBackgroundColor = UIColor.white
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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}

// MARK:- Navigation

extension ConversationsListViewController {
    private func setupNavigation() {
       title = "Tinkoff Chat"
       navigationController?.navigationBar.prefersLargeTitles = true
       navigationItem.searchController = searchController
       navigationItem.hidesSearchBarWhenScrolling = true
       navigationItem.leftBarButtonItem = settingsButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
   }
    
    func navigateToProfileView() {
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NewProfileViewController") as? ProfileViewController else { return } // TODO: change name to profile view controller
        myVC.profileDelegate = self
        
        let navController = UINavigationController(rootViewController: myVC)
        navController.applyTheme()

        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func navigateToChatDetails(_ conversation: ConversationCellModel) {
        let conversationViewController = ConversationViewController()
        conversationViewController.conversation = conversation
        
        show(conversationViewController, sender: self)
    }
}

// MARK:- UISearchResultsUpdating

extension ConversationsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        Log.debug(text)
    }
}

// MARK:- UITableViewDelegate

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

// MARK:- UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fakeData.conversations.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeData.conversations[section].conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentificator, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        let conversation = fakeData.conversations[indexPath.section].conversations[indexPath.row]
        cell.configure(with: conversation)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fakeData.conversations[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = fakeData.conversations[indexPath.section].conversations[indexPath.row]
        if cell.isOnline {
            navigateToChatDetails(cell)
        }
    }
}


extension ConversationsListViewController: ThemesPickerDelegate {
    func selectTheme(theme: ThemeProtocol) {
        navigationController?.applyTheme()
        searchController.searchBar.textField?.backgroundColor = theme.searchBarBackgroundColor
        chatsTableView.reloadData()
    }
}

extension ConversationsListViewController: ProfileProviderDelegate {
    func setNewProfile(user: User) {
        if avatarView.userName != user.name {
            avatarView.userName = user.name
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
        }
    }
}
