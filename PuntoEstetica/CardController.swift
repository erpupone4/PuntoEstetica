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
  @IBOutlet var laCode1: UILabel!
  @IBOutlet var laCode2: UILabel!
  @IBOutlet var laCode3: UILabel!
  @IBOutlet var laCode4: UILabel!
  @IBOutlet var laCode5: UILabel!
  @IBOutlet var laCode6: UILabel!
  @IBOutlet var laCode7: UILabel!
  @IBOutlet var laCode8: UILabel!
  @IBOutlet var laCode9: UILabel!
  @IBOutlet var laCode10: UILabel!
  @IBOutlet var laCode11: UILabel!
  @IBOutlet var laCode12: UILabel!
  @IBOutlet var laCode13: UILabel!
  @IBOutlet var csTop1: NSLayoutConstraint!
  @IBOutlet var csTop2: NSLayoutConstraint!
  @IBOutlet var csTop3: NSLayoutConstraint!
  @IBOutlet var csTop4: NSLayoutConstraint!
  @IBOutlet var csTop5: NSLayoutConstraint!
  @IBOutlet var csTop6: NSLayoutConstraint!
  @IBOutlet var csTop7: NSLayoutConstraint!
  @IBOutlet var csTop8: NSLayoutConstraint!
  @IBOutlet var csTop9: NSLayoutConstraint!
  @IBOutlet var csTop10: NSLayoutConstraint!
  @IBOutlet var csTop11: NSLayoutConstraint!
  @IBOutlet var csTop12: NSLayoutConstraint!
  @IBOutlet var csTop13: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.view.backgroundColor = UIColor(rgba: "#474e58")
    self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
    
    // || IDevice.current.modelName == "Simulator")
    if  (UIDevice.current.modelName == "iPhone 5")  || (UIDevice.current.modelName == "iPhone 5c") || (UIDevice.current.modelName == "iPhone 5s") || (UIDevice.current.modelName == "iPhone SE")
    {
      csTop1.constant  = 250
      csTop2.constant  = 277 //292
      csTop3.constant  = 294
      csTop4.constant  = 311
      csTop5.constant  = 328
      csTop6.constant  = 344
      csTop7.constant  = 361
      
      csTop8.constant  = 389
      csTop9.constant  = 406
      csTop10.constant = 423
      csTop11.constant = 440
      csTop12.constant = 456
      csTop13.constant = 473
      
      laCode1.font  = laCode1.font.withSize(19)
      laCode2.font  = laCode1.font.withSize(19)
      laCode3.font  = laCode1.font.withSize(19)
      laCode4.font  = laCode1.font.withSize(19)
      laCode5.font  = laCode1.font.withSize(19)
      laCode6.font  = laCode1.font.withSize(19)
      laCode7.font  = laCode1.font.withSize(19)
      laCode8.font  = laCode1.font.withSize(19)
      laCode9.font  = laCode1.font.withSize(19)
      laCode10.font = laCode1.font.withSize(19)
      laCode11.font = laCode1.font.withSize(19)
      laCode12.font = laCode1.font.withSize(19)
      laCode13.font = laCode1.font.withSize(19)
    }
    
    let defaults = UserDefaults.standard
    
    if let stringOne = defaults.string(forKey: "code1") {
      print(stringOne)
    } else {
      defaults.set(String(arc4random_uniform(10)), forKey: "code1")
      defaults.set(String(arc4random_uniform(10)), forKey: "code2")
      defaults.set(String(arc4random_uniform(10)), forKey: "code3")
      defaults.set(String(arc4random_uniform(10)), forKey: "code4")
      defaults.set(String(arc4random_uniform(10)), forKey: "code5")
      defaults.set(String(arc4random_uniform(10)), forKey: "code6")
      defaults.set(String(arc4random_uniform(10)), forKey: "code7")
      defaults.set(String(arc4random_uniform(10)), forKey: "code8")
      defaults.set(String(arc4random_uniform(10)), forKey: "code9")
      defaults.set(String(arc4random_uniform(10)), forKey: "code10")
      defaults.set(String(arc4random_uniform(10)), forKey: "code11")
      defaults.set(String(arc4random_uniform(10)), forKey: "code12")
      defaults.set(String(arc4random_uniform(10)), forKey: "code13")
    }
    
    laCode1.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode1.text       = defaults.string(forKey: "code1")
    laCode1.sizeToFit()
    
    laCode2.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode2.text       = defaults.string(forKey: "code2")
    laCode2.sizeToFit()
    
    laCode3.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode3.text       = defaults.string(forKey: "code3")
    laCode3.sizeToFit()
    
    laCode4.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode4.text       = defaults.string(forKey: "code4")
    laCode4.sizeToFit()
    
    laCode5.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode5.text       = defaults.string(forKey: "code5")
    laCode5.sizeToFit()
    
    laCode6.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode6.text       = defaults.string(forKey: "code6")
    laCode6.sizeToFit()
    
    laCode7.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode7.text       = defaults.string(forKey: "code7")
    laCode7.sizeToFit()
    
    laCode8.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode8.text       = defaults.string(forKey: "code8")
    laCode8.sizeToFit()
    
    laCode9.transform  = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode9.text       = defaults.string(forKey: "code9")
    laCode9.sizeToFit()
    
    laCode10.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode10.text      = defaults.string(forKey: "code10")
    laCode10.sizeToFit()
    
    laCode11.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode11.text      = defaults.string(forKey: "code11")
    laCode11.sizeToFit()
    
    laCode12.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode12.text      = defaults.string(forKey: "code12")
    laCode12.sizeToFit()
    
    laCode13.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    laCode13.text      = defaults.string(forKey: "code13")
    laCode13.sizeToFit()
    
    self.view.layoutIfNeeded()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func acTapClose(_ sender: Any) {
    self.dismiss(animated: true, completion: {})
  }

}
