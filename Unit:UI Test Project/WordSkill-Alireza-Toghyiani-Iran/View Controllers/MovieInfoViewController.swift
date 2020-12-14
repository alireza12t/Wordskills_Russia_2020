//
//  MovieInfoViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//
import RxSwift
import UIKit

class MovieInfoViewController: BaseViewController {
    
    @IBOutlet weak var episodesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var imagesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!

    var movieID: String!
    var APIDispposableMovieInfo: Disposable!
    var APIDispposableChatroome: Disposable!
    var APIDispposableEpisodes: Disposable!
    var images: [String] = []
    var episodes: [Episode] = []
    var tags: [Tag] = []
    var tagWidths: [CGFloat] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        episodesTableView.delegate = self
        episodesTableView.dataSource = self

        scrolView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieInfo()
        getEpisodes()
    }
    
    @IBAction func chatButtonDidTap(_ sender: Any) {
        APIDispposableMovieInfo?.dispose()
        APIDispposableMovieInfo = nil
        APIDispposableMovieInfo = API.shared.chatList(movieID: self.movieID)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("chatList => onNext => \(response)")
                if let chat = response.first {
                DispatchQueue.main.async {
                let chatVC = ChatroomViewController.instantiateFromStoryboardName(storyboardName: .Main)
                    
                    chatVC.chatName = chat.movieName
                    chatVC.chatID = "\(chat.chatId)"
                    let id = StoringData.avatarID  + StoringData.name 
                    chatVC.sender = Sender(senderId: id + StoringData.name, displayName: StoringData.name, avatarID: StoringData.avatarID)
                    
                    SegueHelper.pushViewController(sourceViewController: self, destinationViewController: chatVC)
                }
                } else {
                    DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "There is no chatroom for this movie")
                }


            }, onError: { (error) in
                Log.e("chatList => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })

    }
    
    func getEpisodes(){
        APIDispposableEpisodes?.dispose()
        APIDispposableEpisodes = nil
        APIDispposableEpisodes = API.shared.episodes(movieID: self.movieID)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("movieInfo => onNext => \(response)")
                self.episodes = response
                DispatchQueue.main.async {
                    self.episodesTableView.reloadData()
                    if self.episodes.isEmpty {
                        self.episodesTableViewHeight.constant = 0
                    } else {
                    self.episodesTableViewHeight.constant = self.episodesTableView.bounds.height
                    }
                    self.episodesTableView.isScrollEnabled = false
                }


            }, onError: { (error) in
                Log.e("movieInfo => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })    }
    
    func getMovieInfo(){
        APIDispposableMovieInfo?.dispose()
        APIDispposableMovieInfo = nil
        APIDispposableMovieInfo = API.shared.movieInfo(id: movieID)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("movieInfo => onNext => \(response)")
                
                DispatchQueue.main.async {
                    self.ageLabel.text = response.age + "+"
                    if let age = Int(response.age) {
                        self.ageLabel.textColor = AgeColorHelper.ageColor(for: age)
                    } else {
                        self.ageLabel.textColor = .gray
                    }
                    
                    self.descriptionLabel.text = response.movieInfoDescription
                    self.descriptionLabel.sizeToFit()
                    self.descriptionLabelHeight.constant = self.descriptionLabel.bounds.height
                    
                    self.setupImageView(imageView: self.adImageView, url: response.poster)

                    self.tagWidths = []
                    self.tags = response.tags
                    for tag in self.tags {
                        self.tagWidths.append(tag.tagName.width(forConstrainedHeight: 24, font: .SFProText(size: 14)) + 30)
                    }
                    
                    self.images = response.images
                    self.imagesCollectionView.reloadData()
                    self.tagsCollectionView.reloadData()
                    self.tagsCollectionViewHeight.constant = self.tagsCollectionView.contentSize.height
                    
                    if self.tags.isEmpty {
                        self.tagsCollectionViewHeight.constant = 0
                    }
                    
                }


            }, onError: { (error) in
                Log.e("movieInfo => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)
    }
    
}



extension MovieInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tagsCollectionView:
            return tags.count
        case imagesCollectionView:
            if self.images.isEmpty {
                imagesCollectionViewHeight.constant = 0
            } else {
                imagesCollectionViewHeight.constant = 120
            }
            return images.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case imagesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
            let cellData = images[indexPath.row]
            self.setupImageView(imageView: cell.imageView, url: cellData)
            return cell
        case tagsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
            let cellData = tags[indexPath.row]
            cell.tagNameLabel.text = cellData.tagName
            cell.tagNameLabel.sizeToFit()
            
//            tagWidths[indexPath.row] = cell.tagNameLabel.bounds.width + 10
            
//            collectionView.reloadItems(at: [indexPath])
            
            
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case imagesCollectionView:
            return CGSize(width: 170, height: 120)
        case tagsCollectionView:
            return CGSize(width: tagWidths[indexPath.row], height: 34)
        default:
            return CGSize(width: 100, height: 144)
        }
        
    }

}

extension MovieInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        let cellData = episodes[indexPath.row]
        
        cell.titleLabel.text = cellData.name
        cell.descriiption.text = cellData.description
        cell.descriiption.sizeToFit()
        
        if let imagePath = cellData.images?.first {
            setupImageView(imageView: cell.imageview, url: imagePath)
        } else {
            cell.imageview.image = UIImage(named: "movie")!
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = episodes[indexPath.row]
        //        let episodeVC = EpisodeDetailViewController.insta
        //episodeVC.data = cellData
        //        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: episodeVC)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
