
//
//  ChatBubble.swift
//  ChatBubbleScratch
//
//  Created by Sauvik Dolui on 02/09/15.
//  Copyright (c) 2015 Innofied Solution Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: String)
}


class ChatBubble: UIView {
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    // Properties
    var strID : String?
    
    var imageViewChat: UIImageView?
    var imageViewBG: UIImageView?
    var text: String?
    var labelChatText: UILabel?
    var btnToClick: UIButton?
    // Additional property for video player
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    var playPauseButton: UIButton?
    var isVideoPlaying = false
    var videoURL: URL?
    /**
     Initializes a chat bubble view
     
     :param: data   ChatBubble Data
     :param: startY origin.y of the chat bubble frame in parent view
     
     :returns: Chat Bubble      */
    
    @objc func handle_Tap(_ sender: UITapGestureRecognizer) {
        if let button = playPauseButton, button.frame.contains(sender.location(in: self)) {
            // Play/pause button was tapped
            playPauseButtonTapped()
            
        } else {
            // Video thumbnail was tapped
            delegate?.didTapInfoButton(data: strID!)
        }
    }
    
    @objc func playPauseButtonTapped() {
        if let videoURL = self.videoURL {
               // Play video in full-screen using AVPlayerViewController
               let player = AVPlayer(url: videoURL)
               let playerViewController = AVPlayerViewController()
               playerViewController.player = player
               
               // Present the player view controller in full-screen using the current view controller
               if let viewController = self.findViewController() {
                   viewController.present(playerViewController, animated: true) {
                    player.play()
                   }
               }
           } else {
               // Toggle play/pause state for the video within the ChatBubble
               if isVideoPlaying {
                   videoPlayer?.pause()
                   playPauseButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
                   print("hello")
               } else {
                   videoPlayer?.play()
                   playPauseButton?.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                   print("NO")
               }
               isVideoPlaying.toggle()
           }
    }
    
    
//    @objc func imageViewTapped(_ gesture: UITapGestureRecognizer) {
//        if let tappedImageView = gesture.view as? UIImageView, let tappedImage = tappedImageView.image {
//            // Create a full-screen image view to display the tapped image
//            let fullscreenImageView = UIImageView(image: tappedImage)
//            fullscreenImageView.contentMode = .scaleAspectFit
//            fullscreenImageView.backgroundColor = .black // Set a background color for better visibility
//            
//            // Create a tap gesture to dismiss the full-screen image view
//            let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
//            fullscreenImageView.isUserInteractionEnabled = true
//            fullscreenImageView.addGestureRecognizer(dismissTapGesture)
//            
//            // Create a view controller to present the full-screen image
//            let fullscreenVC = UIViewController()
//            fullscreenVC.view.backgroundColor = .black
//            fullscreenVC.view.addSubview(fullscreenImageView)
//            fullscreenImageView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                fullscreenImageView.topAnchor.constraint(equalTo: fullscreenVC.view.topAnchor),
//                fullscreenImageView.leadingAnchor.constraint(equalTo: fullscreenVC.view.leadingAnchor),
//                fullscreenImageView.trailingAnchor.constraint(equalTo: fullscreenVC.view.trailingAnchor),
//                fullscreenImageView.bottomAnchor.constraint(equalTo: fullscreenVC.view.bottomAnchor)
//            ])
//            
//            // Present the full-screen image view
//            self.findViewController()?.present(fullscreenVC, animated: true, completion: nil)
//        }
//    }

//    @objc func dismissFullscreenImage(_ gesture: UITapGestureRecognizer) {
//        gesture.view?.superview?.superview?.dismiss(animated: true, completion: nil)
//    }
//
//    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let player = object as? AVPlayer, player.status == .readyToPlay {
                print("AVPlayer Status: Ready to play")
                // Play the video here if needed
            }
        }
    }
    
    init(data: ChatBubbleData, startY: CGFloat){
        
        // 1. Initializing parent view with calculated frame
        super.init(frame: ChatBubble.framePrimary(type: data.type, startY:startY))
        // Set the videoURL property
            if let videoURLString = data.videoURL {
                self.videoURL = URL(string: "\(videoURLString)")
            }
        // Making Background transparent
        self.backgroundColor = UIColor.clear
        
        let padding: CGFloat = 10.0
        
        // 2. Drawing image if any
        if let chatImage = data.image {
            
            let width: CGFloat = min(chatImage.size.width, self.frame.width - 2 * padding)
            let height: CGFloat = chatImage.size.height * (width / chatImage.size.width)
            imageViewChat = UIImageView(frame: CGRect(x: padding, y: padding, width: width, height: height))
            imageViewChat?.image = chatImage
            imageViewChat?.layer.cornerRadius = 5.0
            imageViewChat?.layer.masksToBounds = true
            self.addSubview(imageViewChat!)
//            // Add tap gesture recognizer
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
//                imageViewChat?.isUserInteractionEnabled = true
//                imageViewChat?.addGestureRecognizer(tapGesture)
//
//                // Add the image view to the ChatBubble
//                self.addSubview(imageViewChat!)
        }
        
        // 2.2. Drawing GIF if any
        if let chatGif = data.gif {
            
            let gifURL : String = "\(chatGif)"
            let imageURL = UIImage.gifImageWithURL(gifURL)
            
            let width: CGFloat = min(150, self.frame.width - 2 * padding)
            let height: CGFloat = 150 * (width / 150)
            imageViewChat = UIImageView(frame: CGRect(x: padding, y: padding, width: width, height: height))
            imageViewChat = UIImageView(image: imageURL)
            imageViewChat?.layer.cornerRadius = 5.0
            imageViewChat?.layer.masksToBounds = true
            self.addSubview(imageViewChat!)
            
            
        }
        
        
        
        func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let time = CMTime(seconds: 1, preferredTimescale: 1) // Get thumbnail from 1 second of the video
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // 2.3. Drawing video if any
        if let chatImage = data.videoURL {
            if let videoURL = URL(string: "\(chatImage)") {
                isVideoPlaying = false // Set initial state to false
                generateThumbnail(from: videoURL) { thumbnail in
                    if let thumbnail = thumbnail {
                        // Use the generated thumbnail image
                        let width: CGFloat = min(thumbnail.size.width, self.frame.width - 2 * padding)
                        let height: CGFloat = thumbnail.size.height * (width / thumbnail.size.width)
                        self.imageViewChat = UIImageView(frame: CGRect(x: padding, y: padding, width: width, height: height))
                        self.imageViewChat?.image = thumbnail
                        self.imageViewChat?.layer.cornerRadius = 5.0
                        self.imageViewChat?.layer.masksToBounds = true
                        self.addSubview(self.imageViewChat!)
                        
                        // Add play/pause button
                        self.playPauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: thumbnail.size.width, height: thumbnail.size.height))
                        self.playPauseButton?.center = self.imageViewChat!.center
                        self.playPauseButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
                        self.playPauseButton?.isUserInteractionEnabled = true
                        self.playPauseButton?.addTarget(self, action: #selector(self.playPauseButtonTapped), for: .touchUpInside)
                        // Add tap gesture recognizer to the imageViewChat
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                        self.imageViewChat?.addGestureRecognizer(tapGesture)
                        self.imageViewChat?.isUserInteractionEnabled = true
                        // Add playPauseButton to the imageViewChat
                        self.imageViewChat?.addSubview(self.playPauseButton!)
                        // Set up AVPlayer and AVPlayerLayer
                        self.videoPlayer = AVPlayer(url: videoURL)
                        self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
                        self.videoPlayerLayer?.frame = self.imageViewChat!.bounds
                        self.imageViewChat?.layer.addSublayer(self.videoPlayerLayer!)
                        // Add play/pause button to imageViewChat
                        self.imageViewChat?.addSubview(self.playPauseButton!)
                        self.imageViewChat?.bringSubviewToFront(self.playPauseButton!)
                        // Observe AVPlayer status
                        self.videoPlayer?.addObserver(self, forKeyPath: "status", options: [], context: nil)
                        
                    }
                }
            }
        }
        
        
        // 3. Going to add Text if any
        if let chatText = data.text {
            strID = chatText
            // frame calculation
            var startX = padding
            var startY:CGFloat = 5.0
            if let imageView = imageViewChat {
                startY += imageViewChat!.frame.maxY
            }
            labelChatText = UILabel(frame: CGRect(x: startX, y: startY, width: self.frame.width - 2 * startX , height: 5))
            labelChatText?.textAlignment = data.type == .Mine ? .right : .left
            labelChatText?.font = UIFont.systemFont(ofSize: 14)
            labelChatText?.numberOfLines = 0 // Making it multiline
            labelChatText?.text = data.text
            labelChatText?.textColor = .white
            labelChatText?.sizeToFit() // Getting fullsize of it
            self.addSubview(labelChatText!)
        }
        // 4. Calculation of new width and height of the chat bubble view
        var viewHeight: CGFloat = 0.0
        var viewWidth: CGFloat = 0.0
        
        if let imageView = imageViewChat {
            // Height calculation of the parent view depending upon the image view and text label
            viewWidth = max(imageViewChat!.frame.maxX, labelChatText!.frame.maxX) + padding
            viewHeight = max(imageViewChat!.frame.maxY, labelChatText!.frame.maxY) + padding
            
        } else {
            viewHeight = labelChatText!.frame.maxY + padding/2
            viewWidth = labelChatText!.frame.width + labelChatText!.frame.minX + padding
        }
        
        // 5. Adding new width and height of the chat bubble frame
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: viewWidth, height: viewHeight)
        
        // 6. Adding the resizable image view to give it bubble like shape
        let bubbleImageFileName = data.type == .Mine ? "bubbleMine" : "bubbleSomeone"
        imageViewBG = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        
        if data.type == .Mine {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 14, bottom: 17, right: 28))
        } else {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 22, bottom: 17, right: 20))
        }
        self.addSubview(imageViewBG!)
        self.sendSubviewToBack(imageViewBG!)
        
        //        btnToClick = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        //        btnToClick?.backgroundColor = UIColor.red
        //
        //        self.addSubview(btnToClick!)
        
        //btnToClick?.addTarget(ChatVC.self, action: #selector(didTapInfoButton), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(tap)
        
        // Frame recalculation for filling up the bubble with background bubble image
        let repsotionXFactor:CGFloat = data.type == .Mine ? 0.0 : -8.0
        let bgImageNewX = imageViewBG!.frame.minX + repsotionXFactor
        let bgImageNewWidth =  imageViewBG!.frame.width + CGFloat(12.0)
        let bgImageNewHeight =  imageViewBG!.frame.height + CGFloat(6.0)
        imageViewBG?.frame = CGRect(x: bgImageNewX, y: 0.0, width: bgImageNewWidth, height: bgImageNewHeight)
        
        
        // Keepping a minimum distance from the edge of the screen
        var newStartX:CGFloat = 0.0
        if data.type == .Mine {
            // Need to maintain the minimum right side padding from the right edge of the screen
            let extraWidthToConsider = imageViewBG!.frame.width
            newStartX = ScreenSize.SCREEN_WIDTH - extraWidthToConsider
        } else {
            // Need to maintain the minimum left side padding from the left edge of the screen
            newStartX = -imageViewBG!.frame.minX + 3.0
        }
        
        self.frame = CGRect(x: newStartX, y: self.frame.minY, width: frame.width, height: frame.height)
        
        
        
    }
    
    
    
    // 6. View persistance support
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FRAME CALCULATION
    class func framePrimary(type:BubbleDataType, startY: CGFloat) -> CGRect{
        let paddingFactor: CGFloat = 0.02
        let sidePadding = ScreenSize.SCREEN_WIDTH * paddingFactor
        let maxWidth = ScreenSize.SCREEN_WIDTH * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
        let startX: CGFloat = type == .Mine ? ScreenSize.SCREEN_WIDTH * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
        return CGRect(x: startX, y: startY, width: maxWidth, height: 5) // 5 is the primary height before drawing starts
    }
    
    
    @objc func didTapInfoButton() {
        // delegate?.didTapInfoButton(data: ["Hello" : "111"])
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.didTapInfoButton(data: strID!)
    }
    
}


extension UIView {
    // Helper method to find the nearest UIViewController
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let currentResponder = responder {
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
            responder = currentResponder.next
        }
        return nil
    }
}
