//
//  LoadAllCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol LoadAllCellDelegate{
    optional func loadAllCellDelegate(isColapse: Bool)
    
}
class LoadAllCell: UITableViewCell {

    
    @IBOutlet weak var loadAllButton: UIButton!
    var delegate: LoadAllCellDelegate?
    var isColapse: Bool = true
    @IBOutlet weak var viewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func loadAllCategoriesAction(sender: AnyObject) {
        if isColapse {
            loadAllButton.setTitle("Colapse", forState: UIControlState.Normal)
            isColapse = false
        } else {
            loadAllButton.setTitle("Load All", forState: UIControlState.Normal)
            isColapse = true
        }
        delegate?.loadAllCellDelegate?(isColapse)
    }
}
