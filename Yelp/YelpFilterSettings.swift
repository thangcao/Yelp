//
//  YelpFilterSettings.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
class YelpFilterSettings{
    var term: String?
    var limit: NSNumber?
    var offset: NSNumber?
    var sort: NSNumber?
    var categories: [String]?
    var radius: Float?
    var deal: Bool?
    
    init() {
        term  = ""
        limit = LIMIT_DATA
        offset = nil
        sort = nil
        categories = nil
        radius = nil
        deal = false
    }
    func resetData() {
        term  = ""
        limit = LIMIT_DATA
        offset = nil
        sort = nil
        categories = nil
        radius = nil
        deal = false
    }
}
