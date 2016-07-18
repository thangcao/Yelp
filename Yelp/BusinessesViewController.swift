//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit
import AFNetworking
class BusinessesViewController: UIViewController , FilterViewControllerDelegate{
    
    @IBOutlet weak var mapViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    let regionRadius: CLLocationDistance = 1000
    var isFullMapView: Bool = false
    var filters = [String : AnyObject]()
    let meterConst: Float = 1609.344
    // FooterView
    var tableFooterView: UIView!
    var noMoreResultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init TableView && SearchBar
        self.mapViewHeightConstrain.constant = self.view.frame.height / 15
        initSearch()
        initTableView()
        initMapView()
        // Start to Search
        if businesses == nil {
            doSearch(0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Filter" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterViewController
            
            filterViewController.delegate = self
        } else if segue.identifier == "ShowDetailBusiness" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailViewController.business = businesses[indexPath.row]
            }
        }
    }
    //MARK: - FiltersViewControllerDelegate
    func filterViewController(filFiltersViewController: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        // Should reloadAllData - For example : MapView and TableView
        reloadAllData()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let sortValue = filters["sort"] as? Int
        let categoryFilters = filters["categories"] as? [String]
        let deal = filters["deal"] as? Bool
        var radius = filters["distance"] as! Float?
        if let radiusValue = radius {
            radius = radiusValue * meterConst
        }
        
        // Set filters in this view controller
        self.filters["sort"] = sortValue
        self.filters["categories"] = categoryFilters
        self.filters["deal"] = deal
        self.filters["radius"] = radius
        Business.searchWithTerm(searchBar.text!, sort: sortValue, categories: categoryFilters, deals: deal, offset: nil, radius: radius, completion: { (filteredBusinesses, error) in
            if self.businesses != nil {
                self.businesses.appendContentsOf(filteredBusinesses!)
            } else {
                self.businesses = filteredBusinesses
            }
            self.mapView.addAnnotations(filteredBusinesses!)
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    override func viewDidLayoutSubviews() {
        // Change size of the loading icon
        tableFooterView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50)
        noMoreResultLabel.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50)
    }
}
// Declare TableView
extension BusinessesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses == nil {
            return 0
        }
        return businesses.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
}
//Declare SearchBar
extension BusinessesViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        reloadAllData()
        doSearch(0)
    }
}

// Declare ScrollViewDelegate
extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, 50)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                doSearch(businesses.count)
            }
        }
    }
}
// Declare MapView
extension BusinessesViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        //verify if the annotation object is a kind of
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        let business = annotation as? Business
        
        //reuse annotation
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftIconView.setImageWithURL(business!.imageURL!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        //customize pin color
        if #available(iOS 9, *) {
            annotationView?.pinTintColor =  UIColor.redColor()
        } else {
            annotationView?.pinColor = MKPinAnnotationColor.Red
        }
        
        
        return annotationView
    }
    
}
// Funtion of event main storyboard
extension BusinessesViewController {
    @IBAction func onButtonMapIcon(sender: AnyObject) {
        if (!isFullMapView){
            self.mapViewHeightConstrain.constant = self.view.frame.height
            isFullMapView = true
        } else {
            self.mapViewHeightConstrain.constant = self.view.frame.height / 15
            isFullMapView = false
            self.noMoreResultLabel.hidden = true
        }
        
    }
    
}
// Custom function's BusinessViewController
extension BusinessesViewController {
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        infiniteScrollLoadingIndicator()
        initTableFooterView()
    }
    func initSearch(){
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter your search here"
        navigationItem.titleView = searchBar
    }
    func infiniteScrollLoadingIndicator(){
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    func doSearch(offset: NSNumber) {
        if offset == 0 {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        Business.searchWithTerm(searchBar.text!,limit: 10, offset: offset, sort: YelpSortMode.Distance.rawValue, categories: [], deals: true) { (businesses: [Business]?, error: NSError!) -> Void in
            if self.businesses != nil {
                self.businesses.appendContentsOf(businesses!)
                if (businesses?.count < 10){
                    self.noMoreResultLabel.hidden = false
                } else {
                    self.noMoreResultLabel.hidden = true
                }
            } else {
                self.businesses = businesses
            }
            self.mapView.addAnnotations(businesses!)
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    func initMapView(){
        // set initial location
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        centerMapOnLocation(initialLocation)
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func initTableFooterView() {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        noMoreResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        noMoreResultLabel.text = "No more results"
        noMoreResultLabel.textAlignment = NSTextAlignment.Center
        noMoreResultLabel.hidden = true
        tableFooterView.addSubview(noMoreResultLabel)
        tableView.tableFooterView = tableFooterView
    }
    func reloadAllData() {
        mapView.removeAnnotations(businesses)
        self.businesses.removeAll()
        noMoreResultLabel.hidden = true
    }
}
