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

enum Section {
  case main
}

class PokedexLargeViewController: UIViewController {
    
  // MARK: - IBOutelts
  
    @IBOutlet private weak var collectionView: UICollectionView!
  
  // MARK: - Properties

    let pokemonArray = PokemonGenerator.shared.generatePokemons()
    var collectionViewDataSource: CollectionViewDataSource?
    var collectionViewLayoutModel: CollectionViewLayoutModel?
    let cellReuseIdentifer = PokemonLargeCollectionViewCell.reuseIdentifier

  // MARK: - View Life Cycle

    override func viewDidLoad() {
      super.viewDidLoad()
      setupCollectionView()
    }
    
  // MARK: - Setup Collection View

    func setupCollectionView() {
      
      //register collection view with custom cell nib
      self.collectionView.register(UINib(nibName: PokemonLargeCollectionViewCell.nib, bundle: nil),
                                   forCellWithReuseIdentifier: cellReuseIdentifer)

      //configure collection view layout
      let itemInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5)
      let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1.0))
      collectionViewLayoutModel = CollectionViewLayoutModel(numberOfItemsPerRow: 1.0,
                                                            itemInsets: itemInsets,
                                                            sectionInsets: sectionInsets,
                                                            groupSize: groupSize,
                                                            orthogonalScrollingBehavior: .groupPaging)
      collectionView.collectionViewLayout = collectionViewLayoutModel!.configureCompositionalLayout()
      
      //configure collection view datasource
      let testArray = Array(pokemonArray.prefix(through: 5))
      collectionViewDataSource = CollectionViewDataSource(dataArray: testArray, sections: [.main],
                                                collectionView: self.collectionView,
                                                cellReuseIdentifier: cellReuseIdentifer)
      collectionViewDataSource!.configureCollectionViewDataSource()

    }

    
}
