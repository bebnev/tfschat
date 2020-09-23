//
//  ProfileViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 21.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import AVFoundation

struct UserProfile {
    let name: String
    let about: String
    var avatar: UIImage?
}

class ProfileViewController: ViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var editAvatarButton: UIButton!
    
    // MARK:- Vars
    
    var hasCameraPermissions = false
    var avatarPlaceholderView: UIView?
    
    // MARK:- Data
    
    var user = UserProfile(name: "Marina Dudarenko", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Разница в значениях может получиться из-за того, что метод viewDidAppear вызывается уже после того, как механизм autolayout отработал
        // и все вложенные вьюхи отрисовались и сама вьюха была добавлена в иерархию вьюх. viewDidLoad же вызывается до autolayout, когда вьюха
        // загружена в память
        Log.debug("Save Button frame at viewDidAppear: \(saveProfileButton.frame)")
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
        let avatarPlaceholderView = UIView(frame: CGRect(x: 0, y: 0, width: avatarView.frame.width, height: avatarView.frame.height))
        avatarPlaceholderView.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        avatarPlaceholderView.layer.cornerRadius = avatarPlaceholderView.bounds.width / 2
        avatarPlaceholderView.isUserInteractionEnabled = false
        avatarView.addSubview(avatarPlaceholderView)
        
        self.avatarPlaceholderView = avatarPlaceholderView
        
        let placeholderNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        placeholderNameLabel.text = String(name.getAcronyms().prefix(2))
        placeholderNameLabel.textColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
        placeholderNameLabel.font = UIFont(name: "Roboto-Regular", size: 120)
        placeholderNameLabel.textAlignment = .center
        placeholderNameLabel.backgroundColor = .clear
        placeholderNameLabel.numberOfLines = 1
        placeholderNameLabel.sizeToFit()
        placeholderNameLabel.center = avatarPlaceholderView.center

        avatarPlaceholderView.addSubview(placeholderNameLabel)
    }
    
    /**
     * Отрисовка аватара пользователя
     */
    private func drawAvatar(with image: UIImage) {
        if let avatarPlaceholderView = self.avatarPlaceholderView {
            avatarPlaceholderView.removeFromSuperview()
        }
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.avatarView.frame.width, height: self.avatarView.frame.height)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
        self.avatarView.addSubview(imageView)
    }
    
    //MARK:- IBActions
    
    @IBAction func handleEditAvatarButtonPress(_ sender: UIButton) {
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
        
        user.avatar = image
        
        DispatchQueue.main.async {
            self.drawAvatar(with: image)
        }
        
        dismiss(animated: true)
    }
}

// MARK:- UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {}