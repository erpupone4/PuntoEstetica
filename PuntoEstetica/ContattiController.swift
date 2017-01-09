//
//  ContattiController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 29/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit
import MapKit

class ContattiController: UITableViewController, MKMapViewDelegate {
  
  @IBOutlet var mvMap: MKMapView!
  @IBOutlet var aiLoading: UIActivityIndicatorView!
  @IBOutlet var bbRoute: UIButton!
  @IBOutlet var bbPhone1: UIButton!
  @IBOutlet var bbPhone2: UIButton!
  @IBOutlet var bbFacebook: UIButton!
  @IBOutlet var laMap: UILabel!
  @IBOutlet var bbOrari: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mvMap.delegate         = self
    mvMap.userTrackingMode = MKUserTrackingMode.none
    
    bbPhone1.setTitleColor(UIColor(rgba: "#DBDEE2"),   for: UIControlState.Normal)
    bbPhone2.setTitleColor(UIColor(rgba: "#DBDEE2"),   for: UIControlState.Normal)
    bbFacebook.setTitleColor(UIColor(rgba: "#DBDEE2"), for: UIControlState.Normal)
    bbOrari.setTitleColor(UIColor(rgba: "#DBDEE2"),    for: UIControlState.Normal)
    bbRoute.setTitleColor(UIColor(rgba: "#DBDEE2"),    for: UIControlState.Normal)
    laMap.textColor = UIColor(rgba: "#DBDEE2")
    
    let tabBarHeight            = self.tabBarController?.tabBar.bounds.height
    self.edgesForExtendedLayout = UIRectEdge.all
    self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
    
    self.tableView.backgroundView = UIImageView(image:UIImage(named:"background"))
  }
  
  @IBAction func acRoute(_ sender: Any) {
    let latitude:CLLocationDegrees  =  41.881803
    let longitude:CLLocationDegrees =  12.460073999999963
    
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    
    let mapItem = MKMapItem(placemark: placemark)
    
    mapItem.name = "Punto Estetica Monteverde"
    
    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
    
    mapItem.openInMaps(launchOptions: launchOptions)
  }

  @IBAction func acPhone1(_ sender: UIButton) {
    if let url = NSURL(string: "tel://3914065138"), UIApplication.shared.canOpenURL(url as URL) {
      UIApplication.shared.openURL(url as URL)
    }
  }
  
  @IBAction func acPhone2(_ sender: UIButton) {
    if let url = NSURL(string: "tel://0631077846"), UIApplication.shared.canOpenURL(url as URL) {
      UIApplication.shared.openURL(url as URL)
    }
  }
  
  @IBAction func acFacebook(_ sender: UIButton) {
    if let url = NSURL(string: "https://www.facebook.com/puntoesteticamonteverde2016/"), UIApplication.shared.canOpenURL(url as URL) {
      UIApplication.shared.openURL(url as URL)
    }
  }

  @IBAction func acOrari(_ sender: UIButton) {
    let orari = "• Lunedi 15:00 - 19:30<br>• Martedi 10:00 - 19:30<br>• Mercoledi 10:00 - 19:30<br>• Giovedi 10:00 - 19:30<br>• Venerdi 10:00 - 19:30<br>• Sabato 10:00 - 14:00<br>• Domenica Chiuso"
    
    let alertVC = PMAlertController(title: "Orari Punto Estetica",
                                    description: orari.html2String + " ",
                                    image: nil, style: .walkthrough)
    
    alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
      print("Annullato")
    }))
    
    present(alertVC, animated: true, completion: nil)

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    aiLoading.startAnimating()
    aiLoading.isHidden = false
    
    
    if Reachability.isConnectedToNetwork() {
      searchPoiWithName("Punto Estetica Monteverde", map: mvMap, closure: { (pins) in
        //una volta trovato il punto cercato mettiamo il pin
        self.mvMap.addAnnotation(pins!)
        
        self.aiLoading.stopAnimating()
        self.aiLoading.isHidden = true
        let yourAnnotationAtIndex = 0
        self.mvMap.selectAnnotation(self.mvMap.annotations[yourAnnotationAtIndex], animated: true)
      })
    }
  }
  
  func searchPoiWithName(_ name: String!, map:MKMapView, closure:  @escaping (Pin?) -> Void) {
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = name
    
    let location = CLLocationCoordinate2D(latitude: 41.881803, longitude: 12.460073999999963)
    let span     = MKCoordinateSpanMake(0.006, 0.006)
    let mappa    = MKCoordinateRegion(center: location, span: span)
    
    map.setRegion(mappa, animated: false)
    
    searchRequest.region = mappa
    
    let search = MKLocalSearch(request: searchRequest)
    
    search.start { (response, error) in
      if let errorTest = error {
        debugPrint(errorTest.localizedDescription)
        closure(nil)
        return
      }
      
      if let responseTest = response {
        if responseTest.mapItems.count > 0 {
          for item in responseTest.mapItems {
            let it = item as MKMapItem
            let pin  = Pin(coordinate: it.placemark.coordinate)
            pin.title = it.name
            pin.subtitle = it.placemark.thoroughfare! + ", " + it.placemark.subThoroughfare!
            closure(pin)
          }
        } else { closure(nil) }
      } else { closure(nil) }
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    //creo un id da associare ad ogni annotationView
    let reuseId = "punto"
    
    //se esistono troppi punti nella mappa, prende quello non visto e lo riutilizza nella porzione di mappa vista
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    
    //se non è stata ancora creata un'AnnotationView la crea
    if pinView == nil {
      //creo un pin di tipo MKAnnotationView che rappresenta l'oggetto reale da inserire in mappa
      pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      //cambio l'immagine standard del point annotation con una creata da me
      pinView!.image = UIImage(named: "pin")
      //sblocco la possibilità di cliccarlo per vedere i dettagli
      pinView!.canShowCallout = true

    }
    else {
      //se esiste lo modifico con il nuovo point richiesto
      pinView!.annotation = annotation
    }
    //restituisce un pointAnnotation nuovo o modificato
    return pinView
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  
}
