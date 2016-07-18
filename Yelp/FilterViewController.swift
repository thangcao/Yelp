//
//  FilterViewController.swift
//  Yelp
//
//  Created by Cao Thắng on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filterViewController(filFiltersViewController: FilterViewController, didUpdateFilters filters: [String:AnyObject])
}
class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [[String: String]]!
    var switchStates = [Int:Bool]()
    var distances: [Float?]!
    var filters = [String : AnyObject]()
    var isSortCollapsed = true
    var isRadiusCollapsed = true
    var isCategoryCollapsed = true
    // Declare NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    // Delegate
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        distances = [nil, 0.3, 1, 5, 20]
        categories = CATEGORIES
        getDataFromNSUserDefault()
    }
    
    // MARK: - Actions
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        filters["categories"] = (selectedCategories.count > 0) ? selectedCategories : nil
        delegate?.filterViewController!(self, didUpdateFilters: filters)
        // Save to NSUserDefaults
        let switchStatesData = NSKeyedArchiver.archivedDataWithRootObject(switchStates)
        self.defaults.setObject(switchStatesData, forKey: KEY_SWITCHSTATES)
        
        let filtersData = NSKeyedArchiver.archivedDataWithRootObject(filters)
        self.defaults.setObject(filtersData, forKey: KEY_FILTERES)
        
        defaults.synchronize()
        
    }
    
}
extension FilterViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return distances.count
        case 2: return 3
        case 3: return categories.count + 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Deal area
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchItemLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.switchItemUISwitch.on = filters["deal"] as? Bool ?? false
            
            return cell
            
        case 1:
            // Radius area
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            cell.delegate = self
            
            // Set label for each cell
            if indexPath.row == 0 {
                cell.itemLabel.text = "Auto"
            } else {
                if distances[indexPath.row] == 1 {
                    cell.itemLabel.text = "\(distances[indexPath.row]!) mile"
                } else {
                    cell.itemLabel.text = "\(distances[indexPath.row]!) miles"
                }
            }
            
            let radiusValue = filters["distances"] as! Float?
            let compareRadiusValue = distances[indexPath.row]
            DropDownCell.setRadiusIcon(indexPath.row, iconView: cell.itemIcon, radiusValue: radiusValue, compareRadiusValue: compareRadiusValue, isRadiusCollapsed: isRadiusCollapsed)
            DropDownCell.setRadiusCellVisible(indexPath.row, cell: cell, radiusValue: radiusValue, compareRadiusValue: compareRadiusValue, isRadiusCollapsed: isRadiusCollapsed)

            return cell
            
        case 2:
            // Sort area
            let cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            cell.delegate = self
            
            switch indexPath.row {
            case 0:
                cell.itemLabel.text = "Best Match"
            case 1:
                cell.itemLabel.text = "Distance"
            case 2:
                cell.itemLabel.text = "Rating"
            default:
                break
            }
            DropDownCell.setSortIcon(indexPath.row, iconView: cell.itemIcon, sortValue: getSortValue(), isSortCollapsed: isSortCollapsed)
            DropDownCell.setSortCellVisible(indexPath.row, cell: cell, sortValue: getSortValue(), isSortCollapsed: isSortCollapsed)
            return cell
            
        case 3:
            // Category area
             print("IndexPaath Row: \(indexPath.row)")
            if indexPath.row != categories.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
                cell.switchItemLabel.text = categories[indexPath.row]["name"]
                cell.delegate = self
                cell.switchItemUISwitch.on = switchStates[indexPath.row] ?? false
                SwitchCell.setCategoryCellVisible(indexPath.row, cell: cell, isCategoryCollapsed: isCategoryCollapsed, categoriesCount: categories.count)
                return cell
            } else {
                // Last Cell
               
                let cell = tableView.dequeueReusableCellWithIdentifier("LoadAllCell", forIndexPath: indexPath) as! LoadAllCell
                
                let seeAllCell = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.clickSeeAll(_:)))
                cell.addGestureRecognizer(seeAllCell)
                
                return cell
            }
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if isRadiusCollapsed {
                let radiusValue = filters["distances"] as! Float?
                if radiusValue != distances[indexPath.row] {
                    return 0
                }
            }
        case 2:
            if isSortCollapsed {
                let sortValue = getSortValue()
                if sortValue != indexPath.row {
                    return 0
                }
            }
        case 3:
            if isCategoryCollapsed {
                if indexPath.row > 2 && indexPath.row != categories.count {
                    return 0
                }
            }
        default:
            break
        }
        
        return HEIGHT_FOR_ROW
    }
}

extension FilterViewController: SwitchCellDelegate, DropDownCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        if indexPath.section == 0 {
            self.filters["deal"] = value
        } else if indexPath.section == 3 {
            switchStates[indexPath.row] = value
        }
    }
    
    func selectCell(dropDownCell: DropDownCell, didSelect currentImg: UIImage) {
        let indexPath = tableView.indexPathForCell(dropDownCell)
        
        if indexPath != nil {
            if indexPath!.section == 1 {
                // distances
                switch currentImg {
                case UIImage(named: "Arrow")!:
                    isRadiusCollapsed = false
                case UIImage(named: "CheckIcon")!:
                    isRadiusCollapsed = true
                case UIImage(named: "Circle")!:
                    filters["distances"] = distances[indexPath!.row]
                    isRadiusCollapsed = true
                default:
                    break
                }
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            } else if indexPath!.section == 2 {
                // Sort area
                switch currentImg {
                case UIImage(named: "Arrow")!:
                    isSortCollapsed = false
                case UIImage(named: "CheckIcon")!:
                    isSortCollapsed = true
                case UIImage(named: "Circle")!:
                    filters["sort"] = indexPath!.row
                    isSortCollapsed = true
                default:
                    break
                }
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
}

// FilterViewController Custom function
extension FilterViewController {
    
    
    func setRadiusIcon(row: Int, iconView: UIImageView) {
        let radiusValue = filters["distances"] as! Float?
        
        if radiusValue == distances[row] {
            if isRadiusCollapsed {
                iconView.image = UIImage(named: "Arrow")
            } else {
                iconView.image = UIImage(named: "CheckIcon")
            }
            return
        }
        
        iconView.image = UIImage(named: "Circle")
    }
    
    func setRadiusCellVisible(row: Int, cell: DropDownCell) {
        let radiusValue = filters["distances"] as! Float?
        if isRadiusCollapsed && distances[row] != radiusValue {
            cell.itemLabel.hidden = true
            cell.itemIcon.hidden = true
            return
        }
        
        cell.itemLabel.hidden = false
        cell.itemIcon.hidden = false
    }
    func getDataFromNSUserDefault() {
        let switchStatesData = defaults.objectForKey(KEY_SWITCHSTATES) as? NSData
        if let switchStatesData = switchStatesData {
            switchStates = NSKeyedUnarchiver.unarchiveObjectWithData(switchStatesData) as! [Int:Bool]
        }
        
        let filtersData = defaults.objectForKey(KEY_FILTERES) as? NSData
        if let filtersData = filtersData {
            filters = NSKeyedUnarchiver.unarchiveObjectWithData(filtersData) as! [String : AnyObject]
        }
        
        if filters["sort"] == nil {
            filters["sort"] = YelpSortMode.BestMatched.rawValue
        }
    }
    
    
    func getSortValue() -> Int {
        let sortValue = filters["sort"] as? Int
        if sortValue != nil {
            return sortValue!
        }
        return 0
    }
    
    func clickSeeAll(sender:UITapGestureRecognizer) {
        // Get LoadAllCell
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: categories.count, inSection: 3)) as! LoadAllCell
        
        if cell.seeAllLabel.text == "See All" {
            cell.seeAllLabel.text = "Collapse"
            isCategoryCollapsed = false
        } else {
            cell.seeAllLabel.text = "See All"
            isCategoryCollapsed = true
        }
        
        tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
