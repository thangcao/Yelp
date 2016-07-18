//
//  DetailViewController.swift
//  Yelp
//
//  Created by Cao Thắng on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
class DetailViewController: UIViewController {
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var thumbailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var isOpenLabel: UILabel!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    let regionRadius: CLLocationDistance = 1000
    var business : Business!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configDataToView()
        initMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension DetailViewController {
    func configDataToView() {
        nameLabel.text = business.name!
        distanceLabel.text = business.distance!
        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        categoriesLabel.text = business.categories!
        isOpenLabel.text = (business.isOpened! == 0) ? "Close" : "Open"
        phoneNumberLabel.text = business.phoneNumber!
        thumbailImageView.setImageWithURL(business.imageURL!)
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        addressLabel.text = business.address!
    }
}
extension DetailViewController : MKMapViewDelegate{
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

    func initMapView(){
        // set initial location
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude)
        centerMapOnLocation(initialLocation)
        mapView.addAnnotation(business)
        mapView.showAnnotations([business], animated: true)
        mapView.selectAnnotation(business, animated: true)

    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
