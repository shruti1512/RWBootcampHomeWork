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

class OldSchoolCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  //MARK:- Properties

  var models: [Pokemon]
  let cellReuseIdentifier: String
  let collectionView: CustomCollectionView
  
  //MARK:- Intializer

  init(models: [Pokemon], cellReuseIdentifier: String, collectionView: CustomCollectionView) {
    self.models = models
    self.cellReuseIdentifier = cellReuseIdentifier
    self.collectionView = collectionView
  }
   
  //MARK:- UICollectionViewDataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier,
                                                        for: indexPath) as? PokemonCollectionViewCell else {
      fatalError("Could not dequeue cell")
    }
    
    cell.delegate = self
    let pokemon = models[indexPath.row]
    cell.imgView.image = UIImage(named: pokemon.image)
    cell.label.text = pokemon.name.capitalizingFirstLetter()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
      return true
  }

  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let temp = models.remove(at: sourceIndexPath.item)
      models.insert(temp, at: destinationIndexPath.item)
  }
  
}

//MARK: - PokemonCollectionViewCellDelegate

extension OldSchoolCollectionViewDataSource: PokemonCollectionViewCellDelegate {
  
  func deleteCollectionViewCell(_ cell: PokemonCollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    models.remove(at: indexPath.row)
    collectionView.deleteItems(at: [indexPath])
  }
  
}
