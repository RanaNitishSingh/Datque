//
//  FilterCellTableViewCell.swift
//  Ziofly
//
//  Created by Apple on 26/06/21.
//

import UIKit

//protocol CollectionViewCellDelegate: AnyObject {
//    func collectionView(collectionviewcell: TypeCVCell?, index: Int, didTappedInTableViewCell: FilterCell)
//
//}

class ProfileCell: UITableViewCell {
    
    //weak var cellDelegate: CollectionViewCellDelegate?
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTypeName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    override func awakeFromNib() {
        
    }
    
}
