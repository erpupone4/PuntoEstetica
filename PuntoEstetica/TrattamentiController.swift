//
//  TrattamentiController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit


class TrattamentiController: UITableViewController, UIViewControllerTransitioningDelegate, UISearchBarDelegate {
  
  var Categoria     : String!
  var TratList      : [TrattamentoModel]!
  var imgcate       : UIImage!
  var FiltTratList  : [TrattamentoModel] = []
  var FiltName      : [String] = []
  var isSearch      : Bool        = false
  var mySearchBar   : UISearchBar = UISearchBar()
  var itemName      : String!
  var itemDes       : String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.backgroundView                     = UIImageView(image:UIImage(named:"background"))
    navigationController!.navigationBar.barTintColor  = UIColor(rgba: "#2c3e50")
    navigationItem.titleView                          = UIImageView(image: UIImage(named: "logo_top"))
    
    if self.Categoria == "" {
      let backbutton = UIButton(type: .custom)
      backbutton.setImage(UIImage(named: "botArrow"), for: .Normal)
      backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
      
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
  }
  
  func backAction() -> Void {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearch && mySearchBar.text!.characters.count > 0 {
      return FiltTratList.count + 1
    } else {
        return  TratList.count + 1
      }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    mySearchBar.barStyle        = UIBarStyle.blackTranslucent
    mySearchBar                 = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    mySearchBar.delegate        = self
    mySearchBar.barStyle        = UIBarStyle.blackTranslucent
    mySearchBar.placeholder     = "Cerca Trattamento.."
    mySearchBar.backgroundImage = UIImage(named:"background")

    let SearchBarTextField      = mySearchBar.value(forKey: "searchField") as? UITextField
    SearchBarTextField?.textColor = UIColor(rgba: "#DBDEE2")
    
    return mySearchBar
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      if Categoria == "" {
        return 0
      }
      return 250
    }
    return 65
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
      
      cell.preservesSuperviewLayoutMargins = false
      cell.separatorInset = UIEdgeInsets.zero
      cell.layoutMargins  = UIEdgeInsets.zero

      cell.imgCell.image  = imgcate
      cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
      
      return cell
      
    }else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TratCell", for: indexPath) as! TrattamentoCell
      
      cell.preservesSuperviewLayoutMargins = false
      cell.separatorInset = UIEdgeInsets.zero
      cell.layoutMargins  = UIEdgeInsets.zero
      
      var trat = TrattamentoModel()
      
      if isSearch && mySearchBar.text!.characters.count > 0 {
         trat = FiltTratList[indexPath.row - 1]
      } else {
         trat = TratList[indexPath.row - 1]
      }
      
      cell.bbInfo.isHidden          = false
      cell.bbInfo.isHidden          = false
      cell.isUserInteractionEnabled = true
      cell.imgMin.isHidden          = false
      
      if trat.min != "" {
        if trat.min.range(of: "Cera") != nil {
          cell.laMin.text = trat.min
        }else {
           cell.laMin.text = trat.min + " minuti"
        }
      } else {
        cell.imgMin.isHidden = true
        cell.laMin.text      = ""
      }
      
      if trat.costo != "" {
        cell.laCosto.text = trat.costo + " €"
      } else {
        cell.imgEuro.isHidden = true
        cell.laCosto.text     = ""
      }
      
      if Categoria == "Epilazione" {
        if trat.min.range(of: "Uomo") != nil{
          cell.imgMin.image = UIImage(named: "uomo")!
        }else {
          cell.imgMin.image = UIImage(named: "donna")!
        }
      }
      
      cell.imgNew.isHidden   = trat.new == ""
      cell.laNome.text       = trat.nome
      cell.imgCell.image     = UIImage(named: trat.cate)!
      cell.laNome.textColor  = UIColor(rgba: "#DBDEE2")
      cell.laMin.textColor   = UIColor(rgba: "#DBDEE2")
      cell.laCosto.textColor = UIColor(rgba: "#DBDEE2")

      if trat.des == "" {
        cell.bbInfo.isHidden          = true
        cell.isUserInteractionEnabled = false
      }
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    if indexPath.row != 0 {
      
      itemName = ""
      itemDes  = ""
      
      if isSearch && mySearchBar.text!.characters.count > 0 {
        itemName = FiltTratList[indexPath.row - 1].nome
        itemDes  = FiltTratList[indexPath.row - 1].des.html2String + " "
      } else {
        itemName = TratList[indexPath.row - 1].nome
        itemDes  = TratList[indexPath.row - 1].des.html2String + " "
      }
      
      let cell = tableView.cellForRow(at: indexPath) as! TrattamentoCell
      
      let alertVC = PMAlertController(title: cell.laNome.text!,
                                      description: itemDes,
                                      image: nil, style: .walkthrough)
      
      alertVC.addAction(PMAlertAction(title: "Condividi", style: .default, action: { () -> Void in
        DispatchQueue.global().async {
          let oggetti = [#imageLiteral(resourceName: "logo"), self.itemName, self.itemDes] as [Any]
          
          // creiamo un'istanza di UIActivityViewController
          let act = UIActivityViewController(activityItems: oggetti, applicationActivities: nil)
          
          //per esculdere delle condivisioni (eventualmente.. :) decommentare questa riga
          // eliminare quello che NON vuoi che sia escluso
          //act.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop]
          
          self.present(act, animated: true, completion: nil)
        }
      }))
      
      
      alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
        print("Annullato")
      }))
      
      present(alertVC, animated: true, completion: nil)
      
      self.tableView.deselectRow(at: indexPath, animated:true)
    }
  }
  
  
  @available(iOS 11.0, *)
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    var confg = UISwipeActionsConfiguration()
    
    if self.Categoria == "" {
      let action = UIContextualAction(style: .normal, title: nil) { (action, view, done) in
        DownloadManager.shared.delPreferito(index: indexPath.row - 1)
        
        if self.isSearch && self.mySearchBar.text!.characters.count > 0 {
          self.TratList.remove(at: self.TratList.index(of: self.FiltTratList[indexPath.row - 1])!)
          self.FiltTratList.remove(at: indexPath.row - 1)
        } else {
          self.TratList.remove(at: indexPath.row - 1)
        }

        tableView.isEditing = false
        tableView.reloadData()
        
        if self.TratList.count == 0 {
          self.navigationController?.dismiss(animated: true, completion: nil)
        }
      }
      action.backgroundColor = UIColor(rgba: "#ed3e38")
      action.image = #imageLiteral(resourceName: "trash")
      
      confg = UISwipeActionsConfiguration(actions: [action])
    } else {
      let action = UIContextualAction(style: .normal, title: nil) { (action, view, done) in

        if !(DownloadManager.shared.FavoArra.contains(where: { $0.nome == self.TratList[indexPath.row - 1].nome})) {
          if self.isSearch && self.mySearchBar.text!.characters.count > 0 {
            DownloadManager.shared.addPreferito(trat: self.FiltTratList[indexPath.row - 1])
          } else {
            DownloadManager.shared.addPreferito(trat: self.TratList[indexPath.row - 1])
          }

          let alertVC = PMAlertController(title: "Preferiti",
                                          description: "Trattamento aggiunto tra i preferiti.",
                                          image: nil, style: .alert)
          
          alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
            print("Annullato")
          }))
          
          self.present(alertVC, animated: true, completion: nil)
        } else {
          let alertVC = PMAlertController(title: "Preferiti",
                                          description: "Trattamento già presente nei preferiti.",
                                          image: nil, style: .alert)
          
          alertVC.addAction(PMAlertAction(title: "Chiudi", style: .default, action: { () -> Void in
            print("Annullato")
          }))
          
          self.present(alertVC, animated: true, completion: nil)
        }

        tableView.isEditing = false
        tableView.reloadData()
      }
      action.backgroundColor = UIColor(rgba: "#50f491")
      action.image = #imageLiteral(resourceName: "prefButton")
      
      confg = UISwipeActionsConfiguration(actions: [action])
    }
    
    return confg
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    var button = UITableViewRowAction ()
    
    if self.Categoria == "" {
      button = UITableViewRowAction(style: .normal, title: "\u{267A}\n Delete") { action, index in
        DownloadManager.shared.delPreferito(index: editActionsForRowAt.row - 1)
        
        if self.isSearch && self.mySearchBar.text!.characters.count > 0 {
          self.TratList.remove(at: self.TratList.index(of: self.FiltTratList[editActionsForRowAt.row - 1])!)
          self.FiltTratList.remove(at: editActionsForRowAt.row - 1)
        } else {
          self.TratList.remove(at: editActionsForRowAt.row - 1)
        }

        
        tableView.isEditing = false
        tableView.reloadData()
        
        if self.TratList.count == 0 {
          self.navigationController?.dismiss(animated: true, completion: nil)
        }
      }
    } else {
      button = UITableViewRowAction(style: .normal, title: "\u{2606}\n Like") { action, index in
        if self.isSearch && self.mySearchBar.text!.characters.count > 0 {
          DownloadManager.shared.addPreferito(trat: self.FiltTratList[editActionsForRowAt.row - 1])
        } else {
          DownloadManager.shared.addPreferito(trat: self.TratList[editActionsForRowAt.row - 1])
        }

        tableView.isEditing = false
        tableView.reloadData()
      }
    }
    
    return [button]
  }
  
  /*METODI PER LA RICERCA NELLA TABLE*/
  
  // questo serve per capire quando l'utente tocca la barra per iniziare a cercare
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(true, animated: true)
    
    for ob: UIView in ((searchBar.subviews[0] )).subviews {
      if let z = ob as? UIButton {
        let btn: UIButton = z
        btn.setTitleColor(UIColor(rgba: "#DBDEE2"), for: .Normal)
      }
    }
    
    isSearch = true
  
    // questo serve perchè il metodo searchBarShouldBeginEditing servirebbe per abilitare / disabilitare la ricerca
    // quindi deve restituire un Bool
    return true
  }
  
  // questo serve per capire quando l'untente preme il button Cancel nella barra di ricerca
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
    
    isSearch = false
    
    // chiudiamo la tastiera e usciamo dalla ricerca
    searchBar.resignFirstResponder()
    
    // ricarichiamo la table per far tornare tutto alla normalità
    tableView.reloadData()
  }
  
  // questo serve nel caso in cui l'utente prema invio sulla tastiera della searchbar
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // chiudiamo la tastiera e usciamo dalla ricerca
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    FiltTratList.removeAll()
    FiltName.removeAll()
    
    for trat in TratList {
      FiltName.append(trat.nome)
    }
    
    FiltName = FiltName.filter() {
      $0.range(of: mySearchBar.text!, options: .caseInsensitive) !=  nil
    }

    for trat in TratList {
      if FiltName.index(of: trat.nome) != nil {
        FiltTratList.append(trat)
      }
    }
    
    tableView.reloadData()
  }
  
  //Metodi per Animazione Bubble
  let transition    = BubbleTransition()
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint  = self.view.center
    transition.duration       = 0.35
    transition.bubbleColor    = UIColor.black.withAlphaComponent(0.2)
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint  = self.view.center
    transition.bubbleColor    = UIColor.clear
    return transition
  }

}
