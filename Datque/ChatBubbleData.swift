//
//  ChatBubbleData.swift
//  ChatBubble
//
//  Created by Sauvik Dolui on 8/21/15.
//  Copyright (c) 2015 Innofied Solution Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit // For using UIImage

// 1. Type Enum
/**
Enum specifing the type

- Mine:     Chat message is outgoing
- Opponent: Chat message is incoming
*/

enum BubbleDataType: Int{
    case Mine = 0
    case Opponent
}

/// DataModel for maintaining the message data for a single chat bubble
class ChatBubbleData {
    // 2.Properties
    var text: String?
    var image: UIImage?
    var date: Date?
    var type: BubbleDataType
    var gif: String?
    var videoURL: URL?
    
    // 3. Initialization
    init(text: String?,image: UIImage?,gif: String?,date: Date?,videoURL: URL?, type:BubbleDataType = .Mine) {
        // Default type is Mine
        self.text = text
        self.image = image
        self.date = date
        self.type = type
        self.gif = gif
        self.videoURL = videoURL
    }
}
