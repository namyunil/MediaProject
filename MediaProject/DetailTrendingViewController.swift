//
//  DetailTrendingViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/16.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON


struct Actor {
    var name: String
    var character: String
    var image: String
}

struct Crew {
    var name: String
    var job: String
    var image: String
}

class DetailTrendingViewController: UIViewController {
    
    
    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var movieBackView: UIImageView!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var section: [String] = ["OverView", "Cast", "Crew"]
    var overview: String = ""
    var backImage: String = ""
    var poster: String = ""
    var movieTitle: String = ""
    var id: Int = 0
    
    var actorList: [Actor] = []
    var crewList: [Crew] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "출연/제작"
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        let nib = UINib(nibName: "DetailTrendingTableViewCell", bundle: nil)
        movieTableView.register(nib, forCellReuseIdentifier: "DetailTrendingTableViewCell")
        
        movieBackView.kf.setImage(with: URL(string: backImage))
        moviePosterImageView.kf.setImage(with: URL(string: poster))
        
        titleLabel.text = movieTitle
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        callCreditRequest(id: id)
        
        movieTableView.reloadData()
        movieTableView.rowHeight = 160
        
        
    }
    
    
    


func callCreditRequest(id: Int) {
    
    let url = "https://api.themoviedb.org/3/movie/\(id)/credits?language=ko-kr"
    let header: HTTPHeaders = ["Authorization": APIKey.Token]
    
    AF.request(url, method: .get, headers: header).validate().responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            //                                print("JSON: \(json)")
            
            for items in json["cast"].arrayValue {
                let name = items["name"].stringValue
                let character = items["character"].stringValue
                let image = "https://image.tmdb.org/t/p/original" + items["profile_path"].stringValue
                
                let actorData = Actor(name: name, character: character, image: image)
                self.actorList.append(actorData)
                self.movieTableView.reloadData()
                
            }
            
            
            for items in json["crew"].arrayValue {
                let name = items["name"].stringValue
                let job = items["job"].stringValue
                let image = items["profile_path"].stringValue
                
                let crewData = Crew(name: name, job: job, image: image)
                self.crewList.append(crewData)
                self.movieTableView.reloadData()
            }
            print("==\(self.actorList)==")
            print("==\(self.crewList)==")
            
        case .failure(let error):
            print(error)
        }
    }
}


}

extension DetailTrendingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "overview"
        } else if section == 1 {
            return "cast"
        } else if section == 2 {
            return "crew"
        } else {
            return ""
        }
    }
    
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return actorList.count
        } else {
            return crewList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTrendingTableViewCell", for: indexPath) as? DetailTrendingTableViewCell else { return UITableViewCell() }
        
        //        let row = actorData[indexPath.row]
        if indexPath.section == 0 {
            cell.overviewLabel.numberOfLines = 0
            cell.overviewLabel.font = .systemFont(ofSize: 13)
            cell.overviewLabel.text = overview
            cell.actorNameLabel.isHidden = true
            cell.roleNameLabel.isHidden = true
            cell.actorImageView.isHidden = true
            
            
        } else if indexPath.section == 1 {
            cell.overviewLabel.text = ""
            cell.actorNameLabel.text = actorList[indexPath.row].name
            cell.actorNameLabel.font = .boldSystemFont(ofSize: 15)
            cell.roleNameLabel.text = actorList[indexPath.row].character
            cell.roleNameLabel.textColor = .lightGray
            cell.roleNameLabel.font = .systemFont(ofSize: 13)
            
            cell.actorImageView.kf.setImage(with: URL(string: actorList[indexPath.row].image))
            cell.actorImageView.layer.cornerRadius = 10
        } else {
            cell.overviewLabel.text = ""
            cell.actorNameLabel.text = crewList[indexPath.row].name
            cell.actorNameLabel.font = .boldSystemFont(ofSize: 15)
            cell.roleNameLabel.text = crewList[indexPath.row].job
            cell.roleNameLabel.textColor = .lightGray
            cell.roleNameLabel.font = .systemFont(ofSize: 13)
            
            cell.actorImageView.kf.setImage(with: URL(string: crewList[indexPath.row].image))
            cell.actorImageView.layer.cornerRadius = 20
        }
        
        return cell
    }
    
    
    
}
