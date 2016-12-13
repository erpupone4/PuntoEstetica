//
//  MapManager.swift
//  PizzaList
//
//  Created by Marcello Catelli on 28/07/16.
//  Copyright (c) 2016 Objective C srl. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI
import Contacts

protocol MapManagerDelegate {
    func incomingUserLocation(_ location: CLLocationCoordinate2D)
    func incomingError(_ message:String)
    func permissionOk()
}

class MapManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = MapManager()
    
    var locationManager : CLLocationManager!
    var findLocation = false
    var delegate : MapManagerDelegate?
    
    func setupLocationManager(backgroundMode bgMode:Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = bgMode
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        if CLLocationManager.authorizationStatus() == .notDetermined ||
            CLLocationManager.authorizationStatus() == .denied {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestSingleLocation() {
        findLocation = false
        self.locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !findLocation {
            findLocation = true
            if locations.count > 0 {
                let location = locations[0] as CLLocation
                self.delegate?.incomingUserLocation(location.coordinate)
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("didFailWithError: \(error)")
        findLocation = false
        self.delegate?.incomingError("Failed to find location")
    }
    
    func locationManager(_ manager: CLLocationManager,  didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            case .restricted: self.delegate?.incomingError("Restricted Access to location")
            case .denied:  self.delegate?.incomingError("User denied access to location")
            case .notDetermined: self.delegate?.incomingError("Status not determined")
            case .authorizedAlways: self.delegate?.permissionOk()
            case .authorizedWhenInUse: self.delegate?.permissionOk()
        }
    }
    
    func searchPoiWithName(_ name: String!, map:MKMapView, closure:  @escaping ([Pin]?) -> Void) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = name
        searchRequest.region = map.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            if let errorTest = error {
                debugPrint(errorTest.localizedDescription)
                closure(nil)
                return
            }
            
            if let responseTest = response {
                if responseTest.mapItems.count > 0 {
                    var arra : [Pin] = []
                    for item in responseTest.mapItems {
                        let it = item as MKMapItem
                        let pin  = Pin(coordinate: it.placemark.coordinate)
                        pin.title = it.name
                        pin.subtitle = it.placemark.thoroughfare //it.placemark.addressDictionary[] as? String
                        pin.phone = it.phoneNumber
                        arra.append(pin)
                    }
                    closure(arra)
                } else { closure(nil) }
            } else { closure(nil) }
        }
    }
    
    func georeverseAddress(_ address: String!, closure:  @escaping (Pin?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let errorTest = error {
                debugPrint(errorTest.localizedDescription)
                closure(nil)
                return
            }
            
            if let placeTest = placemarks {
                if let cpTest = placeTest.first {
                    let pin = Pin(coordinate: cpTest.location!.coordinate)
                    let coordinate = "\(cpTest.location!.coordinate.latitude) \(cpTest.location!.coordinate.longitude)"
                    pin.title = address
                    pin.subtitle = coordinate
                    closure(pin)
                } else { closure(nil) }
            } else { closure(nil) }
        }
    }
    
    func georeverseCoordinate(_ coord: CLLocationCoordinate2D, closure:  @escaping (String?) -> Void) {
        
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let errorTest = error {
                debugPrint(errorTest.localizedDescription)
                closure(nil)
                return
            }
            
            if let placeTest = placemarks {
                if let cpTest = placeTest.first {
                    debugPrint(cpTest.thoroughfare!)
                    debugPrint(cpTest.locality!)
                    debugPrint(cpTest.country!)
                    var pieces : [String] = []
                    if let throTest = cpTest.thoroughfare {
                        pieces.append(throTest)
                    }
                    if let locTest = cpTest.locality {
                        pieces.append(locTest)
                    }
                    if let conTest = cpTest.country {
                        pieces.append(conTest)
                    }
                    if pieces.count < 1 {
                        closure(nil)
                    } else {
                        let address = pieces.joined(separator: ", ")
                        closure(address)
                    }
                } else { closure(nil) }
            } else { closure(nil) }
        }
    }
}
