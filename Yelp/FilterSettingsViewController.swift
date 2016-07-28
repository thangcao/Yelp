//
//  FilterSettingsViewController.swift
//  Yelp
//
//  Created by Cao Thắng on 7/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterSettingViewControllerDelegate {
    func filterSettingViewControllerDelegate(filterSettingViewController: FilterSettingsViewController,filters: YelpFilterSettings)
}
class FilterSettingsViewController: UIViewController {
    // Declare KeyValue
    let keyDeal = "Deal"
    let keyDistance = "keyDistance"
    let keySort = "keySort"
    let keyCategories = "keyCategories"
    
    var yelpFilterSettings: YelpFilterSettings?
    var isDisTanceColapse: Bool = true
    var isSortColapse: Bool = true
    var isCategoriesColapse: Bool = true
    let limitAppearOfCategories = 2
    var delegate: FilterSettingViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yelpFilterSettings = getDataFromNSDefault()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        saveData()
        delegate?.filterSettingViewControllerDelegate(self, filters: yelpFilterSettings!)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FilterSettingsViewController : UITableViewDelegate, UITableViewDataSource {
    // Number Of Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    // Number cells in every sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return DISTANCES.count
        case 2: return SORTS.count
        case 3: return CATEGORIES.count + 1
        default: return 0
        }
    }
    
    // Init and load data for cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Deal
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchItemLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.switchItemUISwitch.on = (yelpFilterSettings?.deal!)!
            
            return cell
            
        case 1: // Distance
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            let value = Float(DISTANCES[indexPath.row])
            cell.itemLabel.text = YelpFilterSettings.formartValueItemOfDistancesToString(value)
            cell.isSelect = (yelpFilterSettings?.checkValueInDistance(value))!
            cell.object = DISTANCES[indexPath.row]
            cell.disappearCell(isDisTanceColapse)
            cell.delegate = self
            
            return cell
            
        case 2: // Sort
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            let value = SORTS[indexPath.row]
            cell.itemLabel.text = YelpFilterSettings.formatValueItemOfSortsToString(value)
            cell.isSelect = (yelpFilterSettings?.checkValueInSort(value))!
            cell.object = SORTS[indexPath.row]
            cell.disappearCell(isSortColapse)
            cell.delegate = self
            
            return cell
            
        case 3: // Categories and LoadMore
            if indexPath.row != CATEGORIES.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
                cell.switchItemLabel.text = CATEGORIES[indexPath.row]["name"]
                cell.switchItemUISwitch.on = (yelpFilterSettings!.categories!.count > 0) ? (yelpFilterSettings?.checkValueInCategories(CATEGORIES[indexPath.row]))! : false
                if isCategoriesColapse {
                    if indexPath.row > limitAppearOfCategories {
                        cell.didAppear(true)
                    } else {
                        cell.didAppear(false)
                    }
                } else {
                    cell.didAppear(false)
                }
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("LoadAllCell", forIndexPath: indexPath) as! LoadAllCell
                cell.isColapse = isCategoriesColapse
                cell.delegate = self
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    // Init HeaderView
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: 320, height: 30))
        titleLabel.font = UIFont(name: "Helvetica", size: 15)
        
        switch section {
        case 0:
            titleLabel.text = TITLE_DEAL
        case 1:
            titleLabel.text =  TITLE_DISTANCE
        case 2:
            titleLabel.text = TITLE_SORT_BY
        case 3:
            titleLabel.text = TITLE_CATEGORY
        default:
            return nil
        }
        headerView.addSubview(titleLabel)
        return headerView
    }
    // Height Of Header
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    // Height For Cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        switch indexPath.section {
        case 1:
            if isDisTanceColapse {
                if yelpFilterSettings?.radius != Float(DISTANCES[indexPath.row]) {
                    return 0
                }
            }
        case 2:
            if isSortColapse {
                if yelpFilterSettings?.sort != SORTS[indexPath.row]{
                    return 0
                }
            }
        case 3:
            if isCategoriesColapse {
                if indexPath.row > limitAppearOfCategories && indexPath.row != CATEGORIES.count {
                    return 0
                }
            }
        default:
            break
        }
        
        return HEIGHT_FOR_ROW
    }
}
// SwitCellDelegate
extension FilterSettingsViewController : SwitchCellDelegate {
    func switchCellDelegate(switchCell: SwitchCell, value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        if indexPath.section == 0 { // Section Deal
            yelpFilterSettings?.deal = value
        } else if indexPath.section == 3 { // Section Categories
            if value {
                yelpFilterSettings?.categories?.append(CATEGORIES[indexPath.row])
            } else {
                yelpFilterSettings!.removeCategory(CATEGORIES[indexPath.row])
            }
        }
    }
}
// DropDownDelegate
extension FilterSettingsViewController: DropDownCellDelegate {
    func dropDownCellDelegate(dropDownCell: DropDownCell, valueObject: AnyObject) {
        let indextPath = tableView.indexPathForCell(dropDownCell)
        if indextPath?.section == 1 { // Section Distance
            isDisTanceColapse = (!isDisTanceColapse) ? true : false
            yelpFilterSettings?.radius = valueObject as? Float
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            if indextPath?.section == 2 { // Section Sort
                isSortColapse = (!isSortColapse) ? true : false
                yelpFilterSettings?.sort = valueObject as? NSNumber
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
    }
}
// Load All Cell Delegate
extension FilterSettingsViewController: LoadAllCellDelegate {
    func loadAllCellDelegate(isColapse: Bool) {
        isCategoriesColapse = isColapse
        tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
// Save data
extension FilterSettingsViewController {
    func saveData(){
        let defaults = NSUserDefaults.standardUserDefaults()
        // Deal
        let dealArchiver = NSKeyedArchiver.archivedDataWithRootObject(yelpFilterSettings!.deal!)
        defaults.setObject(dealArchiver, forKey: keyDeal)
        // Distances
        let distancesArchiver = NSKeyedArchiver.archivedDataWithRootObject(yelpFilterSettings!.radius!)
        defaults.setObject(distancesArchiver, forKey: keyDistance)
        // Sort
        let sortArchiver = NSKeyedArchiver.archivedDataWithRootObject(yelpFilterSettings!.sort!)
        defaults.setObject(sortArchiver, forKey: keySort)
        // Categories
        let categoriesArchiver = NSKeyedArchiver.archivedDataWithRootObject(yelpFilterSettings!.categories!)
        defaults.setObject(categoriesArchiver, forKey: keyCategories)
        defaults.synchronize()
    }
    func getDataFromNSDefault() -> YelpFilterSettings{
        let yelpFilterSettings = YelpFilterSettings()
        let defaults = NSUserDefaults.standardUserDefaults()
        // Deal
        let deal = defaults.objectForKey(keyDeal) as? NSData
        if let deal = deal {
           let dealUnArchiver = NSKeyedUnarchiver.unarchiveObjectWithData(deal) as! Bool
            yelpFilterSettings.deal = dealUnArchiver
        }
        let distances = defaults.objectForKey(keyDistance) as? NSData
        if let distances = distances {
            let distancesArchiver = NSKeyedUnarchiver.unarchiveObjectWithData(distances) as! Float
            yelpFilterSettings.radius = distancesArchiver
        }

        let sort = defaults.objectForKey(keySort) as? NSData
        if let sort = sort {
            let sortArchiver = NSKeyedUnarchiver.unarchiveObjectWithData(sort) as! NSNumber
            yelpFilterSettings.sort = sortArchiver
        }
        
        let categories = defaults.objectForKey(keyCategories) as? NSData
        if let categories = categories {
            let categoriesArchiver = NSKeyedUnarchiver.unarchiveObjectWithData(categories) as! [[String: String]]
            yelpFilterSettings.categories = categoriesArchiver
        }
        return yelpFilterSettings
    }
}
