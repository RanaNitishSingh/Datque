//
//  CollectionViewCell.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import AVKit
import AVFoundation
class CollectionViewCell: UICollectionViewCell {
  
    //MARK: - CollectionViewSkinType Filter Screen
    @IBOutlet weak var viewSkinType: UIViewX!
    @IBOutlet weak var lblSkinType: UILabel!
    
    //MARK: - CollectionViewLanguage Filter Screen
    @IBOutlet weak var lblLanguage: UILabel!
    
    //MARK: - CollectionViewProfession Filter Screen
    @IBOutlet weak var lblProfession: UILabel!
    
    //MARK: - CollectionViewReligion Filter Screen
    @IBOutlet weak var lblReligion: UILabel!
    
    //MARK: - CollectionViewEducation Filter Screen
    @IBOutlet weak var lblEducation: UILabel!
    
    //MARK: - CollectionViewBodyType Filter Screen
    @IBOutlet weak var lblBodyType: UILabel!
    
    //MARK: - CollectionViewHairColor Filter Screen
    @IBOutlet weak var lblHairColor: UILabel!
    
    //MARK: - CollectionViewEyeColor Filter Screen
    @IBOutlet weak var lblEyeColor: UILabel!
    
    //MARK: - CollectionViewEditProfile EditProfile Screen
    @IBOutlet weak var imgEditProfile: UIImageView!
    @IBOutlet weak var viewDeleteEditProfile: UIView!
    @IBOutlet weak var btnDeleteEditProfile: UIButtonX!
    
    //MARK: - CollectionViewLiveUser LiveVC Screen
    @IBOutlet weak var lblNameCollectionViewLiveUser: UILabelX!
    @IBOutlet weak var imgCollectionViewLiveUser: UIImageView!
    
    //MARK: - collectionViewLikes ProfileLikeVC Screen
    @IBOutlet weak var imgcollectionViewLikes: UIImageViewX!
    @IBOutlet weak var lblcollectionViewLikes: UILabel!
    
    //MARK: - CollectionViewSelectPlane SelectPlaneVC Screen
    @IBOutlet weak var imgCollectionViewSelectPlane: UIImageViewX!
    @IBOutlet weak var lblCollectionViewSelectPlane: UILabel!
    

    
    @IBOutlet weak var btnDlt: UIButton!
    @IBOutlet weak var VideoimgType: UIImageView!
    @IBOutlet weak var videoView: UIView!
    let playerViewController = AVPlayerViewController()
    var videoplayer = AVPlayer()
}
