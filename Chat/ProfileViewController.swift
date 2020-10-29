//
//  NewProfileViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 11.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ProfileProviderDelegate {
    func setNewProfile(user: User)
}

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var saveWithOperationButton: UIButton!
    @IBOutlet weak var saveWithGCDButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIStackView!
    
    @IBOutlet weak var nameTextField: UITextField!
    // MARK:- Vars
    
    var profileDelegate: ProfileProviderDelegate?
    
    var editAvatarButton: UIButton = {
        var b = UIButton(type: .system)
        b.setTitle("Edit", for: .normal)
        b.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleEditAvatarButtonPress), for: .touchUpInside)
        return b
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = view.center
        return indicator
    }()
    
    var isEditMode = false {
        didSet {
            self.handleEditMode()
        }
    }
    
    private var isLoading = false {
        didSet {
            if isLoading {
                loadingIndicator.startAnimating()
                loadingIndicator.backgroundColor = UIColor.white
            } else {
                loadingIndicator.stopAnimating()
                loadingIndicator.hidesWhenStopped = true
            }
        }
    }
    
    private var isNameChanged = false {
        didSet {
            saveWithOperationButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
            saveWithGCDButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
        }
    }
    private var isAboutChanged = false {
        didSet {
            saveWithOperationButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
            saveWithGCDButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
        }
    }
    private var isAvatarChanged = false {
        didSet {
            saveWithOperationButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
            saveWithGCDButton.isEnabled = isNameChanged || isAboutChanged || isAvatarChanged
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
    
    // MARK:- Data
    
    var user = Profile.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.addTarget(self, action: #selector(onNameFieldChanged(_:)), for: .editingChanged)
        nameTextField.delegate = self
        aboutTextView.delegate = self
        
        nameTextField.returnKeyType = .done
        
        setupView()
        requestCameraPermissions()
        setupNavigation()
        fillUserData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func applyTheme(theme: ThemeProtocol) {
        super.applyTheme(theme: theme)
        
        nameTextField.textColor = theme.mainTextColor
        aboutTextView.textColor = theme.mainTextColor
        saveWithOperationButton.backgroundColor = theme.buttonBackgroundColor
        saveWithGCDButton.backgroundColor = theme.buttonBackgroundColor
    }
    
    // MARK:- Inner functions
    
    private func setupNavigation() {
        navigationCloseButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(handleNavigationCloseButtonTap))
        navigationEditButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(handleNavigationEditButtonTap))
        navigationEditCancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleNavigationEditCancelButtonTap))
        navigationReadyButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(handleNavigationEditCancelButtonTap))
        
        title = "My Profile"
        
        navigationItem.leftBarButtonItem = navigationCloseButton
        navigationItem.rightBarButtonItem = navigationEditButton
    }
    
    private func setupView() {
        isEditMode = false
        saveWithOperationButton.layer.cornerRadius = 14
        saveWithGCDButton.layer.cornerRadius = 14

        scrollView.isScrollEnabled = false
        view.addSubview(editAvatarButton)
        view.addSubview(loadingIndicator)
        
        let constr = [
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 0),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 0),
        ]

        NSLayoutConstraint.activate(constr)
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func adjustScrollView(to height: CGFloat) {
        scrollView.contentInset.bottom += height
        scrollView.scrollIndicatorInsets.bottom += height
//
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
        } else {
            nameTextField.isUserInteractionEnabled = false
            nameTextField.borderStyle = .none
            aboutTextView.isEditable = false
            aboutTextView.isSelectable = false
            aboutTextView.layer.borderWidth = 0
            navigationItem.rightBarButtonItem = navigationEditButton
            editAvatarButton.alpha = 0
            buttonContainerView.isHidden = true
        }
    }
    
    /**
     * Установка данных пользователя
     */
    private func fillUserData() {
        isNameChanged = false
        isAboutChanged = false
        isAvatarChanged = false
        nameTextField.text = user.name
        aboutTextView.text = user.about
        
        if let avatar = user.avatar {
            drawAvatar(with: avatar)
        } else {
            drawAvatarPlaceholder(for: user.name ?? "")
        }
    }
    
    /**
     * Отрисовка placeholder вместо аватара
     */
    private func drawAvatarPlaceholder(for name: String) {
        let avatarPlaceholderView = AvataViewPlaceholder(frame: CGRect(x: 0, y: 0, width: avatarView.frame.width, height: avatarView.frame.height))
        avatarPlaceholderView.isUserInteractionEnabled = false
    
        avatarPlaceholderView.userName = name
        avatarPlaceholderView.labelFontSize = 120
        avatarView.addSubview(avatarPlaceholderView)
        
        self.avatarPlaceholderView = avatarPlaceholderView
    }
    
    /**
     * Отрисовка аватара пользователя
     */
    private func drawAvatar(with image: UIImage) {
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
    
    func saveProfile(profileManager: ProfileDataManager) {
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
        
        if isNameChanged {
            changedData["name"] = newName
        }
        
        if isAboutChanged {
            changedData["about"] = newAbout
        }
        
        if isAvatarChanged {
            changedData["avatar"] = newImage
        }
        
        profileManager.save(data: changedData) { (results) in
            let isOk = !results.values.contains(false)
            
            if (isOk) {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.successAlert()
                    self?.user = Profile.shared.currentUser
                    self?.profileDelegate?.setNewProfile(user: Profile.shared.currentUser)
                    self?.navigationItem.rightBarButtonItem = self?.navigationReadyButton
                    self?.fillUserData()
                }
                return
            }
            
            let nothingWasSaved = !results.values.contains(true)
            
            if nothingWasSaved {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorAlert { (alertAction) in
                        self?.saveProfile(profileManager: profileManager)
                    }
                }
                return
            }
            
            var fieldsWithErrors = [String]()
            
            results.forEach { (key, value) in
                if !value, let fieldName = UserFields(rawValue: key)?.getFieldName() {
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
    
    // MARK:- IBActions
    
    @IBAction func handleTapOnView(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @IBAction func handleSaveTap(_ sender: UIButton) {
        let profileManager: ProfileDataManager
        switch sender.tag {
        case 0:
            profileManager = ProfileGCDDataManger(profile: Profile.shared)
        case 1:
            profileManager = ProfileOperationDataManager(profile: Profile.shared)
        default:
            return
            
        }
        saveProfile(profileManager: profileManager)
    }
    
    // MARK:- alerts
    
    func successAlert() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func customError(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func errorAlert(repeatAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default, handler: repeatAction)
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func someFieldsNotSavedAlert(fields: [String]) {
        let alertController = UIAlertController(title: "Данные сохранены неполностью", message: "Поля, которые не удалось сохранить: \(fields.joined(separator: ", "))", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- handlers
    
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
        // TODO: apply theme
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if isCameraAvailable() && hasCameraPermissions {
            let openCameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
            alert.addAction(openCameraAction)
        }
        
        if isPhotoLibraryAvailable() {
            let photoLibraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (action) in
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
            alert.addAction(photoLibraryAction)
        }
        

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc private func onNameFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        isNameChanged = text.trimmingCharacters(in: .whitespacesAndNewlines) != user.name
    }
}


extension ProfileViewController {
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    
    func requestCameraPermissions() {
        if !isCameraAvailable() {
            return
        }
        
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraAuthStatus {
            case .authorized:
                hasCameraPermissions = true
            case .denied, .restricted:
                hasCameraPermissions = false
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                    { (authorized) in
                        self.hasCameraPermissions = authorized
                })
            @unknown default:
                hasCameraPermissions = false
        }
    }
}

// MARK:- UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        isAvatarChanged = image != user.avatar
        
        DispatchQueue.main.async {
            self.drawAvatar(with: image)
        }
        
        dismiss(animated: true)
    }
}

// MARK:- UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {}

// MARK:- UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            isNameChanged = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != user.name
        case 1:
            isAboutChanged = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != user.about
        default:
            return
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 && text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        return false
    }
}
