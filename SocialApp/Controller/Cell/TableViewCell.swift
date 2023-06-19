//
//  TableViewCell.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - tblViewSettings Outlet
    @IBOutlet weak var imgTblViewSettings: UIImageView!
    @IBOutlet weak var lblTblViewSettings: UILabel!
   
    //MARK: - tblEditProfile Outlet
    @IBOutlet weak var lblTblEditProfile: UILabel!
    @IBOutlet weak var ImgTblEditProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - tblViewBloodGroup Outlet
    @IBOutlet weak var lbltblViewBloodGroup: UILabel!
    @IBOutlet weak var imgTblViewBloodGroup: UIImageView!
    
    //MARK: - tblViewNotification Outlet
    @IBOutlet weak var imgTblViewNotification: UIImageView!
    @IBOutlet weak var lblTitleTblViewNotification: UILabel!
    @IBOutlet weak var lblBodyTblViewNotification: UILabel!
    
    //MARK: - tblViewLikeYourProfile Outlet
    @IBOutlet weak var lbltblViewLikeYourProfile: UILabel!
    
    //MARK: - tblViewChat Outlet
    @IBOutlet weak var imgTblViewChat: UIImageViewX!
    @IBOutlet weak var lblNameTblViewChat: UILabel!
    @IBOutlet weak var lblMsgTblViewChat: UILabel!
    @IBOutlet weak var lblTimeTblViewChat: UILabel!
    @IBOutlet weak var imgStarTblViewChat: UIImageView!
    @IBOutlet weak var btnLikeTblViewChat: UIButton!
    
    //MARK: - tblBlockedUser Outlet
    @IBOutlet weak var imgProfileTblBlockedUser: UIImageViewX!
    @IBOutlet weak var lblNameTblBlockedUser: UILabel!
    
    //MARK: - tblViewSettingInbox Outlet
    @IBOutlet weak var imgTblViewSettingInbox: UIImageViewX!
    @IBOutlet weak var lblNameTblViewSettingInbox: UILabel!
    @IBOutlet weak var lblMsgTblViewSettingInbox: UILabel!
    @IBOutlet weak var lblTimeTblViewSettingInbox: UILabel!
    @IBOutlet weak var imgStarTblViewSettingInbox: UIImageView!
    @IBOutlet weak var btnLikeTblViewSettingInbox: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
