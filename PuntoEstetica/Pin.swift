//
//  PizzeriaAnnotation.swift
//  PizzaList
//
//  Created by Marcello Catelli on 24/07/16.
//  Copyright (c) 2016 Objective C srl. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Pin:NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    var title      : String?
    var subtitle   : String?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
