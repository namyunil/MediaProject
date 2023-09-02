//
//  ProfileViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/29.
//

import UIKit
import SnapKit

protocol PassNameDelegate {
    func receiveName(name: String)
}

protocol PassGenderDelegate {
    func receiveGender(gender: String)
}


class ProfileViewController : UIViewController {
    
    
    var list = ["이름", "사용자 이름", "나이", "소개", "링크", "성별"]
    
    var passName: String?
    var nickName: String?
    var userAge: String?
    var info: String?
    var link: String?
    var userGender: String?
    
    lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
        setConstraints()
        title = "프로필 편집"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectAgeNotificationObserver), name: NSNotification.Name("Age"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectIntroduceNotificationObserver), name: NSNotification.Name("Introduce"), object: nil)
        
        
        tableView.reloadData()
        
    }
    
    
    
    func configureView() {
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func selectAgeNotificationObserver(notification: NSNotification) {
        if let age = notification.userInfo?["age"] as? String {
            userAge = age
        }
    }
    
    @objc func selectIntroduceNotificationObserver(notification: NSNotification) {
        if let introduce = notification.userInfo?["introduce"] as? String {
            info = introduce
        }
        
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell()}
        
        let row = indexPath.row
        
        cell.profileLabel.text = list[row]
        cell.profileContentLabel.text = list[row]
        
        if row == 0 {
            if let name = passName {
                cell.profileContentLabel.text = name
            }
        } else if row == 1 {
            if let name = nickName {
                cell.profileContentLabel.text = name
            }
        } else if row == 2 {
            if let age = userAge {
                cell.profileContentLabel.text = age
            }
        } else if row == 3 {
            if let introduce = info {
                cell.profileContentLabel.text = introduce
            }
        } else if row == 4 {
            if let link = link {
                cell.profileContentLabel.text = link
            }
        } else if row == 5 {
            if let gender = userGender {
                cell.profileContentLabel.text = gender
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if row == 0 {
            let vc = NameViewController()
            vc.delegate = self
            vc.title = list[row]
            navigationController?.pushViewController(vc, animated: true)
            
            
        } else if row == 1 {
            let vc = NickNameViewController()
            vc.title = list[row]
            vc.completionHandler = { nickname in
                self.nickName = nickname
            }
            navigationController?.pushViewController(vc, animated: true)
        } else if row == 2 {
            let vc = AgeViewController()
            vc.title = list[row]
            navigationController?.pushViewController(vc, animated: true)
            
        } else if row == 3 {
            let vc = IntroduceViewController()
            vc.title = list[row]
            navigationController?.pushViewController(vc, animated: true)
            
        } else if row == 4 {
            let vc = LinkViewController()
            vc.completionHandler = { link in
                self.link = link
            }
            vc.title = list[row]
            navigationController?.pushViewController(vc, animated: true)
        } else if row == 5 {
            let vc = GenderViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}


extension ProfileViewController: PassNameDelegate {
    
    func receiveName(name: String) {
        print(name)
        passName = name
        
    }
    
    
}


extension ProfileViewController: PassGenderDelegate {
    
    func receiveGender(gender: String) {
        print(gender)
        userGender = gender
    }
}
