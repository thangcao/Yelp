//
//  BusinessCell.swift
//  Yelp
//
//  Created by Cao Thắng on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking
class BusinessCell: UITableViewCell {
    
    // Init Views
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessFoodImageView: UIImageView!
    
    @IBOutlet weak var businessDistanceLabel: UILabel!
    
    @IBOutlet weak var businessRatingImageView: UIImageView!
    
    @IBOutlet weak var businessReviewsLabel: UILabel!
    
    @IBOutlet weak var businessCategoriesLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    var business : Business! {
        didSet {
            businessNameLabel.text = business.name
            businessNameLabel.sizeToFit()
            businessDistanceLabel.text = business.distance
            businessAddressLabel.text = business.address
            businessReviewsLabel.text = "\(business.reviewCount!)"
            businessCategoriesLabel.text = business.categories
            // SetUp ImageView
            businessFoodImageView.setImageWithURL(business.imageURL!)
            businessFoodImageView.layer.masksToBounds = true
            businessRatingImageView.setImageWithURL(business.ratingImageURL!)
            businessFoodImageView.layer.cornerRadius = 5
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
