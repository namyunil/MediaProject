//
//  GenderViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/09/03.
//


import UIKit
import SnapKit

class GenderViewController: UIViewController {
    
    let textField = {
        let textField = UITextField()
        textField.placeholder = "성별을 입력해주세요"
        return textField
    }()
    
    var delegate: PassGenderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
    }
        
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text {
            delegate?.receiveGender(gender: text)
        }
    }
    
    
    @objc func doneButtonClicked() {
        if let text = textField.text {
            delegate?.receiveGender(gender: text)
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
    
