//
//  DropDownCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DropDownCellDelegate {
    optional func dropDownCellDelegate(dropDownCell: DropDownCell, valueObject: AnyObject)
}

class DropDownCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var itemIcon: UIImageView!
    
    @IBOutlet weak var viewDropDownCell: UIView!
    
    var isSelect : Bool = false
    var object: AnyObject?
    var delegate: DropDownCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if delegate != nil {
            delegate?.dropDownCellDelegate?(self,valueObject: object!)
        }
    }
    
}
extension DropDownCell {
    func disappearCell(isColapse: Bool){
        if !isColapse {
            viewDropDownCell.hidden = false
            if isSelect {
                itemIcon.image = UIImage(named: "CheckIcon")
            } else {
                itemIcon.image = UIImage(named: "Circle")
            }
        } else {
            if isColapse && isSelect {
                itemIcon.image = UIImage(named: "Arrow")
                viewDropDownCell.hidden = false
            } else {
                viewDropDownCell.hidden = true
            }
        }
       
    }
}