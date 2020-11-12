//
//  ConversationViewController+Table.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as? ConversationMessageTableViewCell,
            let message = (fetchController?.object(at: indexPath))?.makeMessage() else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.themeManager = presentationAssembly?.themeManager
        cell.configure(with: message)
        return cell
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController?.fetchedObjects?.count ?? 0
    }
}
