//
//  NoFavoritesController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 18/10/17.
//  Copyright © 2017 Alessio Forte. All rights reserved.
//

import UIKit

class NoFavoritesController: UIViewController {
  
  @IBOutlet var laMsg: UILabel!
  @IBOutlet var laExample: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Codice per colorare la band bianca in basso nell'iPhone X
    self.view.backgroundColor                         = UIColor(rgba: "#404c5c")
    
    navigationController!.navigationBar.barTintColor  = UIColor(rgba: "#2c3e50")
    navigationItem.titleView                          = UIImageView(image: UIImage(named: "logo_top"))

    laExample.textColor = UIColor(rgba: "#DBDEE2")
    laMsg.textColor     = UIColor(rgba: "#DBDEE2")
    
    let backbutton = UIButton(type: .custom)
    backbutton.setImage(UIImage(named: "botArrow"), for: .Normal)
    backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
  }
  
  @objc func backAction() -> Void {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
