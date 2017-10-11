//
//  TodayViewController.swift
//  
//
//  Created by Alessio Forte on 11/10/17.
//

import UIKit
import MapKit

class TodayViewController: UICollectionViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear  = false
    self.collectionView?.backgroundColor  = UIColor.clear

//      self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }


  override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 3
  }
  
  // dice quanto deve essere il margine del nostro widget dai bordi
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    // visto che abbiamo una collection view usiamo le sue funzioni per distanziare le celle
    // quindi restituiamo zero margine
    return UIEdgeInsetsMake(0, 50, 0, 0)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "today_cell", for: indexPath) as! TodayCell
    
    switch indexPath.row {
      case 0:
        cell.imgCell.image = #imageLiteral(resourceName: "today_phone")
        cell.laCell.text   = "Contattaci"
      case 1:
        cell.imgCell.image = #imageLiteral(resourceName: "today_route")
        cell.laCell.text   = "Indicazioni"
      case 2:
        cell.imgCell.image = #imageLiteral(resourceName: "today_card")
        cell.laCell.text   = "Fidelity Card"
      default:
        cell.imgCell.image = #imageLiteral(resourceName: "today_card")
        cell.laCell.text   = "Fidelity Card"
    }
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  // questo metodo scatta quando viene toccata una cella della CollectionView
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      self.extensionContext?.open(NSURL(string: "tel://3914065138")! as URL)
    case 1:
      let latitude:CLLocationDegrees  =  41.8623074
      let longitude:CLLocationDegrees =  12.467293499999982
      
      let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
      let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
      
      let mapItem = MKMapItem(placemark: placemark)
      
      mapItem.name = "Punto Estetica Monteverde"
      
      let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
      
      mapItem.openInMaps(launchOptions: launchOptions)
    case 2:
      // l'url deve essere per forza fatto così pizzalist://?q=,la parte ?q= è importante se la creazione dell'url fallise
      guard let url = URL(string: "puntoestetica://?q=\(indexPath.row)") else { return }
    
      // diciamo all'esxtension di aprire un url, e gli passiamo quello della nostra App
      extensionContext?.open(url, completionHandler: nil)
    default:
      self.extensionContext?.open(NSURL(string: "tel://3914065138")! as URL)
    }
  }
}


