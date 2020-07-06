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
  
  var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>?
  let dataArray: [Pokemon]?
  let cellReuseIdentifier: String?
  let collectionView: UICollectionView?
  let sections: [Section]?

  init(dataArray: [Pokemon], sections: [Section], collectionView: UICollectionView, cellReuseIdentifier: String) {
    self.dataArray = dataArray
    self.sections = sections
    self.collectionView = collectionView
    self.cellReuseIdentifier = cellReuseIdentifier
  }
  

  func configureCollectionViewDataSource() {
    
    guard let collectionView = collectionView, let cellReuseIdentifier = cellReuseIdentifier else {
        return
    }
    dataSource = UICollectionViewDiffableDataSource<Section, Pokemon>(collectionView: collectionView) {
      (collectionView, indexPath, pokemon) -> UICollectionViewCell? in
      
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier,
                                                          for: indexPath) as? PokemonCollectionViewCell {
        cell.imgView.image = UIImage(named: pokemon.image)
        cell.label.text = pokemon.name.capitalizingFirstLetter()
        return cell
      }
      
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier,
                                                          for: indexPath) as? PokemonLargeCollectionViewCell {
        cell.imgView.image = UIImage(named: pokemon.image)
        cell.nameLbl.text = pokemon.name.capitalizingFirstLetter()
        cell.expLbl.text = String(pokemon.baseExp)
        cell.heightLbl.text = String(pokemon.height)
        cell.weightLbl.text = String(pokemon.weight)
        return cell
      }
      return UICollectionViewCell()
    }
    configureSnapshot()
  }
 
  func configureSnapshot() {
    
    guard let dataArray = dataArray, let sections = sections, let dataSource = dataSource else { return }
    
    var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
    initialSnapshot.appendSections(sections)
    initialSnapshot.appendItems(dataArray, toSection: .main)
    dataSource.apply(initialSnapshot, animatingDifferences: false)

  }
  
}
  
