//
//  LinkViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/09/03.
//

import UIKit
import SnapKit

class LinkViewController: UIViewController {
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "링크를 입력해주세요"
        return textField
    }()
    
    var completionHandler: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
    }
        
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text {
            completionHandler?(text)
        }
    }
    
    
    @objc func doneButtonClicked() {
        if let text = textField.text {
           completionHandler?(text)
        }
        
        navigationController?.popViewController(animated: true)
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
    


