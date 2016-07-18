//
//  DropDownCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DropDownCellDelegate {
    optional func selectCell(dropDownCell: DropDownCell, didSelect currentImg: UIImage)
}

class DropDownCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var itemIcon: UIImageView!
    
    var delegate: DropDownCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if delegate != nil {
            delegate?.selectCell?(self, didSelect: itemIcon.image!)
        }
    }
    
}
extension DropDownCell {
    class func setSortCellVisible(row: Int, cell: DropDownCell, sortValue: Int, isSortCollapsed: Bool) {
        if isSortCollapsed && row != sortValue {
            cell.itemLabel.hidden = true
            cell.itemIcon.hidden = true
            return
        }
        
        cell.itemLabel.hidden = false
        cell.itemIcon.hidden = false
    }
    class func setSortIcon(row: Int, iconView: UIImageView, sortValue: Int, isSortCollapsed: Bool) {
        if sortValue == row {
            if isSortCollapsed {
                iconView.image = UIImage(named: "Arrow")
            } else {
                iconView.image = UIImage(named: "CheckIcon")
            }
            return
        }
        
        iconView.image = UIImage(named: "Circle")
    }
    class func setRadiusIcon(row: Int, iconView: UIImageView, radiusValue: Float?, compareRadiusValue: Float?, isRadiusCollapsed: Bool) {
        if radiusValue == compareRadiusValue {
            if isRadiusCollapsed {
                iconView.image = UIImage(named: "Arrow")
            } else {
                iconView.image = UIImage(named: "CheckIcon")
            }
            return
        }
        
        iconView.image = UIImage(named: "Circle")
    }
    
    class func setRadiusCellVisible(row: Int, cell: DropDownCell, radiusValue: Float?, compareRadiusValue: Float?, isRadiusCollapsed: Bool) {
        if isRadiusCollapsed && compareRadiusValue != radiusValue {
            cell.itemLabel.hidden = true
            cell.itemIcon.hidden = true
            return
        }
        cell.itemLabel.hidden = false
        cell.itemIcon.hidden = false
    }

}
