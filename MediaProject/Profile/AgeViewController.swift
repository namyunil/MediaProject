//
//  AgeViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/09/03.
//

import UIKit

class AgeViewController: UIViewController {
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "나이를 입력해주세요"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text {
            NotificationCenter.default.post(name: NSNotification.Name("Age"), object: nil, userInfo: ["age" : text])
            
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
    

