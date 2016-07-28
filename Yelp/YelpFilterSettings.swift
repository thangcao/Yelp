//
//  YelpFilterSettings.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
class YelpFilterSettings {
    let keyDeal = "Deal"
    let keyRadius = "Radius"
    let keyCategories = "Categories"
    let keySort = "Sort"
    let keySave = "YelpFilterSettings"
    
    var term: String?
    var limit: NSNumber?
    var offset: NSNumber?
    var sort: NSNumber?
    var categories: [[String: String]]?
    var radius: Float?
    var deal: Bool?
    
    init() {
        term  = ""
        limit = LIMIT_DATA
        offset = 0
        sort = 0
        categories = []
        radius = 0
        deal = false
    }
    func resetData() {
        term  = ""
        limit = LIMIT_DATA
        offset = 0
        sort = 0
        categories = []
        radius = 0
        deal = false
    }
    func checkValueInDistance(value: Float!) -> Bool{
        if radius == value {
            return true
        }
        return false
    }
    func checkValueInSort(value: Int!) -> Bool {
        if sort == value {
            return true
        }
        return false
    }
    func checkValueInCategories(value: [String: String]!) -> Bool {
        for item in categories! {
            if item == value {
                return true
            }
        }
        return false
    }
    func removeCategory(value: [String: String]){
        var index = 0
        for items in categories! {
            if items["name"] == value["name"] && items["code"] == value["code"] {
                categories?.removeAtIndex(index)
            }
            index += 1
        }
    }
    class func formartValueItemOfDistancesToString(value: Float) -> String{
        switch value {
        case 0:
            return "Auto"
        case 0.3:
            return "\(value) mile"
        case 1:
            return "\(value) miles"
        case 5:
            return "\(value) miles"
        case 20:
            return "\(value) miles"
        default:
            return ""
        }
    }
    class func formatValueItemOfSortsToString(value: NSNumber) -> String{
        switch value {
        case 0:
            return "Best Match"
        case 1:
            return "Distance"
        case 2:
            return "Hot Rated"
        default:
            return ""
        }
    }
}
