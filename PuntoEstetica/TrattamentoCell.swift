//
//  TrattamentoCell.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class TrattamentoCell: UITableViewCell {

  @IBOutlet var laNome: UILabel!
  @IBOutlet var laMin: UILabel!
  @IBOutlet var laCosto: UILabel!
  @IBOutlet var bbInfo: UIButton!
  @IBOutlet var imgCell: UIImageView!
  @IBOutlet var imgMin: UIImageView!
  @IBOutlet var imgEuro: UIImageView!
  @IBOutlet var imgNew: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
