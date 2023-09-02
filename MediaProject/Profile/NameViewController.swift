//
//  NameViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/30.
//

import UIKit
import SnapKit

class NameViewController: UIViewController {
    
    var delegate: PassNameDelegate?
    
    var completionHandler: ((String) -> ())?
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력해주세요"
        return textField
    }()
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let text = textField.text {
            delegate?.receiveName(name: text)
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

