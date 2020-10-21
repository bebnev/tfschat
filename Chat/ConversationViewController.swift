//
//  ConversationViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 28.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import Firebase

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
    
//    var conversation: ConversationCellModel? = ConversationCellModel(name: "Anton Bebnev", message: "Hello man", date: Date(), isOnline: true, hasUnreadMessages: true, avatar: UIImage(named: "man_6")!)
    var channel: Channel?
    
    var fieldContainerViewBottomAnchor: NSLayoutConstraint?
    
    var messages = [Message]()
    
    var messagesListener: ListenerRegistration?
    
    var viewHasAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        setupKeyboardObservers()
        
        isMessagesLoading = true
        setupMessagesObserver()
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
    
    override func applyTheme(theme: ThemeProtocol) {
        super.applyTheme(theme: theme)
        tableView.backgroundColor = theme.mainBackgroundColor
        titleLabel.textColor = theme.mainTextColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        messagesListener?.remove()
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
    
    func setupMessagesObserver() {
        guard let channel = channel else {
            isMessagesLoading = false
            return
        }
        
        messagesListener = FireBaseApi.shared.subscribeToMessages(id: channel.identifier) { [weak self] (messages, error) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.isMessagesLoading = false
                    self?.errorAlert("Произошла нештатная ситуация. Повторите попытку позже")
                }

                return
            }

            if let messages = messages {
                self?.messages = messages
            }

            DispatchQueue.main.async { [weak self] in
                self?.isMessagesLoading = false
                self?.tableView.reloadData()
                self?.goToBottom()
                //self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    private func goToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
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
        print("handleViewTap")
        dismissKeyboard()
    }
    
    @objc
    func handleSendTap() {
        print("handleSendTap")
        dismissKeyboard()
        
        guard let content = inputField.text, let userId = Sender.shared.userId, let channel = channel else {
            return
        }
        
        if content.isEmpty {
            return
        }
        
        let message = Message(content: content, created: Date(), senderId: userId, senderName: Sender.shared.name)
        
        FireBaseApi.shared.addMessage(channelId: channel.identifier, message: message) {[weak self] isOk in
            if isOk {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as? ConversationMessageTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendTap()
        return true
    }
}
