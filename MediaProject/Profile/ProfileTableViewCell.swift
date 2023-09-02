//
//  ProfileTableViewCell.swift
//  MediaProject
//
//  Created by NAM on 2023/08/29.
//

import UIKit
import SnapKit


class ProfileTableViewCell: UITableViewCell {
    
    let profileView = {
        let backView = UIView()
        backView.backgroundColor = .white
        return backView
    }()
    
    let profileLabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let profileContentLabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        return label
    }()
    
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { // CollectionView와 초기화 구문의 차이를 인지하자..!
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        setConstrints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    func configureView() { //tableViewCell에서는 contentView에 추가해줘야한다!
        contentView.addSubview(profileView)
        contentView.addSubview(profileLabel)
        contentView.addSubview(profileContentLabel)
        contentView.backgroundColor = .white
    }
    
    func setConstrints() {
        profileView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.3)
        }
        
        
        profileLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            
            
        }
        
        profileContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(18)
            make.centerY.equalTo(contentView)
        }
    }
    
}
