//
//  DataManager.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/17/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation

class DataManager {
  
  static let shared = DataManager()
  private init() { }
  var sandwichSauceModels = [SandwichSauceAmount]()
  var sandwiches = [Sandwich]()

  private let coreDataMgr = CoreDataManager()

  func preloadDatabaseWithDefaultData() {
    
    let sandwichesData: [SandwichData] = JSONParser().loadDataFromJSONFile("sandwiches") ?? []
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
  
  func fetchSandwichSauceModels() -> [SandwichSauceAmount] {
    let sauceModels = coreDataMgr.fetch(SandwichSauceAmount.self) ?? []
    self.sandwichSauceModels = sauceModels
    return sauceModels
  }
  
  func fetchSandwichModels(isAscending: Bool = true) -> [Sandwich] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Sandwich.name),
                                          ascending: isAscending,
                                          selector: #selector(NSString.caseInsensitiveCompare))
    sandwiches = coreDataMgr.fetch(Sandwich.self, predicate: nil, sort: sortDescriptor) ?? []
    return sandwiches
  }
  
  func checkIfSandwichExists(_ sandwich: SandwichData) -> Bool {
    let filterdArray = sandwiches.filter { $0.name == sandwich.name && $0.sauceAmount.sauceAmount == sandwich.sauceAmount }
    let doesObjectAreadyExist = filterdArray.count > 0
    return doesObjectAreadyExist
  }
  
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

  func editSandwich(_ sandwich: Sandwich, withSauce sauceAmount: SauceAmount)  -> Sandwich? {
    if let sauceAmountModel = sandwichSauceModels.filter({  $0.sauceAmount == sauceAmount }).first {
      sandwich.sauceAmount = sauceAmountModel
      coreDataMgr.saveData()
      return sandwich
    }
    return nil
  }

  func filterSandwichesForSearchText(_ searchText: String,
                                     sauceAmount: SauceAmount? = nil) -> [Sandwich] {
    
    guard let sauceAmount = sauceAmount else { return [] }
    
    var filteredSandwiches = [Sandwich]()
    
    if sauceAmount == .any {
      let predicateSearchText = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
      if searchText.isEmpty {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self, predicate: nil, sort: nil) ?? []
      }
      else {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self, predicate: predicateSearchText, sort: nil) ?? []
      }
    }
    else {
      guard let sauceAmountModel = sandwichSauceModels.filter({ $0.amount == sauceAmount.rawValue }).first else {
        fatalError("Sauce amount model not found in DB")
      }
      let predicateSauceAmount = NSPredicate(format: "sauceAmount = %@", sauceAmountModel)
      
      if searchText.isEmpty {
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self, predicate: predicateSauceAmount, sort: nil) ?? []
      }
      else {
        let predicateSearchText = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSauceAmount, predicateSearchText])
        filteredSandwiches = coreDataMgr.fetch(Sandwich.self, predicate: compoundPredicate, sort: nil) ?? []
      }
    }
    return filteredSandwiches
  }

  func deleteSandwich(_ sandwich: Sandwich) {
    coreDataMgr.delete(sandwich)
    coreDataMgr.saveData()
  }
  
  func deleteSandwiches(_ sandwiches: [Sandwich]) {
    sandwiches.forEach {
      deleteSandwich($0)
    }
  }
  
  func getSandwich(before sandwich: Sandwich) -> Sandwich? {
    
    let sandwichAfter = sandwiches.last {
      $0.name.caseInsensitiveCompare(sandwich.name) == ComparisonResult.orderedAscending
    }
    return sandwichAfter
  }

  func getSandwich(after sandwich: Sandwich) -> Sandwich? {
    
    let sandwichesDescending = sandwiches.sorted { $0.name > $1.name }
    if let sandichAfter = sandwichesDescending.first(where: { $0.name < sandwich.name }) {
      return sandichAfter
    }
    else {
      let sandichAfter = sandwichesDescending.first
      return sandichAfter
    }
  }

}
