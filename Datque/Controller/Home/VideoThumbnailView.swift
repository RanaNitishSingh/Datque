//
//  VideoThumbnailView.swift
//  Datque
//
//  Created by Nitish on 11/08/23.
//

import Foundation
import UIKit
import AVFoundation

class VideoThumbnailView: UIView {
    private var thumbnailImageView: UIImageView!
    private var playPauseButton: UIButton!
    private var player: AVPlayer?
    
    var videoURL: URL? {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Add thumbnail image view
        thumbnailImageView = UIImageView(frame: bounds)
        thumbnailImageView.contentMode = .scaleAspectFit
        addSubview(thumbnailImageView)
        
        // Add play/pause button
        playPauseButton = UIButton(type: .custom)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        addSubview(playPauseButton)
        
        // Set button constraints
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func playPauseButtonTapped() {
        if let videoURL = videoURL {
            if player == nil {
                player = AVPlayer(url: videoURL)
                player?.volume = 1.0 // Adjust the volume as needed
                player?.actionAtItemEnd = .none
                
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = bounds
                layer.addSublayer(playerLayer)
                
                thumbnailImageView.isHidden = true
                player?.play()
                playPauseButton.isSelected = true
            } else {
                if player?.rate == 0 {
                    player?.play()
                    playPauseButton.isSelected = true
                } else {
                    player?.pause()
                    playPauseButton.isSelected = false
                }
            }
        }
    }
}
