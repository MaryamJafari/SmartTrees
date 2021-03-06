//
//  Nearby.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/15/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import StoreKit
import FirebaseAuth
class Nearby: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var mapHasCenterOnce = false
    var geoFire: GeoFire!
    var emailAddress: String!
    var geoFireRef : DatabaseReference!
    var nearByTree : Tree!
    var menuShowing = false
    var name: String!
    var phone : String!
    var emailAd : String!
    var password : String!
    var isShow = false
    var treeBarcode = ""
    var trees = [Tree]()
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var mapwidh: NSLayoutConstraint!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var menuBar: UIBarButtonItem!
    @IBOutlet weak var leadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func MenuBarClick(_ sender: Any) {
        showMenuBar()
        
    }
    @IBAction func UserNameAction(_ sender: Any) {
        performSegue(withIdentifier: "SignUpBack", sender: self)
    }
    
    @IBAction func scanBarcode(_ sender: Any) {
        performSegue(withIdentifier: "Barcode", sender: "")
        
    }
    func changeCoordinate(){
        
        if treeBarcode != "" {
            
            trees = PardeTreesFromCSVFile().parsTreeCSV()
            for tree in trees{
                if tree.barcode == treeBarcode{
                    let coordinate = tree.getCoordinateByTreeId(treeId: tree.treeId)
                    
                    let loc = CLLocation(latitude: coordinate.latitude , longitude: coordinate.longtitud)
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 2000, 2000)
                    map.setRegion(coordinateRegion, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func MenuButton(_ sender: Any) {
    }
    func showMenuBar(){
        if !menuShowing {
            leadingConstrains.constant = 0
            mapwidh.constant = 195
            menuShowing = true
        }
        else{
            leadingConstrains.constant = -155
            mapwidh.constant = 350
            menuShowing = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapwidh.constant = 350
        if let user =   UserDefaults.standard.string(forKey: "email"){
            userNameButton.setTitle(user,for: .normal)
        }
        
        map.delegate = self
        map.userTrackingMode = MKUserTrackingMode.follow
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        setTreeSpot()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            map.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            map.showsUserLocation = true
        }
    }
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location{
            if !mapHasCenterOnce{
                centerMapOnLocation(location: loc)
                mapHasCenterOnce = true
            }
        }
        if treeBarcode != ""{
            changeCoordinate()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotaionView : MKAnnotationView?
        let annoIdentifire = "Tree"
        
        if annotation.isKind(of: MKUserLocation.self){
            annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotaionView?.image = UIImage(named: "icons8-User Location-40")
        }
        else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifire){
            annotaionView = deqAnno
            annotaionView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifire)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotaionView = av
        }
        if let annotationView = annotaionView, let _ = annotation as? TreeAnnotation{
            annotaionView?.canShowCallout = true
            annotationView.image = UIImage(named: "icons8-Oak Tree-48.png")
            let btn = UIButton()
            
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            btn.setImage(UIImage(named: "icons8-Map Marker-48"), for: .normal)
            
            
            annotaionView?.rightCalloutAccessoryView = btn
        }
        return annotaionView
    }
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
        
    }
    
    
    func setTreeSpot() {
        trees = PardeTreesFromCSVFile().parsTreeCSV()
        for tree in trees{
            let coordinate = tree.getCoordinateByTreeId(treeId: tree.treeId)
            
            let loc = CLLocation(latitude: coordinate.latitude , longitude: coordinate.longtitud)
            createSighting(forLocation: loc, withTree: tree.treeId)
        }
    }
    
    func createSighting(forLocation location: CLLocation, withTree treeId : Int){
        geoFire.setLocation(location, forKey: "\(treeId)")
    }
    
    func showSightingOnMap(location :CLLocation){
        let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                let anno = TreeAnnotation(coordinate: location.coordinate, treeNumber: Int(key)!)
                self.map.addAnnotation(anno)
            }
        })
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        trees = PardeTreesFromCSVFile().parsTreeCSV()
        for tree in trees{
            let coordinate = tree.getCoordinateByTreeId(treeId: tree.treeId)
            
            let loc = CLLocation(latitude: coordinate.latitude , longitude: coordinate.longtitud)
            showSightingOnMap(location: loc)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? TreeAnnotation{
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Tree \(anno.treeName)"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate,regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate : regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:regionSpan.span), MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.00775, 0.00775)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let region = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
        }
        self.map.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    @IBAction func refLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func clickComments(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            performSegue(withIdentifier: "ShowComment", sender: treeBarcode)
            
        }
    }
  
    @IBAction func clickInteraction(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            
            performSegue(withIdentifier: "InteractWithBarcode", sender: treeBarcode)
        }
    }
    @IBAction func ClickNearBy(_ sender: Any) {
        if treeBarcode == ""
        {
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            
        }
    }
    @IBAction func clickPhoto(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            performSegue(withIdentifier: "ShowPhotoWithBarcode", sender: treeBarcode)
        }
    }
    @IBAction func Voice(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            performSegue(withIdentifier: "Voice", sender: treeBarcode)
        }
    }
    @IBAction func clickAbout(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            performSegue(withIdentifier: "AboutWihBarcode", sender: treeBarcode)
        }
    }
    
    
    @IBAction func clickShare(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            performSegue(withIdentifier: "Share", sender: treeBarcode)
        }
    }
    @IBAction func rate(_ sender: Any) {
        if treeBarcode == ""
        {
            let alertController = UIAlertController(title: "", message: "First Scan Barcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(alertController, animated: true, completion: nil)
            performSegue(withIdentifier: "Barcode", sender: "")
        }
        else{
            SKStoreReviewController.requestReview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoWithBarcode"{
            if let destination = segue.destination as? PhotoAndVideo{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        if segue.identifier == "AboutWihBarcode"{
            if let destination = segue.destination as? About{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        if segue.identifier == "InteractWithBarcode"{
            if let destination = segue.destination as? Interact{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        
        
        if segue.identifier == "ShowComment"{
            if let destination = segue.destination as? Comment{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        if segue.identifier == "Rating"{
            if let destination = segue.destination as? Rating{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        if segue.identifier == "Voice"{
            if let destination = segue.destination as? Video{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        if segue.identifier == "SignUpBack"{
            if let destination = segue.destination as? SignUp{
                
                destination.emailAddress = emailAddress
                destination.name = name
                destination.phone = phone
                destination.password = password
                
            }
        }
        if segue.identifier == "Share"{
            if let destination = segue.destination as? share{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                }
            }
        }
        
    }
    @IBAction func logOut(_ sender: Any) {
        if logOut(){
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
    func logOut() -> Bool{
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                return true
            }catch{
                return false
            }
        }
        return true
        
    }
    
}
