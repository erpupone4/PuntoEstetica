//
//  CategoriaCell.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit

class CategoriaCell: UITableViewCell {

  @IBOutlet var laNome: UILabel!
  @IBOutlet var imgCate: UIImageView!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
