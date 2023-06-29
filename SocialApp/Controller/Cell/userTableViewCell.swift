//
//  userTableViewCell.swift
//  SocialApp
//
//  Created by Nitish on 27/06/23.
//

import UIKit

class userTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageViewX!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
