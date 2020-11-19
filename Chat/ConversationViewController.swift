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

class ConversationViewController: BaseViewController {
    
    let cellReusableId = "ConversationMessageCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationMessageTableViewCell.self, forCellReuseIdentifier: cellReusableId)
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
        inputField.textColor = ThemeManager.shared.theme?.mainTextColor
        inputField.attributedPlaceholder = NSAttributedString(string: "Your message here...", attributes: [
            .foregroundColor: ThemeManager.shared.theme?.chatInputPlaceholderColor as Any])
        inputField.backgroundColor = ThemeManager.shared.theme?.chatFieldBackgroundColor
        inputField.layer.borderColor = ThemeManager.shared.theme?.chatFieldBorderColor.cgColor
        inputField.layer.borderWidth = 0.5
        inputField.layer.cornerRadius = 16
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.setLeftPadding(12)
        inputField.setRightPadding(12)
        inputField.delegate = self
        return inputField
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = view.center
        return indicator
    }()
    
    private var isMessagesLoading = false {
        didSet {
            if isMessagesLoading {
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
    
    private lazy var fetchController: NSFetchedResultsController<Message_db>? = {
        guard let channel = channel, let identifier = channel.identifier else { return nil }
        let fetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "channel = %@", channel)
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataManager.mainContext,
            sectionNameKeyPath: nil,
            cacheName: "message_for_channel_with_id_\(identifier)")
        
        controller.delegate = self
        
        return controller
    }()
    
    lazy var dataManager: DataManager = {
        return DataManager(coreDataStack: self.coreDataManager)
    }()
    
    var channel: Channel_db?
    
    var fieldContainerViewBottomAnchor: NSLayoutConstraint?
    
    var viewHasAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        setupKeyboardObservers()
        
        isMessagesLoading = true
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
            Log.debug("Fetch messages request failed")
        }
        
        dataManager.fetchMessages(for: identifier, completion: nil)
    }
    
    override func applyTheme(theme: ThemeProtocol) {
        super.applyTheme(theme: theme)
        tableView.backgroundColor = theme.mainBackgroundColor
        titleLabel.textColor = theme.mainTextColor
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigation() {
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
    
    func setupView() {
        view.addSubview(loadingIndicator)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        view.addGestureRecognizer(tap)
        
        let fieldContainerView = UIView()
        fieldContainerView.backgroundColor = ThemeManager.shared.theme?.chatInputFieldBackgroundColor
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
        separatorLineView.backgroundColor = ThemeManager.shared.theme?.chatInputFieldBorderColor
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

    private func goToBottom() {
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
        dataManager.addMessage(for: identifier, data: data) {[weak self] error in
            if error == nil {
                self?.inputField.text = ""
            }
        }
    }
    
    func errorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as? ConversationMessageTableViewCell,
            let message = (fetchController?.object(at: indexPath))?.makeMessage() else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: message)
        return cell
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController?.fetchedObjects?.count ?? 0
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendTap()
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        goToBottom()
    }
}
