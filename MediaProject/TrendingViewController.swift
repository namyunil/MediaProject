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
    var image: String
    var overview: String
    var ratings: Double
    var id: Int
    var poster: String
    var genre: String
    var actorName : [String]
}

struct Actor {
    var name: String
    var character: String
    var image: String
}


class TrendingViewController: UIViewController {
    
    @IBOutlet var movieCollectionView: UICollectionView!
    
    var movieList: [Movie] = []
    var actorList: [Actor] = []
    var actornm: [String] = []
    
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
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //                print("JSON: \(json)")
                    
                    for items in json["results"].arrayValue {
                        let date = items["release_date"].stringValue
                        let title = items["title"].stringValue
                        let image = "https://image.tmdb.org/t/p/original" + items["backdrop_path"].stringValue
                        let overview = items["overview"].stringValue
                        let ratings = items["vote_average"].doubleValue
                        let poster = items["poster_path"].stringValue
                        let id = items["id"].intValue
                        let genreID = items["genre_ids"][0].intValue
                        let genre = self.genre[genreID]!
                        
                        let url = "https://api.themoviedb.org/3/movie/\(id)/credits?language=ko-kr"
                        
                        
                            AF.request(url, method: .get, headers: header).validate().responseJSON { response in
                                switch response.result {
                                case .success(let value):
                                    let json = JSON(value)
                                    //                                            print("JSON: \(json)")
                                    
                                    for items in json["cast"].arrayValue {
                                        let actor = items["name"].stringValue
                                        
                                        
                                        self.actornm.append(actor)
                                        print("==1==")
                                        print(self.actornm)
                                    }
                                    
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            
                      
                        DispatchQueue.main.async {
                            let data = Movie(date: date, title: title, image: image, overview: overview, ratings: ratings, id: id, poster: poster, genre: genre, actorName: self.actornm)
                            
                            self.movieList.append(data)
                            print("==2==")
                            print(data)
                            self.movieCollectionView.reloadData()
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func callCreditRequest(id: Int) {
        
        let url = "https://api.themoviedb.org/3/movie/\(id)/credits?language=ko-kr"
        let header: HTTPHeaders = ["Authorization": APIKey.Token]
        
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
                for items in json["cast"].arrayValue {
                    let name = items["name"].stringValue
                    let character = items["character"].stringValue
                    let image = "https://image.tmdb.org/t/p/original" + items["profile_path"].stringValue
                    
                    self.actornm.append(name)
                    
                    let actorData = Actor(name: name, character: character, image: image)
                    self.actorList.append(actorData)
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
        cell.titleLabel.font = .boldSystemFont(ofSize: 15)
        
        cell.ratingLabel.text = String(format: "%.2f", row.ratings)
        cell.dateLabel.text = row.date
        cell.posterImageView.kf.setImage(with: URL(string: row.image))
        cell.genreLabel.text = "#\(row.genre)"
        cell.ratingLabel.backgroundColor = .white
        
        
        print(row.actorName)
        
        //actor label text에 알맞은 데이터 넣기..!
        //담은 데이터를 어떻게 활용해 하는가..!
        // 1. dispatchque 활용 / 2. 메서드 내에 메서드를 호출하는 방식
//        print(row.actorName)
        
        
        
        
        
        cell.moviePosterView.layer.cornerRadius = 10
        cell.moviePosterView.layer.borderColor = UIColor.black.cgColor
        
        
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
        
        
        
        callCreditRequest(id: row.id)
        
        DispatchQueue.main.async {
            vc.actorData = self.actorList
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}