//
//  AppDelegate.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit
import OneSignal

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

