//
//  SwitchCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchItemLabel: UILabel!
    
    @IBOutlet weak var switchItemUISwitch: UISwitch!
    
    var delegate: SwitchCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSwitchChanged(sender: AnyObject) {
        delegate?.switchCell?(self, didChangeValue: switchItemUISwitch.on)
    }
}
extension SwitchCell {
    class func setCategoryCellVisible(row: Int, cell: SwitchCell, isCategoryCollapsed: Bool, categoriesCount: Int) {
        if isCategoryCollapsed && row > 2 && row != categoriesCount{
            cell.switchItemLabel.hidden = true
            cell.switchItemUISwitch.hidden = true
            return
        }
        
        cell.switchItemLabel.hidden = false
        cell.switchItemUISwitch.hidden = false
    }
}
