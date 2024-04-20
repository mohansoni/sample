//
//  CollectionViewCell.swift
//  Sample
//
//  Created by Mohan Soni on 19/04/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var displayImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
