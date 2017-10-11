//
//  AppDelegate.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit
import OneSignal
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    OneSignal.initWithLaunchOptions(launchOptions, appId: "fcf9b7d4-252d-4396-a5b5-38abfb67f8a7", handleNotificationReceived:nil, handleNotificationAction:nil, settings:[kOSSettingsKeyInFocusDisplayOption : OSNotificationDisplayType.none.rawValue, kOSSettingsKeyAutoPrompt: false])

    
    //codice per eliminare la cache dell'app in modo da rileggere i dati ad ogni avvio
    let sharedCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
    URLCache.shared = sharedCache
    
    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    
    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    if (DownloadManager.shared.MainController) != nil {
      DownloadManager.shared.MainController.navigationController!.popToRootViewController(animated: false)
    }
    
    var presentedVC = self.window?.rootViewController
    
    let alertVC = PMAlertController(title: "Aggiornamento",
                                    description: "Abbiamo aggiunto nuovi servizi, vuoi effettuare ora l'aggiornamento?",
                                    image: #imageLiteral(resourceName: "startDownload"), style: .alert)
    
    alertVC.addAction(PMAlertAction(title: "Annulla", style: .cancel, action: { () -> Void in
      print("Annullato")
    }))
    
    alertVC.addAction(PMAlertAction(title: "Aggiorna", style: .default, action: { () in
      DownloadManager.shared.downloadJSON("http://www.puntoesteticamonteverde.it/DatiApp.json")
    }))
    
    
    
    while (presentedVC!.presentedViewController != nil)  {
      presentedVC = presentedVC!.presentedViewController
    }

    presentedVC!.present(alertVC, animated: true, completion: nil)
    
    completionHandler(.newData)
  }
  
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    switch shortcutItem.type {
          case "com.puntoestetica.call":
            if let url = NSURL(string: "tel://3914065138"), UIApplication.shared.canOpenURL(url as URL) {
              UIApplication.shared.openURL(url as URL)
            }
          case "com.puntoestetica.route":
            let latitude:CLLocationDegrees  =  41.8623074
            let longitude:CLLocationDegrees =  12.467293499999982
            
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            
            let mapItem = MKMapItem(placemark: placemark)
            
            mapItem.name = "Punto Estetica Monteverde"
            
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            mapItem.openInMaps(launchOptions: launchOptions)
      
          case "com.puntoestetica.card":
            // becchiamo lo storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let addController = storyboard.instantiateViewController(withIdentifier: "card")
            
            window?.rootViewController?.present(addController, animated: true, completion: nil)
      
          default: break
      }
    }
//
//  //*** MODIFICA 3D TOUCH ***\\
//  // questo metodo scatta quando viene premuto un pulsante nel menù del 3D Touch chè è uscito premendo con forza l'icona dell'App
//  private func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
//    debugPrint("Chiamato")
//    // il metodo ci porta in dono la var shortcutItem che contiene le chiavi, quindi possiamo fare uno switch
//    switch shortcutItem.type {
//      // questa è la chiave inserita nel file info.plist alla voce UIApplicationShortcutItems
//      // per capire tutto il passaggio della chiave consultare il libro iOS 9 by Tutorial che trovi su Dropbox
//    // pagine 120 e 121
//    case "com.puntoestetica.call":
//      // becchiamo lo storyboard
//      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//      // gli diciamo di caricare il controller che nel campo Storyboard ID (tab carta di identità) è stato chiamato add
//      // altri non è che il nostro AddController.swift
//      // (ma poichè AddController è dentro un Navigation il nome è stato dato al NavigationController che sta prima di lui)
//      let addController = storyboard.instantiateViewController(withIdentifier: "info")
//
//      // becchiamo il controller principale e gli diciamo di presentare l'AddController
//      window?.rootViewController?.present(addController, animated: true, completion: nil)
//
//    default: break
//    }
//    completionHandler(true)
//
//  }
  
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
  
}

