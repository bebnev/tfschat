//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationsListViewController: ViewController {
    
    let user = User(name: "Marina Dudarenko", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
    
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
        
        setupNavigation()
        
        //view.backgroundColor = UIColor.yellow

        // Do any additional setup after loading the view.
    }
    
    private func setupNavigation() {
        title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.leftBarButtonItem = settingsButtonItem
        navigationItem.rightBarButtonItem = avatarButtonItem
    }
    
    @objc
    private func handleSettingsButtonTap() {
        Log.debug("Settings click")
    }
    
    @objc
    private func handleAvatarButtonItemTap() {
        navigateToProfileView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationsListViewController {
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

extension ConversationsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        Log.debug(text)
    }
}
