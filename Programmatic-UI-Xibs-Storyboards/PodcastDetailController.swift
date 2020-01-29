//
//  PodcastDetailController.swift
//  Programmatic-UI-Xibs-Storyboards
//
//  Created by Margiett Gil on 1/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import ImageKit
import NetworkHelper

class PodcastDetailController: UIViewController {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var selectedPod: Podcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    
    }
    private func updateUI() {
        guard let podcast = selectedPod else {
            fatalError("did not load a podcast from segue ")
            
        }
        artistNameLabel.text = podcast.artistName
        podcastImageView.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                break // TODO update default image
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImageView.image = image
                    
                }
            }
        }
    }
    

  

}
