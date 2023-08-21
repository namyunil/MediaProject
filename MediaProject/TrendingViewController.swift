//
//  TrendingViewController.swift
//  MediaProject
//
//  Created by NAM on 2023/08/16.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Movie {
    var date: String
    var title: String
    var originalTitle: String
    var image: String
    var overview: String
    var ratings: Double
    var id: Int
    var poster: String
    var genre: String
}


class TrendingViewController: UIViewController {
    
    @IBOutlet var movieCollectionView: UICollectionView!
    
    var movieList: [Movie] = []
    var actorList: [Actor] = []
    
    var genre: [Int : String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        setCollectionViewLayout()
        
        callRequest()
        
        
        let nib = UINib(nibName: "TrendingCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        
    }
    
    
    func callRequest() {
        
        
        let url =  "https://api.themoviedb.org/3/trending/movie/day?language=ko-kr"
        let header: HTTPHeaders = ["Authorization": APIKey.Token]
        
        
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
                for items in json["results"].arrayValue {
                    let date = items["release_date"].stringValue
                    let title = items["title"].stringValue
                    let originalTitle = items["original_title"].stringValue
                    let image = "https://image.tmdb.org/t/p/original" + items["backdrop_path"].stringValue
                    let overview = items["overview"].stringValue
                    let ratings = items["vote_average"].doubleValue
                    let poster = "https://image.tmdb.org/t/p/original" + items["poster_path"].stringValue
                    let id = items["id"].intValue
                    let genreID = items["genre_ids"][0].intValue
                    let genre = self.genre[genreID]!
                    
                    
                    let data = Movie(date: date, title: title, originalTitle: originalTitle, image: image, overview: overview, ratings: ratings, id: id, poster: poster, genre: genre)
                    
                    self.movieList.append(data)
                    
                    print(data)
                    self.movieCollectionView.reloadData()
                    
                    
                    
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func setCollectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        movieCollectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
        
        let row = movieList[indexPath.item]
        
        cell.titleLabel.text = row.title
        cell.titleLabel.font = .boldSystemFont(ofSize: 14)
        
        
        cell.originalTitleLabel.text = row.originalTitle
        cell.originalTitleLabel.font = .boldSystemFont(ofSize: 14)
        
        
        cell.ratingLabel.text = String(format: "%.2f", row.ratings)
        cell.dateLabel.text = row.date
        cell.posterImageView.kf.setImage(with: URL(string: row.image))
        cell.posterImageView.layer.cornerRadius = 10
        cell.posterImageView.clipsToBounds = true
        
        cell.genreLabel.text = "#\(row.genre)"
        cell.ratingLabel.backgroundColor = .white
        
        
        cell.moviePosterView.layer.cornerRadius = 20
        cell.moviePosterView.layer.shadowColor = UIColor.black.cgColor
        cell.moviePosterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.moviePosterView.layer.shadowRadius = 10
        cell.moviePosterView.layer.shadowOpacity = 0.50
        cell.moviePosterView.backgroundColor = .clear
        
        
        //actor label text에 알맞은 데이터 넣기..!
        //담은 데이터를 어떻게 활용해 하는가..!
        // 1. dispatchque 활용 / 2. 메서드 내에 메서드를 호출하는 방식
        //        print(row.actorName)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DetailTrendingViewController") as? DetailTrendingViewController else { return }
        
        let row = movieList[indexPath.row]
        
        vc.overview = row.overview
        vc.movieTitle = row.title
        vc.poster = row.poster
        vc.backImage = row.image
        
        vc.id = row.id
        

        
        let nav = UINavigationController(rootViewController: vc)
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
