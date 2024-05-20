//
//  SaveImageViewController.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/19.
//

import UIKit
import Combine
import PhotosUI

class SaveImageViewController: UIViewController {
    
    private enum FileAction {
        case save
        case read
        case delete
    }
    
    private enum PictureType {
        case take
        case album
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerView: HeaderView! {
        didSet {
            headerView.titleLabel.text = headerTitle
        }
    }
    
    private var fileUrl: URL?
    private var disposeBag = Set<AnyCancellable>()
    
    private let headerTitle: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        subscribe()
    }
    
    init?(coder: NSCoder, title: String) {
        self.headerTitle = title
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        headerView.isShowRightButton = false
        
        textField.delegate = self
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.attributedPlaceholder = NSAttributedString(string: "画像のタイトルを入力して下さい",
                                                             attributes: [.foregroundColor: UIColor.lightGray.cgColor])
    }
    
    private func subscribe() {
        headerView.leftButtonPublisher.sink { [weak self] in
            guard let self else {
                return
            }
            navigationController?.popViewController(animated: true)
        }.store(in: &disposeBag)
    }
    
    private func handlePicture(pictureType: PictureType) {
        switch pictureType {
        case .take:
            showCamera()
        case .album:
            showAlbum()
        }
    }
    
    private func handleFileAction(fileAction: FileAction) {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        switch fileAction {
        case .save:
            do {
                let directoryUrl = documentsDirectoryUrl.appendingPathComponent(textField.text ?? "TestDirectory", conformingTo: .url)
                let fileUrl = directoryUrl.appendingPathComponent("\(Date().toString()).jpeg", conformingTo: .url)
                try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
                let imageData = imageView.image?.jpegData(compressionQuality: 1.0)
                try imageData?.write(to: fileUrl)
                self.fileUrl = fileUrl
                imageView.image = nil
                view.showToast(title: "画像の保存が完了しました。")
            } catch {
                showAlert(title: "保存に失敗しました。",
                          actions: [UIAlertAction(title: "OK", style: .default)])
            }
        case .read:
            guard let fileUrl else {
                return
            }
            do {
                let imageData = try Data(contentsOf: fileUrl)
                imageView.image = UIImage(data: imageData)
                view.showToast(title: "画像の読み込みが完了しました。")
            } catch {
                showAlert(title: "データの読み込みに失敗しました。",
                          actions: [UIAlertAction(title: "OK", style: .default)])
            }
        case .delete:
            guard let fileUrl else {
                return
            }
            do {
                try FileManager.default.removeItem(at: fileUrl)
                view.showToast(title: "画像の削除が完了しました。")
            } catch {
                showAlert(title: "データの削除に失敗しました。",
                          actions: [UIAlertAction(title: "OK", style: .default)])
            }
        }
    }
    
    private func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
    }
    
    private func showAlbum() {
        var phpickerConfiguration = PHPickerConfiguration()
        phpickerConfiguration.filter = .images
        let phpickerViewController = PHPickerViewController(configuration: phpickerConfiguration)
        phpickerViewController.delegate = self
        present(phpickerViewController, animated: true)
    }
    
    @IBAction func didTapTakePictureButton(_ sender: Any) {
        handlePicture(pictureType: .take)
    }
    
    @IBAction func didTapSelectAlbumButton(_ sender: Any) {
        handlePicture(pictureType: .album)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        handleFileAction(fileAction: .save)
    }
    
    @IBAction func didTapShowImageButton(_ sender: Any) {
        handleFileAction(fileAction: .read)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        handleFileAction(fileAction: .delete)
    }
}

extension SaveImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true)
    }
}

extension SaveImageViewController: UINavigationControllerDelegate {
    
}

extension SaveImageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] provider, error in
                guard let self else {
                    return
                }
                if let image = provider as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else {
                            return
                        }
                        imageView.image = image
                        picker.dismiss(animated: true)
                    }
                }
            }
        } else {
            picker.dismiss(animated: true)
        }
    }
}

extension SaveImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
