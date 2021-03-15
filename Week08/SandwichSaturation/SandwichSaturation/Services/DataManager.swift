//
//  DataManager.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/17/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation

class DataManager {
  
  //MARK: - Properties
  
//  static let shared = DataManager()
  var sandwichSauceModels = [SandwichSauceAmount]()
  var sandwiches = [Sandwich]()
  private let coreDataMgr = CoreDataManager()

  //MARK: - Object Lifecycle

  init() { }

  //MARK: - Preload Data From JSON Into Database

  func preloadDatabaseWithDefaultData() {
    
    let sandwichesData: [SandwichData] = JSONParser.loadDataFromJSONFile("sandwiches") ?? []
    let coreDataMngr = CoreDataManager()
    
    //save default sauce amount data into database
    let sauceAmounts = sandwichesData.map{ $0.sauceAmount.rawValue }.unique()
    sauceAmounts.forEach {
      let sauceAmountModel = coreDataMngr.addManagedObject(SandwichSauceAmount.self)
      sauceAmountModel?.id = UUID()
      sauceAmountModel?.amount = $0
    }
    coreDataMngr.saveData()
    
    //fetch saved sauce amount models from database
    let sauceAmountModels = coreDataMngr.fetch(SandwichSauceAmount.self)
      
    //save default sandwich data into database
    sandwichesData.forEach {
      let sandwich = coreDataMngr.addManagedObject(Sandwich.self)
      sandwich?.id = UUID()
      sandwich?.name = $0.name
      sandwich?.imageName = $0.imageName
      let sauce = $0.sauceAmount
      //fetch the saved sauce amount model from db with the same sauce amount as the sandiwch data sauce
      if let savedSauceAmountModel = sauceAmountModels?.filter({ $0.sauceAmount ==  sauce}).first {
        sandwich?.sauceAmount = savedSauceAmountModel
      }
    }
    coreDataMngr.saveData()
  }
  
  //MARK: - Fetch Sandwich Sauce Models From Database

  func fetchSandwichSauceModels() -> [SandwichSauceAmount] {
    
    let sauceModels = coreDataMgr.fetch(SandwichSauceAmount.self) ?? []
    self.sandwichSauceModels = sauceModels
    return sauceModels
  }
  
  //MARK: - Fetch Sandwich Models From Database

  func fetchSandwichModels(isAscending: Bool = true) -> [Sandwich] {
    
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Sandwich.name),
                                          ascending: isAscending,
                                          selector: #selector(NSString.caseInsensitiveCompare))
    sandwiches = coreDataMgr.fetch(Sandwich.self, predicate: nil, sort: sortDescriptor) ?? []
    return sandwiches
  }
  
  //MARK: - Check for Sandwich Model In Database

  func checkIfSandwichExists(_ sandwich: SandwichData) -> Bool {
    
    let filterdArray = sandwiches.filter { $0.name == sandwich.name && $0.sauceAmount.sauceAmount == sandwich.sauceAmount }
    let doesObjectAreadyExist = filterdArray.count > 0
    return doesObjectAreadyExist
  }
  
  //MARK: - Save Sandwich Model In Database

  func saveSandwich(_ sandwichData: SandwichData) -> Sandwich? {
    
    let sandwich = coreDataMgr.addManagedObject(Sandwich.self)
    sandwich?.id = UUID()
    sandwich?.name = sandwichData.name
    sandwich?.imageName = sandwichData.imageName
    
    //fetch the saved sauce amount model from db with the same sauce amount as the sandiwch data sauce
    if let savedSauceAmountModel = sandwichSauceModels.filter({ $0.sauceAmount ==  sandwichData.sauceAmount}).first {
      sandwich?.sauceAmount = savedSauceAmountModel
    }
    coreDataMgr.saveData()
    return sandwich
  }

  //MARK: - Edit Sandwich Model and Update Database

  func editSandwich(_ sandwich: Sandwich, withSauce sauceAmount: SauceAmount)  -> Sandwich? {
    
    if let sauceAmountModel = sandwichSauceModels.filter({  $0.sauceAmount == sauceAmount }).first {
      sandwich.sauceAmount = sauceAmountModel
      coreDataMgr.saveData()
      return sandwich
    }
    return nil
  }

  //MARK: - Filter Sandwich Models Based on Search Term and Sauce In Database

  func filterSandwichesForSearchText(_ searchText: String,
                                     sauceAmount: SauceAmount? = nil,
                                     sortIsAscending: Bool) -> [Sandwich] {
    
    var filteredSandwiches = [Sandwich]()

    let sortDescriptor = NSSortDescriptor(key: #keyPath(Sandwich.name),
                                          ascending: sortIsAscending,
                                          selector: #selector(NSString.caseInsensitiveCompare))

    guard let sauceAmount = sauceAmount else {
      filteredSandwiches = coreDataMgr.fetch(Sandwich.self,
                                             predicate: nil,
                                             sort: sortDescriptor) ?? []

      return  filteredSandwiches
    }
            
    if sauceAmount == .any {
      let predicateSearchText = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
      if searchText.isEmpty {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self,
                                               predicate: nil,
                                               sort: sortDescriptor) ?? []
      }
      else {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self,
                                               predicate: predicateSearchText,
                                               sort: sortDescriptor) ?? []
      }
    }
    else {
      guard let sauceAmountModel = sandwichSauceModels.filter({ $0.amount == sauceAmount.rawValue }).first else {
        fatalError("Sauce amount model not found in DB")
      }
      let predicateSauceAmount = NSPredicate(format: "sauceAmount = %@", sauceAmountModel)
      
      if searchText.isEmpty {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self,
                                               predicate: predicateSauceAmount,
                                               sort: sortDescriptor) ?? []
      }
      else {
        let predicateSearchText = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSauceAmount, predicateSearchText])
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self,
                                               predicate: compoundPredicate,
                                               sort: sortDescriptor) ?? []
      }
    }
    return filteredSandwiches
  }

  //MARK: - Delete Sandwich Model from Database

  func deleteSandwich(_ sandwich: Sandwich) {
    
    coreDataMgr.delete(sandwich)
    coreDataMgr.saveData()
  }
  
  //MARK: - Delete Multiple Sandwich Models from Database

  func deleteSandwiches(_ sandwiches: [Sandwich]) {
    
    sandwiches.forEach {
      deleteSandwich($0)
    }
  }

}
