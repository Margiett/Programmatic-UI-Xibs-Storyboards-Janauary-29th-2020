//
//  ViewController.swift
//  Programmatic-UI-Xibs-Storyboards
//
//  Created by Alex Paul on 1/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
  
  private let podcastView = PodcastView()
  
  private var podcasts = [Podcast]() {
    didSet {
      // code here
        DispatchQueue.main.async {
            self.podcastView.collectionView.reloadData()
        }
    }
  }

  override func loadView() {
    view = podcastView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Podcasts"
    podcastView.collectionView.dataSource = self
    podcastView.collectionView.delegate = self
   
    // register collection view cell
//    podcastView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "podcastCell")
    
    podcastView.collectionView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
    
    fetchPodcasts()
  }
  
  private func fetchPodcasts(_ name: String = "swift") {
    PodcastAPIClient.fetchPodcast(with: name) { (result) in
      switch result {
      case .failure(let appError):
        print("error fetching podcasts: \(appError)")
      case .success(let podcasts):
        self.podcasts = podcasts
      }
    }
  }
}

//MARK: DataSource
extension PodcastViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as? PodcastCell else {
        fatalError("could not downcast to Podcast")
    }
    cell.backgroundColor = .lightGray
    return cell
  }
}

extension PodcastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // override the default value of the itemSize layout from the collectionView property initializer in the PodCastView 
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.95 // 95% of the width of device
        return CGSize(width: itemWidth, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.row]
        print(podcast.collectionName)
        
        // segue to the podcastdetailcontroller
        // access the podcastdetailcontroller from story
        
        // make sure that the storyboard id is set for the podcastdetailcontroller
        let podcastDetailStoryboard = UIStoryboard(name: "PodcastDetail", bundle: nil)
        guard let podcastDetailController = podcastDetailStoryboard.instantiateViewController(identifier: "PodcastDetailController") as? PodcastDetailController else {
            fatalError("could not downcast to PodcastDetailController")
        }
        podcastDetailController.selectedPod = podcast
        
        //in the coming weeks or next week we will pass data using initilizer / dependency injection e.g podcastDetailController(podcast: podcast)
        
        navigationController?.pushViewController(podcastDetailController, animated: true)
    }
}


