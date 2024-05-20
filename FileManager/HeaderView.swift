//
//  HeaderView.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/18.
//

import UIKit
import Combine

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    private let rightButtonSubject = PassthroughSubject<Void, Never>()
    lazy var rightButtonPublisher = rightButtonSubject.eraseToAnyPublisher()
    private let leftButtonSubject = PassthroughSubject<Void, Never>()
    lazy var leftButtonPublisher = leftButtonSubject.eraseToAnyPublisher()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    @IBInspectable var isShowRightButton: Bool {
        get {
            rightButton.isHidden
        }
        set {
            rightButton.isHidden = !newValue
        }
    }
    
    @IBInspectable var isShowLeftButton: Bool {
        get {
            leftButton.isHidden
        }
        set {
            leftButton.isHidden = !newValue
        }
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        guard let view = UINib(nibName: String(describing: Self.self), bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        rightButtonSubject.send(())
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        leftButtonSubject.send(())
    }
}
