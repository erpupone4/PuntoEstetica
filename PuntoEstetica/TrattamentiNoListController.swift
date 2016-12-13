//
//  TrattamentiNoListController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 29/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class TrattamentiNoListController: UIViewController {
  
  @IBOutlet var imgTestata: UIImageView!
  @IBOutlet var txTestata: UITextView!
  
  var cateItem : CategoriaModel!
  var imgcate  : UIImage!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
    navigationItem.titleView  = UIImageView(image: UIImage(named: "logo_top"))

    
    //self.navigationItem.title = cateItem.nome
    imgTestata.image          = imgcate
    txTestata.textColor       = UIColor(rgba: "#DBDEE2")
    
    txTestata.text = "Descrizione non Disponibile"
    
    if cateItem.des != "" {
      txTestata.text = cateItem.des.html2String + " "
    }
    
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    txTestata.setContentOffset(CGPoint.zero, animated: false)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
