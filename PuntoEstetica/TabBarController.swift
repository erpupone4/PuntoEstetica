//
//  TabBarController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 29/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
  
  @IBOutlet var tbMain: UITabBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "logo_top"))
    
    UITabBar.appearance().tintColor    = UIColor.white
    UITabBar.appearance().barTintColor = UIColor(rgba: "#2c3e50")
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.Normal)
    
    let CateItem  = tbMain.items![0] as UITabBarItem
    let PromoItem = tbMain.items![1] as UITabBarItem
    let InfoItem  = tbMain.items![2] as UITabBarItem
    
    CateItem.image  = CateItem.image?.withRenderingMode(.alwaysOriginal)
    PromoItem.image = PromoItem.image?.withRenderingMode(.alwaysOriginal)
    InfoItem.image  = InfoItem.image?.withRenderingMode(.alwaysOriginal)
    
    CateItem.selectedImage  = CateItem.selectedImage?.withRenderingMode(.alwaysOriginal)
    PromoItem.selectedImage = PromoItem.selectedImage?.withRenderingMode(.alwaysOriginal)
    InfoItem.selectedImage  = InfoItem.selectedImage?.withRenderingMode(.alwaysOriginal)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func acFavorite(_ sender: UIButton) {
    let TratController = self.storyboard?.instantiateViewController(withIdentifier: "TrattamentiController") as? TrattamentiController
    
    let noFavController = self.storyboard?.instantiateViewController(withIdentifier: "noFavController")
    
    TratController?.Categoria  = ""
    TratController?.TratList   = DownloadManager.shared.FavoArra
    TratController?.imgcate    = nil
    
    var navigator: UINavigationController = UINavigationController(rootViewController: TratController!)
    
    if DownloadManager.shared.FavoArra.count == 0 {
     navigator = UINavigationController(rootViewController: noFavController!)
    }
    
    self.present(navigator, animated: true, completion: nil)
  }
}
