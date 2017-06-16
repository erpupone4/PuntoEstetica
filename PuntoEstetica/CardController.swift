//
//  CardController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 16/06/17.
//  Copyright © 2017 Alessio Forte. All rights reserved.
//

import UIKit

class CardController: UIViewController {

  @IBOutlet var imgCard: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func acTapClose(_ sender: Any) {
    self.dismiss(animated: true, completion: {})
  }

}
