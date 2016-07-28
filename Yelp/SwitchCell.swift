//
//  SwitchCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCellDelegate(switchCell: SwitchCell, value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var viewSwitchCell: UIView!
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
        delegate?.switchCellDelegate?(self, value: switchItemUISwitch.on)
    }
}
extension SwitchCell {
    func didAppear(isAppear: Bool){
        viewSwitchCell.hidden = isAppear
    }
}
