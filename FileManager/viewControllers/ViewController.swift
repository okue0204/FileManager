//
//  ViewController.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/18.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private enum FileAction {
        case save
        case read
        case delete
    }
    
    @IBOutlet weak var directoryTextField: UITextField!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var directoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    private lazy var textFields: [UITextField] = [
        directoryTextField, textTextField
    ]
    
    private var disposeBag = Set<AnyCancellable>()
    private var fileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        subscribe()
    }
    
    private func setupLayout() {
        headerView.titleLabel.text = "FileManager(Text)"
        textFields.forEach {
            $0.delegate = self
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1
            $0.textColor = .black
            let placeholderText: String = if $0 == directoryTextField {
                "directory名を入力して下さい"
            } else {
                "文字を入力して下さい"
            }
            $0.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                 attributes: [.foregroundColor: UIColor.lightGray.cgColor])
        }
    }
    
    private func subscribe() {
        headerView.rightButtonPublisher.sink { [weak self] in
            guard let self else {
                return
            }
            if let saveImageViewController = UIStoryboard.saveImageStoryboard.instantiateInitialViewController(creator: { coder in
                SaveImageViewController(coder: coder, title: "FileManager(Image)")
            }) {
                navigationController?.pushViewController(saveImageViewController, animated: true)
            }
        }.store(in: &disposeBag)
    }
    
    private func handleFileAction(fileAction: FileAction) {
        guard let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        switch fileAction {
            // 注意点
            // documentsディレクトリの中にディレクトリを作成して、textなどを入れる時は、ディレクトリを作成して、そこにtextなどを入れないとだめだった。
            // ディレクトリだけ作成しても作成されずdocumentsディレクトリ内に表示されなかった
        case .save:
            do {
                if let text = textTextField.text,
                   !text.isEmpty {
                    let directoryUrl = documentDirectoryFileURL.appendingPathComponent(directoryTextField.text ?? "directoryTest", isDirectory: true)
                    let fileUrl = directoryUrl.appendingPathComponent("\(Date().toString()).txt", conformingTo: .url)
                    try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
                    try text.write(to: fileUrl, atomically: true, encoding: .utf8)
                    directoryTextField.text = nil
                    textTextField.text = nil
                    self.fileUrl = fileUrl
                    view.showToast(title: "テキストの保存が完了しました。")
                }
            } catch {
                showAlert(title: "保存に失敗しました。",
                          actions: [UIAlertAction(title: "OK", style: .default)])
            }
        case .read:
            guard let fileUrl else {
                return
            }
            do {
                let string = try String(contentsOf: fileUrl)
                directoryLabel.text = directoryTextField.text
                titleLabel.text = string
                view.showToast(title: "テキストの読み込みが完了しました。")
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
                titleLabel.text = nil
                view.showToast(title: "テキストの削除を完了しました。")
            } catch {
                showAlert(title: "データの削除に失敗しました。",
                          actions: [UIAlertAction(title: "OK", style: .default)])
            }
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        handleFileAction(fileAction: .save)
    }
    
    @IBAction func didTapShowTextButton(_ sender: Any) {
        handleFileAction(fileAction: .read)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        handleFileAction(fileAction: .delete)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

