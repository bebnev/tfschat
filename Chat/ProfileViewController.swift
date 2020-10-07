//
//  ProfileViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 21.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: BaseViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var editAvatarButton: UIButton!
    
    // MARK:- Vars
    
    var hasCameraPermissions = false
    var avatarPlaceholderView: UIView?
    var avatarImageView: UIImageView?
    
    // MARK:- Data
    
    var user: User?
    
    // MARK:- Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // На строке с логом происходит падение приложения по причине force unwrapp --> weak var saveProfileButton: UIButton!
        // Инициализация ViewController происходит в самом начале, когда вьюха контроллера еще не загрузилась, поэтому кнопки еще не существует
        //Log.debug(saveProfileButton.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.debug("Save Button frame at viewDidLoad: \(saveProfileButton.frame)")
        
        setupView()
        requestCameraPermissions()
        fillUserData()
        title = "My Profile"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(handleNavigationCloseButtonTap))
    }
    
    @objc
    func handleNavigationCloseButtonTap() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Разница в значениях может получиться из-за того, что метод viewDidAppear вызывается уже после того, как механизм autolayout отработал
        // и все вложенные вьюхи отрисовались и сама вьюха была добавлена в иерархию вьюх, соответственно все получили свои реальные размеры
        // и расположение. viewDidLoad же вызывается до autolayout, когда вьюха просто загружена в память
        Log.debug("Save Button frame at viewDidAppear: \(saveProfileButton.frame)")
    }
    
    override func applyTheme(theme: ThemeProtocol) {
        super.applyTheme(theme: theme)
        
        nameLabel.textColor = theme.mainTextColor
        aboutLabel.textColor = theme.mainTextColor
        saveProfileButton.backgroundColor = theme.buttonBackgroundColor
    }
    
    // MARK:- Inner functions
    
    private func setupView() {
        saveProfileButton.layer.cornerRadius = 14
        editAvatarButton.isHidden = !(isCameraAvailable() || isPhotoLibraryAvailable())
    }
    
    /**
     * Установка данных пользователя 
     */
    private func fillUserData() {
        guard let user = user else {
            return
        }
        
        nameLabel.text = user.name
        aboutLabel.text = user.about
        aboutLabel.setLetterSpacing(-0.33)
        aboutLabel.setLineHeight(1.15)
        
        if let avatar = user.avatar {
            drawAvatar(with: avatar)
        } else {
            drawAvatarPlaceholder(for: user.name)
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
    
    //MARK:- IBActions
    
    @IBAction func handleEditAvatarButtonPress(_ sender: UIButton) {
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
    
    @IBAction func handleSaveButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- camera+photos utils

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
        
        user?.avatar = image
        
        DispatchQueue.main.async {
            self.drawAvatar(with: image)
        }
        
        dismiss(animated: true)
    }
}

// MARK:- UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {}
