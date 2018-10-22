//
//  PromoController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 01/12/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class PromoController: UITableViewController {
  
  var PromoList : [TrattamentoModel] = []
  var imgcate   : UIImage!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.backgroundView                     = UIImageView(image:UIImage(named:"background"))
    navigationController!.navigationBar.barTintColor  = UIColor(rgba: "#474e58")
    navigationItem.titleView                          = UIImageView(image: UIImage(named: "logo_top"))
    
    let filtered = DownloadManager.shared.localArra.filter {
      $0.nome == "Promozioni"
    }
    
    if filtered.count > 0 {
      PromoList = filtered[0].lista
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PromoList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath) as! PromoCell
    
    cell.preservesSuperviewLayoutMargins = false
    cell.separatorInset = UIEdgeInsets.zero
    cell.layoutMargins  = UIEdgeInsets.zero
    
    let promo = PromoList[indexPath.row]
    
    cell.laNome.text  = promo.nome
    
    if promo.min != "" {
      cell.laVali.text   = promo.min;
    } else {
      cell.laVali.text   = "";
    }
    
    cell.request = request("http://www.puntoesteticamonteverde.it/"+promo.img, method: .get).responseData(completionHandler: { (data) in

      if data.response != nil {
        // questo controllo serve per mettere l'icona giusta nella cella giusta
        // bisogna assicurarsi che metta le immagini al posto giusto
        if data.request?.urlString == cell.request?.request!.urlString {
          
          cell.imgPromo.image = UIImage(data: data.data!)
        }
      } else {
        print("errore")
      }
    })
  
    cell.laNome.textColor  = UIColor(rgba: "#DBDEE2")
    cell.laVali.textColor  = UIColor(rgba: "#DBDEE2")
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let cell = tableView.cellForRow(at: indexPath) as! PromoCell
    
    let alertVC = PMAlertController(title: cell.laNome.text!,
                                    description: PromoList[indexPath.row].des.html2String + " ",
                                    image: cell.imgPromo.image, style: .walkthrough)
    
    alertVC.addAction(PMAlertAction(title: "Condividi", style: .default, action: { () -> Void in
      let oggetti = [cell.imgPromo.image ?? #imageLiteral(resourceName: "logo"), cell.laNome.text!, self.PromoList[indexPath.row].des.html2String] as [Any]
      
      // creiamo un'istanza di UIActivityViewController
      let act = UIActivityViewController(activityItems: oggetti,
                                         applicationActivities: nil)
      
      //per esculdere delle condivisioni (eventualmente.. :) decommentare questa riga
      // eliminare quello che NON vuoi che sia escluso
      //act.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop]
      
      self.present(act, animated: true, completion: nil)
    }))
    
    alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
      print("Annullato")
    }))
    
    present(alertVC, animated: true, completion: nil)
    
    self.tableView.deselectRow(at: indexPath, animated:true)
  }
 
}
