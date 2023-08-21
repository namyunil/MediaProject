//
//  DetailTrendingViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/16.
//

import UIKit
import Kingfisher

class DetailTrendingViewController: UIViewController {

    
    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var movieBackView: UIImageView!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var section: [String] = ["OverView", "Cast"]
    var overview: String = ""
    var backImage: String = ""
    var poster: String = ""
    var movieTitle: String = ""
    
    var actorData: [Actor] = []
    
    
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
        
        
    }
    


}

extension DetailTrendingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return actorData.count
        } else {
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTrendingTableViewCell", for: indexPath) as? DetailTrendingTableViewCell else { return UITableViewCell() }
        
        let row = actorData[indexPath.row]
        if indexPath.section == 0 {
            cell.overviewLabel.numberOfLines = 0
            cell.overviewLabel.font = .systemFont(ofSize: 13)
            cell.overviewLabel.text = overview
            cell.actorNameLabel.text = ""
            cell.roleNameLabel.text = ""
            
            
        } else if indexPath.section == 1 {
            cell.overviewLabel.text = ""
            cell.actorNameLabel.text = row.name
            cell.actorNameLabel.font = .boldSystemFont(ofSize: 15)
            cell.roleNameLabel.text = row.character
            cell.roleNameLabel.textColor = .lightGray
            cell.roleNameLabel.font = .systemFont(ofSize: 13)
            
            cell.actorImageView.kf.setImage(with: URL(string: row.image))
        }
        
        return cell
    }
    
    
    
}
