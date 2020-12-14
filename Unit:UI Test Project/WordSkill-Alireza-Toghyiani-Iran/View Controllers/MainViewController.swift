//
//  MainViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit
import Spring
import RxSwift

enum MovieListType: String {
    case inTrend, forMe, new
}

class MainViewController: BaseViewController {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var adTitleImageView: UIImageView!
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var inTrendCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var forMeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var youWatchedImageView: UIImageView!
    @IBOutlet weak var lastWatchHeigh: NSLayoutConstraint!
    @IBOutlet weak var lastWatchTitle: UILabel!


    var inTrends: [MovieListElement] = []
    var news: [MovieListElement] = []
    var forMes: [MovieListElement] = []

    var adBlockMovieID: String!
    var APIDispposableMainCover: Disposable!
    var APIDispposableMovieList: Disposable!
    var APIDispposableYouWatched: Disposable!

    override func viewDidLoad() {
        super.viewDidLoad()
        inTrendCollectionView.dataSource = self
        inTrendCollectionView.delegate = self
        newCollectionView.dataSource = self
        newCollectionView.delegate = self
        forMeCollectionView.delegate = self
        forMeCollectionView.dataSource = self
        
        scrolView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieList()
        getAdMovie()
        getLastWatch()
    }
    
    func getMovieList() {
        APIDispposableMovieList?.dispose()
        APIDispposableMovieList = nil
        APIDispposableMovieList = API.shared.movieList(filter: MovieListType.inTrend.rawValue)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("movieList => onNext => \(response)")
                DispatchQueue.main.async {
                    self.inTrends = response
                    self.inTrendCollectionView.reloadData()
                }
                
                self.APIDispposableMainCover?.dispose()
                self.APIDispposableMainCover = nil
                self.APIDispposableMainCover = API.shared.movieList(filter: MovieListType.new.rawValue)
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onNext: { (response) in
                        Log.i("movieList => onNext => \(response)")
                        
                        DispatchQueue.main.async {
                            self.news = response
                            self.newCollectionView.reloadData()
                        }
                        
                        self.APIDispposableMovieList?.dispose()
                        self.APIDispposableMovieList = nil
                        self.APIDispposableMovieList = API.shared.movieList(filter: MovieListType.forMe.rawValue)
                            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                            .subscribe(onNext: { (response) in
                                Log.i("movieList => onNext => \(response)")
                                
                                DispatchQueue.main.async {
                                    self.forMes = response
                                    self.forMeCollectionView.reloadData()
                                }
                            }, onError: { (error) in
                                Log.e("movieList => onError => \(error)")
                                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                            })
                        

                    }, onError: { (error) in
                        Log.e("movieList => onError => \(error)")
                        DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                    })
                

            }, onError: { (error) in
                Log.e("movieList => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
    }
    
    func getLastWatch(){
        
        APIDispposableYouWatched?.dispose()
        APIDispposableYouWatched = nil
        APIDispposableYouWatched = API.shared.lastWatch()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("lastWatch => onNext => \(response)")
                DispatchQueue.main.async {
                    if let lastView = response.first {
                    self.setupImageView(imageView: self.youWatchedImageView, url: lastView.poster)
                        DispatchQueue.main.async {
                        self.lastWatchTitle.isHidden = false
                        self.lastWatchHeigh.constant = 240
                        self.youWatchedImageView.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                        self.lastWatchTitle.isHidden = true
                        self.lastWatchHeigh.constant = 0
                        self.youWatchedImageView.isHidden = true
                        }
                    }
                }

            }, onError: { (error) in
                Log.e("lastWatch => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
    }
    
    
    func getAdMovie(){
        
        APIDispposableMainCover?.dispose()
        APIDispposableMainCover = nil
        APIDispposableMainCover = API.shared.mainCover()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("mainCover => onNext => \(response)")
                DispatchQueue.main.async {
                    self.setupImageView(imageView: self.adImageView, url: response.backgroundImage)
                    self.setupImageView(imageView: self.adTitleImageView, url: response.foregroundImage)
                    self.adBlockMovieID = response.movieId
                }

            }, onError: { (error) in
                Log.e("mainCover => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
    }

    @IBAction func adBlockWatchButtonDidTap(_ sender: Any) {
        if let adBlockMovieID = self.adBlockMovieID {
        let movieVC = MovieInfoViewController.instantiateFromStoryboardName(storyboardName: .Main)
        movieVC.movieID = adBlockMovieID
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: movieVC)
        }
    }
    
    @IBAction func specifyInterestButtonDidTap(_ sender: Any) {
        
    }
    
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case inTrendCollectionView:
            return inTrends.count
        case newCollectionView:
            return news.count
        case forMeCollectionView:
            return forMes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        switch collectionView {
        case inTrendCollectionView:
            let cellData = inTrends[indexPath.row]
            self.setupImageView(imageView: cell.imageView, url: cellData.poster)
        case newCollectionView:
            let cellData = news[indexPath.row]
            self.setupImageView(imageView: cell.imageView, url: cellData.poster)
        case forMeCollectionView:
            let cellData = forMes[indexPath.row]
            self.setupImageView(imageView: cell.imageView, url: cellData.poster)
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case inTrendCollectionView:
            return CGSize(width: 100, height: 144)
        case newCollectionView:
            return CGSize(width: 100, height: 144)
        case forMeCollectionView:
            return CGSize(width: 240, height: 144)
        default:
            return CGSize(width: 100, height: 144)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movieID = ""
        switch collectionView {
        case inTrendCollectionView:
            let cellData = inTrends[indexPath.row]
            movieID = cellData.movieID
        case newCollectionView:
            let cellData = news[indexPath.row]
            movieID = cellData.movieID
        case forMeCollectionView:
            let cellData = forMes[indexPath.row]
            movieID = cellData.movieID
        default:
            movieID = ""
        }
        let movieVC = MovieInfoViewController.instantiateFromStoryboardName(storyboardName: .Main)
        movieVC.movieID = movieID
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: movieVC)
    }
    
    
    
}
