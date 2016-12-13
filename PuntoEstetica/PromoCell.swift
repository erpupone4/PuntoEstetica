//
//  PromoCell.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 01/12/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class PromoCell: UITableViewCell {
  
  @IBOutlet var imgPromo: UIImageView!
  @IBOutlet var laNome: UILabel!
  @IBOutlet var laVali: UILabel!
  
  // questa var speciale serve per distinguere le richieste di download dell'icona da una cella all'altra
  // è necessario per via del riciclo di celle operato dalla tableView
  var request : Request?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
}
