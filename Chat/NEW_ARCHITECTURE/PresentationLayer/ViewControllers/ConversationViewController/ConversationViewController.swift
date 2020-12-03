//
//  ConversationViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: AbstractViewController {
    
    let cellReusableId = "ConversationMessageCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationMessageTableViewCell.self, forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setLetterSpacing(-0.3)
        
        return label
    }()
    
    lazy var inputField: UITextField = {
        let inputField = UITextField()
        inputField.textColor = self.presentationAssembly?.themeManager.theme?.mainTextColor
        inputField.attributedPlaceholder = NSAttributedString(string: "Your message here...", attributes: [
            .foregroundColor: self.presentationAssembly?.themeManager.theme?.chatInputPlaceholderColor as Any])
        inputField.backgroundColor = self.presentationAssembly?.themeManager.theme?.chatFieldBackgroundColor
        inputField.layer.borderColor = self.presentationAssembly?.themeManager.theme?.chatFieldBorderColor.cgColor
        inputField.layer.borderWidth = 0.5
        inputField.layer.cornerRadius = 16
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.setLeftPadding(12)
        inputField.setRightPadding(12)
        inputField.delegate = self
        return inputField
    }()
    
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
    
    lazy var fetchController: NSFetchedResultsController<Message_db>? = {
        guard let channel = channel, let identifier = channel.identifier, let dataService = self.dataService else { return nil }
        let fetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "channel = %@", channel)
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataService.getMainContext(),
            sectionNameKeyPath: nil,
            cacheName: "message_for_channel_with_id_\(identifier)")
        
        controller.delegate = self
        
        return controller
    }()
    
    var channel: Channel_db?
    
    var fieldContainerViewBottomAnchor: NSLayoutConstraint?
    
    var viewHasAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureView()
        configureKeyboardObservers()
        
        loadData()
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
    
    private func loadData() {
        guard let fetchController = fetchController, let channelDb = channel, let identifier = channelDb.identifier else {
            return
        }
        do {
            try fetchController.performFetch()
        } catch {
            print("Fetch messages request failed")
        }
        
        dataService?.fetchMessages(for: identifier, completion: nil)
    }
    
    override func applyTheme(theme: ITheme) {
        super.applyTheme(theme: theme)
        tableView.backgroundColor = theme.mainBackgroundColor
        titleLabel.textColor = theme.mainTextColor
    }
    
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureNavigation() {
        if let channel = channel {
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false

            titleView.addSubview(containerView)
            titleLabel.text = channel.name
            containerView.addSubview(titleLabel)
            let constraints = [
                containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
                containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
            ]

            NSLayoutConstraint.activate(constraints)
            navigationItem.titleView = titleView
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureView() {
        view.addSubview(loadingIndicator)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        view.addGestureRecognizer(tap)
        
        let fieldContainerView = UIView()
        fieldContainerView.backgroundColor = presentationAssembly?.themeManager.theme?.chatInputFieldBackgroundColor
        fieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let inputFieldContainerView = UIView()
        inputFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(fieldContainerView)
        fieldContainerView.addSubview(inputFieldContainerView)
        
        let sendImageView = UIImageView()
        sendImageView.isUserInteractionEnabled = true
        sendImageView.image = UIImage(named: "send")
        sendImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapSend = UITapGestureRecognizer(target: self, action: #selector(handleSendTap))
        sendImageView.addGestureRecognizer(tapSend)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = presentationAssembly?.themeManager.theme?.chatInputFieldBorderColor
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        fieldContainerView.addSubview(separatorLineView)
        inputFieldContainerView.addSubview(inputField)
        inputFieldContainerView.addSubview(sendImageView)
        
        fieldContainerViewBottomAnchor = fieldContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: fieldContainerView.topAnchor, constant: -12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fieldContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fieldContainerViewBottomAnchor!,
            fieldContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            fieldContainerView.heightAnchor.constraint(equalToConstant: 80),
            inputFieldContainerView.leftAnchor.constraint(equalTo: fieldContainerView.leftAnchor, constant: 17),
            inputFieldContainerView.rightAnchor.constraint(equalTo: fieldContainerView.rightAnchor, constant: -17),
            inputFieldContainerView.topAnchor.constraint(equalTo: fieldContainerView.topAnchor, constant: 17),
            inputFieldContainerView.heightAnchor.constraint(equalToConstant: 32),
            sendImageView.rightAnchor.constraint(equalTo: inputFieldContainerView.rightAnchor),
            sendImageView.centerYAnchor.constraint(equalTo: inputFieldContainerView.centerYAnchor),
            sendImageView.widthAnchor.constraint(equalToConstant: 20),
            sendImageView.heightAnchor.constraint(equalToConstant: 20),
            inputField.leftAnchor.constraint(equalTo: inputFieldContainerView.leftAnchor),
            inputField.rightAnchor.constraint(equalTo: sendImageView.leftAnchor, constant: -13),
            inputField.centerYAnchor.constraint(equalTo: inputFieldContainerView.centerYAnchor),
            inputField.heightAnchor.constraint(equalTo: inputFieldContainerView.heightAnchor),
            separatorLineView.leftAnchor.constraint(equalTo: fieldContainerView.leftAnchor),
            separatorLineView.rightAnchor.constraint(equalTo: fieldContainerView.rightAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func goToBottom() {
        guard let fetchController = fetchController, let countObjects = fetchController.fetchedObjects?.count,
            countObjects > 0 else { return }
        let indexPath = IndexPath(row: countObjects - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        tableView.layoutIfNeeded()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func handleKeyboardAppearance(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}

        if notification.name == UIResponder.keyboardWillShowNotification {
            fieldContainerViewBottomAnchor?.constant = -keyboardFrame.height
            
            UIView.animate(withDuration: keyboardDuration.doubleValue) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        } else {
            fieldContainerViewBottomAnchor?.constant = 0
        }
    }
    
    @objc
    func handleViewTap(_ sender: Any) {
        dismissKeyboard()
    }
    
    @objc
    func handleSendTap() {
        dismissKeyboard()
        
        guard let content = inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let userId = Sender.shared.userId, let identifier = channel?.identifier else {
            return
        }
        
        if content.isEmpty {
            return
        }
        
        let data: [String: Any] = ["content": content, "senderId": userId, "senderName": Sender.shared.name, "created": Timestamp(date: Date())]
        dataService?.addMessage(for: identifier, data: data) {[weak self] error in
            if error == nil {
                self?.inputField.text = ""
            }
        }
    }
}
