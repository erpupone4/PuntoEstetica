//
//  StartAnimationController.swift
//  HearthGuide
//
//  Created by Alessio Forte on 09/12/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit
import OneSignal

class StartAnimationController: UIViewController {
  
  
  @IBOutlet var lockBorder: UIImageView!
  @IBOutlet var topLock: UIImageView!
  @IBOutlet var botLock: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    openLock()
    
    //Codice per colorare la band bianca in basso nell'iPhone X
    self.view.backgroundColor = UIColor(rgba: "#404c5c")
    //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func openLock() {

    UIView.animate(withDuration: 1.2, delay: 0.05, options: [], animations: {
      let yDelta = self.lockBorder.frame.maxY
      
      self.topLock.center.y    -= yDelta
      self.lockBorder.center.y -= yDelta
      self.botLock.center.y    += yDelta
      
    }, completion: { _ in
      self.topLock.removeFromSuperview()
      self.lockBorder.removeFromSuperview()
      self.botLock.removeFromSuperview()
      
      self.topLock.isHidden = true
      self.lockBorder.isHidden = true
      self.botLock.isHidden = true
      
      if !DownloadManager.shared.isStartup {
        self.notifyAlert ()
        DownloadManager.shared.isStartup = true
      }
    })
  }
  
  
  //ALLO START DELL'APP CHIEDIAMO ALL'UTENTE SE VUOLE LE NOTIFICHE DI AGGIORNAMENTO
  func notifyAlert () {
    let defaults = UserDefaults.standard
    
    if defaults.string(forKey: "notify") != "1" {
      
      let alertVC = PMAlertController(title: "Notifiche Aggiornamenti",
                                      description: "Vuoi ricevere notifiche su nuovi Trattamenti e nuove Promozioni?",
                                      image: #imageLiteral(resourceName: "permission"), style: .alert)
      
      alertVC.addAction(PMAlertAction(title: "Avanti", style: .default, action: { () -> Void in
        DispatchQueue.global().async(execute: {
          let defaults = UserDefaults.standard
          defaults.set("1", forKey: "notify")
          
          OneSignal.registerForPushNotifications()
          
          self.updateAppData()
        });
      }))
      present(alertVC, animated: true, completion: nil)
      
    }
    //altrimenti controlliamo se nelle impostazioni l'utente ha attivato le notifiche, se si impostiamo l'app per ricerverle
    else {
      
      let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
      
      if notificationType != UIUserNotificationType() {
        OneSignal.registerForPushNotifications()
      }
      
      updateAppData()
    }
  }
  
  func updateAppData () {
    SwiftLoader.show("Aggiornamento...", animated: true)
    
    //controllo se l'iPhone è stato connesso ad internet
    if !Reachability.isConnectedToNetwork() {
      let alertVC = PMAlertController(title: "Errore Connessione",
                                      description: "Per poter scaricare i contenuti è necessaria una connessione a internet.",
                                      image: #imageLiteral(resourceName: "warning"), style: .alert)
      
      alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
        print("Nessuna Connessione")
      }))
      
      self.present(alertVC, animated: true, completion: nil)
      
      SwiftLoader.hide()

      return
    }
    
    DownloadManager.shared.downloadJSON("http://www.puntoesteticamonteverde.it/DatiApp.json")
  }
  
}
