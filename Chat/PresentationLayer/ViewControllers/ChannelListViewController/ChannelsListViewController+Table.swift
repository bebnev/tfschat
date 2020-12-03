//
//  ChannelsListViewController+Table.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UITableViewDelegate

extension ChannelListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let theme = presentationAssembly?.themeManager.theme else {
            return
        }
        view.tintColor = theme.tableViewSectionBackgroundColor

        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = theme.mainTextColor
        }
    }
}

// MARK: - UITableViewDataSource

extension ChannelListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationTableViewCell.self), for: indexPath) as? ConversationTableViewCell,
            let channelDd = fetchController?.object(at: indexPath),
            let channel = channelDd.makeChannel() else {
            return UITableViewCell()
        }

        cell.themeManager = presentationAssembly?.themeManager
        cell.configure(with: channel)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let channelDb = fetchController?.object(at: indexPath) {
            let conversationViewController = presentationAssembly?.viewControllerFactory.makeConversationViewController()
            conversationViewController?.channel = channelDb
            
            presentationAssembly?.router.push(conversationViewController)
        }
       
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete,
            let data = fetchController?.object(at: indexPath),
            let identifier = data.identifier {
            
            dataService?.removeChannel(withIdentifier: identifier)
        }
    }
}
