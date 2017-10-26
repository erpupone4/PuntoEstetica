//
//  DownloadManager.swift
//  WPNewsReader
//
//  Created by Marcello Catelli on 12/08/16.
//  Copyright (c) 2016 Objective C srl. All rights reserved.
//

import UIKit

class DownloadManager: NSObject , GraphDelegate {
  
  static let shared = DownloadManager()
  
  var MainController: CategorieController!
  var localArra     : [CategoriaModel]   = []
  var isStartup     : Bool               = false
  var graph         : Graph              = Graph()
  var PrefArra      : [Entity]           = []
  var FavoArra      : [TrattamentoModel] = []
  
  func startGraph () {
    graph.delegate = self
    
    graph.watchForEntity(types: ["Preferito"])
    
    PrefArra  = graph.searchForEntity(types: ["Preferito"])
    FavoArra  = fromEntityToModel()
  }
  
  func addPreferito (trat: TrattamentoModel) {
    graph.delegate = self
    
    let fav: Entity = Entity(type: "Preferito")
    fav["cate"]    = trat.cate
    fav["nome"]    = trat.nome
    fav["costo"]   = trat.costo
    fav["min"]     = trat.min
    fav["des"]     = trat.des
    fav["img"]     = trat.img
    fav["new"]     = trat.new
    PrefArra.append(fav)
    FavoArra.append(trat)
    
    graph.async()
  }
  
  func delPreferito (index: Int) {
    graph.delegate = self
    
    PrefArra[index].delete()
    PrefArra.remove(at: index)
    FavoArra.remove(at: index)
    
    graph.async()
  }
  
  func fromEntityToModel () ->[TrattamentoModel]  {    
    var list : [TrattamentoModel] = []
    
    for item in PrefArra {
      let trat = TrattamentoModel ()
      
      trat.cate  = item["cate"]   as! String
      trat.nome  = item["nome"]   as! String
      trat.costo = item["costo"]  as! String
      trat.min   = item["min"]    as! String
      trat.des   = item["des"]    as! String
      trat.img   = item["img"]    as! String
      trat.new   = item["new"]    as! String
      list.append(trat)
    }
    
    return list
  }
  
  func downloadJSON(_ url : String) {
    
    startGraph();
    
    SwiftLoader.show("Aggiornamento...", animated: true)
        
    _ = request(url, method: .get).responseJSON { response in
      
      // come leggere i dati del response
//      print(response.request!)  // original URL request
//      print(response.response!) // URL response
//      print(response.data!)     // server data
//      print(response.result)    // result of response serialization
      
      // controlliamo se c'è un errore e nel caso lo stampiamo in console
      if let er = response.result.error {
        print(er.localizedDescription)
      }
      
      if let _ = response.result.value {
        print("JSON OK")
      } else {
        print("JSON Nil")
        return
      }
      
      let json =  JSON(response.result.value!)
      
      for i in 0..<json.count {
        
        let cate = CategoriaModel()
      
        
        if let cateName = json[i]["nome"].string {
          cate.nome = cateName
        }
        
        if let cateImg = json[i]["immagine"].string {
          cate.img = cateImg
        }
        
        if let cateDes = json[i]["des"].string {
          cate.des = cateDes
        }

        if let cateTrattamenti = json[i]["trattamenti"].arrayObject {
          let jsonTrat = JSON(cateTrattamenti)

          for x in 0..<jsonTrat.count {
            let trat = TrattamentoModel()
            
            trat.nome  = jsonTrat[x]["nome"].string!
            trat.costo = jsonTrat[x]["costo"].string!
            trat.des   = jsonTrat[x]["descrizione"].string!
            trat.min   = jsonTrat[x]["minuti"].string!
            trat.img   = jsonTrat[x]["img"].string!
            trat.new   = jsonTrat[x]["new"].string!
            trat.cate  = cate.nome
            
            cate.lista.append(trat)
          }
        }
        
        self.localArra.append(cate)
      }
      
      self.MainController.reloadTable()
    }
  }
}
