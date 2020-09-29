//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationsListViewController: ViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var chatsTableView: UITableView!
    
    // MARK:- fake data
    
    let user = User(name: "Marina Dudarenko", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
    
    let fakeData = FakeDataLoader();
    
    // MARK:- UI vars
    
    let reuseIdentificator = String(describing: ConversationTableViewCell.self)
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search text"
        return search
    }()
    
    lazy var settingsButtonItem: UIBarButtonItem = {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(handleSettingsButtonTap))
        settingsButton.tintColor = UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65)
        
        return settingsButton
    }()
    
    lazy var avatarButtonItem: UIBarButtonItem = {
        let avatarView = AvataViewPlaceholder(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        avatarView.userName = self.user.name
        let incidentTap = UITapGestureRecognizer()
        incidentTap.addTarget(self, action: #selector(self.handleAvatarButtonItemTap))
        avatarView.addGestureRecognizer(incidentTap)
        
        let barItem = UIBarButtonItem(customView: avatarView)
        return barItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFakeData()
        setupNavigation()
        setupView()
    }
    
    private func loadFakeData() {
        fakeData.load()
    }
    
    private func setupView() {
        chatsTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentificator)
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
    }
    
    @objc
    private func handleSettingsButtonTap() {
        Log.debug("Settings click")
    }
    
    @objc
    private func handleAvatarButtonItemTap() {
        navigateToProfileView()
    }

}

// MARK:- Navigation

extension ConversationsListViewController {
    private func setupNavigation() {
       title = "Tinkoff Chat"
       navigationController?.navigationBar.prefersLargeTitles = true
       navigationItem.searchController = searchController
       navigationItem.hidesSearchBarWhenScrolling = true
       navigationItem.leftBarButtonItem = settingsButtonItem
       navigationItem.rightBarButtonItem = avatarButtonItem
   }
    
    func navigateToProfileView() {
        performSegue(withIdentifier: "profileView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileView",
            let controller = segue.destination as? ProfileViewController  {
            
            controller.user = user
        }
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

extension ConversationsListViewController: UITableViewDelegate {}

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
        cell.nameLabel.text = conversation.name
        cell.messageLabel.text = conversation.message
        cell.dateLabel.text = "Now"
        cell.avatarImageView.image = conversation.avatar
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentificator, for: indexPath) as! NoteTableViewCell
//
//        let note = notebook.notes[indexPath.row]
//
//        cell.titleLabel.text = note.title
//        cell.contentLabel.text = note.content
//        if note.color == .white {
//            cell.colorView.isHidden = true
//        } else {
//            cell.colorView.isHidden = false
//            cell.colorView.backgroundColor = note.color // TODO: white color
//        }
//
//        cell.accessoryType = .disclosureIndicator
//        cell.selectionStyle = .none
//
//        return cell
    }
}
