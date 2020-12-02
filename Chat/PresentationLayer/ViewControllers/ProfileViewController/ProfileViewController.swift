//
//  NewProfileViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 11.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ProfileViewControllerDelegate {
    func profileDidUpdate()
}

class ProfileViewController: AbstractViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var saveWithOperationButton: UIButton!
    @IBOutlet weak var saveWithGCDButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIStackView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Vars
    
    var delegate: ProfileViewControllerDelegate?
    
    var editAvatarButton: UIButton = {
        var b = UIButton(type: .system)
        b.setTitle("Edit", for: .normal)
        b.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleEditAvatarButtonPress), for: .touchUpInside)
        return b
    }()
    
    lazy var loadingIndicator: LoadingIndicator = {
        let view = LoadingIndicator()
        view.center = self.view.center
        view.activityIndicator?.backgroundColor = .white
        
        return view
    }()
    
    var isEditMode = false {
        didSet {
            self.handleEditMode()
        }
    }
    
    private var isLoading = false {
        didSet {
            if isLoading {
                loadingIndicator.start()
            } else {
                loadingIndicator.stop()
            }
        }
    }
    
    internal var isNameChanged = false {
        didSet {
            configureButtons()
        }
    }
    internal var isAboutChanged = false {
        didSet {
            configureButtons()
        }
    }
    internal var isAvatarChanged = false {
        didSet {
            configureButtons()
        }
    }
    
    var hasCameraPermissions = false
    var avatarPlaceholderView: UIView?
    var avatarImageView: UIImageView?
    var keyboardIsActive: Bool = false
    var navigationCloseButton: UIBarButtonItem?
    var navigationEditButton: UIBarButtonItem?
    var navigationEditCancelButton: UIBarButtonItem?
    var navigationReadyButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.addTarget(self, action: #selector(onNameFieldChanged(_:)), for: .editingChanged)
        nameTextField.delegate = self
        aboutTextView.delegate = self
        
        nameTextField.returnKeyType = .done
        
        configureView()
        requestCameraPermissions()
        configureNavigation()
        fillUserData()
    }
    
    override func applyTheme(theme: ITheme) {
        super.applyTheme(theme: theme)
        
        nameTextField.textColor = theme.mainTextColor
        aboutTextView.textColor = theme.mainTextColor
        saveWithOperationButton.backgroundColor = theme.buttonBackgroundColor
        saveWithGCDButton.backgroundColor = theme.buttonBackgroundColor
    }
    
    // MARK: - Inner functions
    
    private func configureNavigation() {
        navigationCloseButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(handleNavigationCloseButtonTap))
        navigationEditButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(handleNavigationEditButtonTap))
        navigationEditCancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleNavigationEditCancelButtonTap))
        navigationReadyButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(handleNavigationEditCancelButtonTap))
        title = "My Profile"
        navigationItem.leftBarButtonItem = navigationCloseButton
        navigationItem.rightBarButtonItem = navigationEditButton
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureView() {
        isEditMode = false
        saveWithOperationButton.layer.cornerRadius = 14
        saveWithGCDButton.layer.cornerRadius = 14

        scrollView.isScrollEnabled = false
        view.addSubview(editAvatarButton)
        view.addSubview(loadingIndicator)
        
        let constr = [
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 0),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 0)
        ]

        NSLayoutConstraint.activate(constr)
        
        nameTextField.isAccessibilityElement = true
        nameTextField.accessibilityIdentifier = "ProfileNameTextField"
        
        
        aboutTextView.isAccessibilityElement = true
        aboutTextView.accessibilityIdentifier = "ProfileAboutTextView"
    }
    
    internal func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureButtons() {
        let isChanged = isNameChanged || isAboutChanged || isAvatarChanged
        saveWithOperationButton.isEnabled = isChanged
        saveWithGCDButton.isEnabled = isChanged
    }
    
    private func adjustScrollView(to height: CGFloat) {
        scrollView.contentInset.bottom += height
        scrollView.scrollIndicatorInsets.bottom += height
        if height < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)// take this constant
        }
    }
    
    func handleEditMode() {
        if isEditMode {
            navigationItem.rightBarButtonItem = navigationEditCancelButton
            editAvatarButton.alpha = 1
            nameTextField.isUserInteractionEnabled = true
            aboutTextView.isEditable = true
            aboutTextView.isSelectable = true
            nameTextField.borderStyle = .roundedRect
            aboutTextView.layer.borderWidth = 1
            aboutTextView.layer.borderColor = UIColor.lightGray.cgColor
            saveWithOperationButton.isEnabled = false
            saveWithGCDButton.isEnabled = false
            buttonContainerView.isHidden = false
            editButton.addShakeAnimation()
        } else {
            nameTextField.isUserInteractionEnabled = false
            nameTextField.borderStyle = .none
            aboutTextView.isEditable = false
            aboutTextView.isSelectable = false
            aboutTextView.layer.borderWidth = 0
            navigationItem.rightBarButtonItem = navigationEditButton
            editAvatarButton.alpha = 0
            buttonContainerView.isHidden = true
            editButton.removeShakeAnimation()
        }
    }
    
    // Установка данных пользователя
    private func fillUserData() {
        guard let profile = presentationAssembly?.profileManager.profile else { return }
        isNameChanged = false
        isAboutChanged = false
        isAvatarChanged = false
        nameTextField.text = profile.name
        aboutTextView.text = profile.about
        
        if let avatar = profile.avatar {
            drawAvatar(with: avatar)
        } else {
            drawAvatarPlaceholder(for: profile.name)
        }
    }
    
    // Отрисовка placeholder вместо аватара
    private func drawAvatarPlaceholder(for name: String) {
        let avatarPlaceholderView = AvataViewPlaceholder(frame: CGRect(x: 0, y: 0, width: avatarView.frame.width, height: avatarView.frame.height))
        avatarPlaceholderView.isUserInteractionEnabled = false
        avatarPlaceholderView.userName = name
        avatarPlaceholderView.labelFontSize = 120
        avatarView.addSubview(avatarPlaceholderView)
        self.avatarPlaceholderView = avatarPlaceholderView
    }
    
    // Отрисовка аватара пользователя
    internal func drawAvatar(with image: UIImage) {
        if let avatarPlaceholderView = self.avatarPlaceholderView {
            avatarPlaceholderView.removeFromSuperview()
        }
        if let avatarImageView = avatarImageView {
            avatarImageView.image = image
        } else {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: avatarView.frame.width, height: avatarView.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = imageView.frame.width / 2
            imageView.clipsToBounds = true
            avatarView.addSubview(imageView)
            avatarImageView = imageView
        }
    }
    
    // MARK: - IBActions
    @IBAction func handleEditButtonTap(_ sender: UIButton) {
        isEditMode = !isEditMode
    }
    
    @IBAction func handleTapOnView(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @IBAction func handleSaveTap(_ sender: UIButton) {
        guard let newName = nameTextField.text, let newAbout = aboutTextView.text else {
            return
        }
        
        let newImage = avatarImageView?.image
        if newName.isEmpty {
            customError(message: "Необходимо заполнить имя пользователя")
            return
        }
        
        if newAbout.isEmpty {
            customError(message: "Необходимо заполнить информацию о себе")
            return
        }
        isLoading = true
        
        var changedData = [String: Any]()
        if isNameChanged { changedData["name"] = newName }
        if isAboutChanged { changedData["about"] = newAbout }
        if isAvatarChanged { changedData["avatar"] = newImage}
        
        let save = sender.tag == 0 ? presentationAssembly?.profileManager.saveWithGCD : presentationAssembly?.profileManager.saveWithOperation
        
        save?(changedData) { [weak self] (results) in
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.profileDidUpdate()
            }
            let isOk = !results.values.contains(false)
            if isOk {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.successAlert()
                    self?.navigationItem.rightBarButtonItem = self?.navigationReadyButton
                    self?.fillUserData()
                }
                return
            }
            let nothingWasSaved = !results.values.contains(true)
            if nothingWasSaved {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorAlert { (_) in
                        self?.handleSaveTap(sender)
                    }
                }
                return
            }
            
            var fieldsWithErrors = [String]()
            
            results.forEach { (key, value) in
                if !value, let fieldName = ProfileFields(rawValue: key)?.getFieldName() {
                    fieldsWithErrors.append(fieldName)
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                self?.someFieldsNotSavedAlert(fields: fieldsWithErrors)
                self?.fillUserData()
            }
        }
    }
    
    // MARK: - Alerts
    
    func successAlert() {
        if let alert = presentationAssembly?.alertManager.alert(title: "Данные сохранены") {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func customError(message: String) {
        if let alert = presentationAssembly?.alertManager.error(message: message) {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func errorAlert(repeatAction: ((UIAlertAction) -> Void)?) {
        if let alert = presentationAssembly?.alertManager.error(message: "Не удалось сохранить данные", repeatAction: repeatAction) {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func someFieldsNotSavedAlert(fields: [String]) {
        if let alert = presentationAssembly?.alertManager.alert(title: "Данные сохранены неполностью",
                                                                message: "Поля, которые не удалось сохранить: \(fields.joined(separator: ", "))") {
            present(alert, animated: true, completion: nil)
        }
    }
    
    func navigateToPhotosView() {
        guard let photoVC = presentationAssembly?.viewControllerFactory.makeChoosePhotoViewController() else { return }
        photoVC.photoPickerDelegate = self
        let navController = UINavigationController(rootViewController: photoVC)
        navController.applyTheme(theme: presentationAssembly?.themeManager.theme)
        present(navController, animated: true)
    }
    
    // MARK: - handlers
    
    @objc
    func handleNavigationEditButtonTap() {
        isEditMode = true
    }
    
    @objc
    func handleNavigationEditCancelButtonTap() {
        fillUserData()
        isEditMode = false
    }
    
    @objc
    func handleNavigationCloseButtonTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleKeyboardAppearance(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        if isShowing != keyboardIsActive {
            keyboardIsActive = isShowing
            let adjustmentHeight = (keyboardFrame.height + 45) * (isShowing ? 1 : -1)
            adjustScrollView(to: adjustmentHeight)
        }
    }
    
    @objc
    func handleEditAvatarButtonPress(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCameraAction = UIAlertAction(title: "Камера", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            if self.isCameraAvailable() && self.hasCameraPermissions {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
        }
        alert.addAction(openCameraAction)
        
        let photoLibraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            if self.isPhotoLibraryAvailable() {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
        }
        alert.addAction(photoLibraryAction)
        
        let loadAction = UIAlertAction(title: "Загрузить", style: .default) { [weak self] (_) in
            self?.navigateToPhotosView()
        }
        alert.addAction(loadAction)

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc private func onNameFieldChanged(_ sender: UITextField) {
        guard let text = sender.text, let profile = presentationAssembly?.profileManager.profile else {
            return
        }
        
        isNameChanged = text.trimmingCharacters(in: .whitespacesAndNewlines) != profile.name
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {}
