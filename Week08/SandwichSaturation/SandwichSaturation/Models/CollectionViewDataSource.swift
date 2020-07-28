/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CollectionViewDataSource: NSObject {
  
  // MARK: - Properties
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Sandwich>
  typealias DataSnapshot = NSDiffableDataSourceSnapshot<Section, Sandwich>
  
  let dataManager = DataManager.shared
  var layout = Layout.grid
  var dataSource: DataSource?
  var sandwiches = [Sandwich]()
  let collectionView: UICollectionView?
  let sections: [Section]?
  var sortIsAscending = true
  var isEditing = false
  
  // MARK: - Initializer
  
  init(sandwiches: [Sandwich],
       sections: [Section],
       collectionView: UICollectionView) {
    
    self.sandwiches = sandwiches
    self.sections = sections
    self.collectionView = collectionView
  }
  
  
  //MARK: - Configure Data Source
  
  func configureDataSource(forLayout layout: Layout) {
    
    guard let collectionView = collectionView else { return }
    
    self.layout = layout
    
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, sandwich) -> UICollectionViewCell? in
    
      switch self.layout {
        
        //Set up data for grid collection view cells
        case .grid:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SandwichCollectionCell.reuseIdentifier,
                                                        for: indexPath)  as! SandwichCollectionCell
          if !self.isEditing {
            cell.isSelected = false
          }
          cell.isEditing = self.isEditing
          cell.nameLabel.text = sandwich.name
          cell.thumbnail.image = UIImage(named: sandwich.imageName)
          switch sandwich.sauceAmount.sauceAmount {
            case .none:
              cell.sauceImgView.image = UIImage(named: "Dry")
            case .tooMuch:
              cell.sauceImgView.image = UIImage(named: "Saucy")
            default:
              break
          }
          return cell
        
        //Set up data for list collection view cells
        case .list:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SandwichListCell.reuseIdentifier,
                                                        for: indexPath)  as! SandwichListCell
          if !self.isEditing {
            cell.isSelected = false
          }
          cell.isEditing = self.isEditing
          cell.nameLabel.text = sandwich.name
          cell.thumbnail.image = UIImage(named: sandwich.imageName)
          cell.sauceLabel.text = sandwich.sauceAmount.sauceAmount.description
          return cell
      }
    }
    
  }
  
  // MARK: - Apply Data Snapshot
  
  func applySnapshot(animatingDifferences: Bool = true) {
    
    var snapshot = DataSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(sandwiches)
    dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
  }
    
  func refreshSnapshot(forLayout layout: Layout, animatingDifferences: Bool = true) {
    
    guard var snapshot = dataSource?.snapshot() else { return }
    self.layout = layout
    snapshot.reloadSections([.main])
    dataSource?.apply(snapshot, animatingDifferences: false)
  }

  // MARK: - Delete Sandiwches

  func deleteItems(at indexPaths: [IndexPath]) {
    
    guard let dataSource = dataSource else { return }
    
    //delete sandwich items from the database and the new snapshot
    //apply the updated snapshot

    let selectedItems = indexPaths.compactMap{ dataSource.itemIdentifier(for: $0) }
    var currentSnapshot = dataSource.snapshot()
    currentSnapshot.deleteItems(selectedItems)
    dataSource.apply(currentSnapshot, animatingDifferences: true)
    
    dataManager.deleteSandwiches(selectedItems)
  }
  
  // MARK: - Get Item Identifier for Sandiwch Model from Current Snapshot

  func itemIdentifer(for indexPath: IndexPath) -> Sandwich? {
    return dataSource?.itemIdentifier(for: indexPath)
  }

  // MARK: - Filter & Search Sandiwches

  func filterContentForSearchText(_ searchText: String,
                                  sauceAmount: SauceAmount? = nil) {
    
    //get filtered sandwiches from the database and apply the new snapshot

    sandwiches = dataManager.filterSandwichesForSearchText(searchText,
                                                           sauceAmount: sauceAmount,
                                                           sortIsAscending: sortIsAscending)
    applySnapshot()
  }

  // MARK: - Sort Sandiwches

  func sortSandwiches(sortIsAscending: Bool) {
    
    //get sorted sandwiches from the database and apply the new snapshot

    self.sortIsAscending = sortIsAscending
    sandwiches = dataManager.fetchSandwichModels(isAscending: sortIsAscending)
    applySnapshot()
  }

}

// MARK: - SandwichDataSource (Save & Edit Sandwich)

extension CollectionViewDataSource: SandwichDataSource {
  
  func saveSandwich(_ sandwichData: SandwichData) {
        
    //insert the new sandwich item in the database

    guard let newlyAddedSandwich = dataManager.saveSandwich(sandwichData),
      let dataSource = dataSource  else { return }
    
    //insert the new sandwich item in the snapshot
    
    var snapshot = dataSource.snapshot()    
    let names = snapshot.itemIdentifiers.map{ $0.name.lowercased() }
    var insertIndex = 0
    
    if sortIsAscending {
      insertIndex = names.insertionIndexAscending(of: newlyAddedSandwich.name.lowercased())
    }
    else {
      insertIndex = names.insertionIndexDescending(of: newlyAddedSandwich.name.lowercased())
    }
    
    if let beforeItem = dataSource.itemIdentifier(for: IndexPath(item: insertIndex, section: 0)) {
      snapshot.insertItems([newlyAddedSandwich], beforeItem: beforeItem)
    }
    else {
      snapshot.appendItems([newlyAddedSandwich])
    }
    
    //apply updated snasphot
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
    
  func editSandwich(_ sandwich: Sandwich, withName newName: String, sauceAmount: SauceAmount) {
    
    //edit and save sanwich in the database

    guard let editedSandwich = dataManager.editSandwich(sandwich, withSauce: sauceAmount),
    let dataSource = dataSource else {
      return
    }
    
    //reload the edited sanwich items in the snapshot
    
    var snapshot = dataSource.snapshot()
    snapshot.reloadItems([editedSandwich])
    
    //if the sandwich name has been changed then move the new sandwich in the correct sort order
    
    if sandwich.name != newName {
      sandwich.name = newName
      let tempIdentifiers = snapshot.itemIdentifiers.filter { $0 != editedSandwich }
      let names = tempIdentifiers.map { $0.name.lowercased() }
      var insertIndex = 0
      
      if sortIsAscending {
        insertIndex = names.insertionIndexAscending(of: editedSandwich.name.lowercased())
      }
      else {
        insertIndex = names.insertionIndexDescending(of: editedSandwich.name.lowercased())
      }
      
      if insertIndex < tempIdentifiers.count {
        let beforeItem = tempIdentifiers[insertIndex]
        snapshot.moveItem(editedSandwich, beforeItem: beforeItem)
      }
      else {
        let afterItem = tempIdentifiers[insertIndex-1]
        snapshot.moveItem(editedSandwich, afterItem: afterItem)
      }
    }
    
    //apply updated snasphot
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
}
