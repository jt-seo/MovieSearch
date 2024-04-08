//
//  MoviePlayer.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/4/24.
//

import UIKit
import AVFoundation

class MoviePlayerViewController: UIViewController {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    let url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.bounds.width - 16
        let height = width * 9 / 16
        
        playerLayer?.frame = CGRect(x: 8, y: (view.bounds.height - height) / 2, width: width, height: height)
    }
    
    private func setupPlay() {
        let item = AVPlayerItem(url: url)
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        
        view.layer.addSublayer(playerLayer!)
        player?.replaceCurrentItem(with: item)
    }
}

//final class VideoView: UIView {
//  // View 생략
//
// private let url: String
// private var player = AVPlayer()
//
//  init(url: String) {
//    self.url = url
//    super.init(frame: .zero)
//
//    // layout 생략
//
//    guard let url = URL(string: self.url) else { return }
//    let item = AVPlayerItem(url: url)
//    self.player.replaceCurrentItem(with: item)
//    let playerLayer = AVPlayerLayer(player: self.player)
//    playerLayer.frame = self.videoBackgroundView.bounds
//    playerLayer.videoGravity = .resizeAspectFill
//    self.playerLayer = playerLayer
//    self.videoBackgroundView.layer.addSublayer(playerLayer)
//    self.player.play()
//
//    if self.player.currentItem?.status == .readyToPlay {
//      self.slider.minimumValue = 0
//      self.slider.maximumValue = Float(CMTimeGetSeconds(item.duration))
//    }
//    self.slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
//
//    let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
//    self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
//      let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
//      let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
//      print(elapsedTimeSecondsFloat, totalTimeSecondsFloat)
//    })
//  }
//}
