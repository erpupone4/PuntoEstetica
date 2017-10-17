//
//  CategorieController.swift
//  PuntoEstetica
//
//  Created by Alessio Forte on 28/11/16.
//  Copyright © 2016 Alessio Forte. All rights reserved.
//

import UIKit
import Foundation
import OneSignal

class CategorieController: UITableViewController {
 
  @IBOutlet var laViso: UILabel!
  @IBOutlet var laCorpo: UILabel!
  @IBOutlet var laMani: UILabel!
  @IBOutlet var laEpilazione: UILabel!
  @IBOutlet var laDima: UILabel!
  @IBOutlet var laMassaggi: UILabel!
  @IBOutlet var laFisio: UILabel!
  @IBOutlet var laMedici: UILabel!
  
  var config : SwiftLoader.Config = SwiftLoader.Config()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //codice per far non far nascondere la table sotto la TabBar
    let tabBarHeight            = self.tabBarController?.tabBar.bounds.height
    self.edgesForExtendedLayout = UIRectEdge.all
    self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
    
    navigationController!.navigationBar.backgroundColor = UIColor(rgba: "#ecf0f1")
    navigationController!.navigationBar.barTintColor    = UIColor(rgba: "#2c3e50")
    navigationController!.navigationBar.tintColor       = UIColor.white
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "logo_top"))
    
    self.tableView.backgroundView = UIImageView(image:UIImage(named:"background"))
    
    DownloadManager.shared.MainController = self
    
    laViso.textColor       = UIColor(rgba: "#DBDEE2")
    laCorpo.textColor      = UIColor(rgba: "#DBDEE2")
    laMani.textColor       = UIColor(rgba: "#DBDEE2")
    laEpilazione.textColor = UIColor(rgba: "#DBDEE2")
    laDima.textColor       = UIColor(rgba: "#DBDEE2")
    laMassaggi.textColor   = UIColor(rgba: "#DBDEE2")
    laMedici.textColor     = UIColor(rgba: "#DBDEE2")
    laFisio.textColor      = UIColor(rgba: "#DBDEE2")
    
    configLoading()
    
    let refreshControl             = UIRefreshControl()
    refreshControl.backgroundColor = UIColor.clear
    refreshControl.tintColor = UIColor(rgba: "#DBDEE2")
    
//CODICE PER VISUALIZZARE LA XIB INVECE DEL TESTO STANDARD
//    var customRefreshView: UIView!
//    let refreshContents     = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
//    customRefreshView       = refreshContents![0] as? UIView
//
//    customRefreshView.frame = refreshControl.bounds
//    refreshControl.addSubview(customRefreshView!)

    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
  }
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if self.refreshControl?.isRefreshing == true {
      self.refreshControl?.endRefreshing()
      DispatchQueue.main.async {
        DownloadManager.shared.downloadJSON("http://www.puntoesteticamonteverde.it/DatiApp.json")
      }
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if DownloadManager.shared.localArra.count > 0 {
      return true
    } else {
      return false
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "detail" {
      let TratController = segue.destination as! TrattamentiController
    
      if let indexPath = tableView.indexPathForSelectedRow {
        
        // estraiamo la cella selezionata dalla table
        let cella = self.tableView.cellForRow(at: indexPath) as! CategoriaCell
        
        let list = DownloadManager.shared.localArra[(indexPath as NSIndexPath).row].lista
        
        let arrFiltered = list.filter {
          $0.cate == cella.laNome.text!
        }
        
        print(arrFiltered.count)
        
        TratController.Categoria  = cella.laNome.text
        TratController.TratList   = arrFiltered
        TratController.imgcate    = cella.imgCate.image
        
        self.tableView.deselectRow(at: indexPath, animated:true)
      }
    }
      
    if segue.identifier == "detailNoList" {
      
      let TratController = segue.destination as! TrattamentiNoListController
      
      if let indexPath = tableView.indexPathForSelectedRow {
        
        // estraiamo la cella selezionata dalla table
        let cella = self.tableView.cellForRow(at: indexPath) as! CategoriaCell
        
        let cateItem = DownloadManager.shared.localArra[(indexPath as NSIndexPath).row]
        
        TratController.cateItem = cateItem
        TratController.imgcate  = cella.imgCate.image
        
        self.tableView.deselectRow(at: indexPath, animated:true)
      }
    }
  }    
  
  //CONFIGURA LA VIEW CHE GIRA PER IL LOADING
  func configLoading() {
    config.size             = 140
    config.backgroundColor  = UIColor.darkGray
    config.spinnerColor     = UIColor.white
    config.titleTextColor   = UIColor.white
    config.spinnerLineWidth = 1.0
    config.foregroundColor  = UIColor.clear
    config.foregroundAlpha  = 0.5
    
    SwiftLoader.setConfig(config)
  }
  
  func reloadTable() {
    self.tableView.reloadData()

    SwiftLoader.hide()
    
    OneSignal.registerForPushNotifications()
  }
}
