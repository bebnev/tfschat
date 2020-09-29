//
//  ConversationViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    let cellReusableId = "Messagecell"
    
    var conversation: ConversationCellModel? = ConversationCellModel(name: "Anton Bebnev", message: "Hello man", date: Date(), isOnline: true, hasUnreadMessages: true, avatar: UIImage(named: "man_6")!)
    
    var messages = [
        MessageCellModel(text: "Hello man, Hello man, Hello man, Hello man", type: .incoming),
        MessageCellModel(text: "hy", type: .outgoing),
        MessageCellModel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vel porta massa. Praesent eget ultricies ante. Integer fermentum, sem ac ullamcorper venenatis, dolor tortor placerat turpis, vitae vehicula lectus est id odio. Suspendisse varius massa sed dignissim mattis. Nullam cursus commodo nisi ut consectetur. Integer a hendrerit ligula, ac scelerisque dui. Proin eu tincidunt neque. Proin hendrerit nisl nec lacinia tincidunt. Ut dignissim quis sem id placerat. Duis vel erat vitae erat egestas consequat.", type: .incoming),
        MessageCellModel(text: "how are you", type: .outgoing),
        MessageCellModel(text: "i'm fine, you?", type: .incoming),
        MessageCellModel(text: "fine too", type: .outgoing),
        MessageCellModel(text: "coffee ?", type: .outgoing),
        MessageCellModel(text: "sure, see you in starbucks", type: .incoming),
    ]
    
    var viewHasAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        tableView.register(ChatMessageTableViewCell.self, forCellReuseIdentifier: cellReusableId)
        tableView.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewHasAppeared {
            goToBottom()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewHasAppeared = true
    }
    
    func setupNavigation() {
        if let conversation = conversation {
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                
            titleView.backgroundColor = .red
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            titleView.addSubview(containerView)
            
            let conversationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            conversationImageView.image = conversation.avatar
            conversationImageView.contentMode = .scaleAspectFill
            conversationImageView.translatesAutoresizingMaskIntoConstraints = false
            conversationImageView.layer.cornerRadius = 20
            conversationImageView.clipsToBounds = true
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = conversation.name
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.setLetterSpacing(-0.3)
            
            containerView.addSubview(label)
            containerView.addSubview(conversationImageView)
            let constraints = [
                containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
                containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                conversationImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                conversationImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                conversationImageView.widthAnchor.constraint(equalToConstant: 40),
                conversationImageView.heightAnchor.constraint(equalToConstant: 40),
                label.leftAnchor.constraint(equalTo: conversationImageView.rightAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: conversationImageView.centerYAnchor),
                label.rightAnchor.constraint(equalTo: containerView.rightAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            navigationItem.titleView = titleView
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }

    private func goToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = NSIndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        tableView.layoutIfNeeded()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as? ChatMessageTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
