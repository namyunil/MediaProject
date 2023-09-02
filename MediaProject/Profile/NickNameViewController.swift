//
//  NickNameViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/09/03.
//

import UIKit
import SnapKit

class NickNameViewController: UIViewController {
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요."
        return textField
    }()
    
    var completionHandler: ((String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let text = textField.text {
            completionHandler?(text)
        }
    }
    
    func configureView() {
        view.addSubview(textField)
    }
    
    func setConstraints() {
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
    

