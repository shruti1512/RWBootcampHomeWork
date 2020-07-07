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


class PokedexCompactViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var collectionView: CustomCollectionView!

  //MARK: - Properties

  var pokemonArray = PokemonGenerator.shared.generatePokemons() {
    didSet {
      dataSource?.models = pokemonArray
      collectionView?.reloadData()
    }
  }
  let cellReuseIdentifer = PokemonCollectionViewCell.reuseIdentifier
  let numberOfItemsInARow: CGFloat = 3
  let interItemSpacing: CGFloat = 10
  let sectionInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
  var dataSource: OldSchoolCollectionViewDataSource?
  var delegate: OldSchoolCollectionViewDelegate?


  //MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isEditing = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupCollectionViewForEditMode()
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
     let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
     layout?.invalidateLayout()
  }
    
  //MARK: - Set Up CollectionView

  private func setupView() {
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    
    //register collection view cell nib
    self.collectionView.register(UINib(nibName: PokemonCollectionViewCell.nib, bundle: nil),
                                 forCellWithReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier)
    
    //configure collection view data source
    let dataSource = OldSchoolCollectionViewDataSource(models: pokemonArray,
                                                       cellReuseIdentifier: cellReuseIdentifer,
                                                       collectionView: collectionView)
    self.dataSource = dataSource
    collectionView.dataSource = self.dataSource
    
    //configure collection view delegate
    let delegate = OldSchoolCollectionViewDelegate(numberOfItemsInARow: numberOfItemsInARow,
                                                   interItemSpacing: interItemSpacing,
                                                   sectionInsets: sectionInsets)
    self.delegate = delegate
    collectionView.delegate = self.delegate
    
    //allow multiple deletion
    collectionView.allowsMultipleSelection = true
  }
     
  func setupCollectionViewForEditMode() {
    //show hide delete icons in collection view based on editing state
    for cell in collectionView.visibleCells {
      guard let pokemonCell = cell as? PokemonCollectionViewCell else { return }
      pokemonCell.isEditing = isEditing
    }
  }
  
  @IBAction private func editButtonClicked( _ sender: UIButton) {
    isEditing = !isEditing
    isEditing ? collectionView.startWiggle() : collectionView.stopWiggle()
    isEditing ? sender.setTitle("Done", for: .normal) : sender.setTitle("Edit", for: .normal)
    collectionView.enableDragging(isEditing)
    setupCollectionViewForEditMode()
  }
  
  @IBAction private func filterButtonClicked( _ sender: UIButton) {
    
    let alert = UIAlertController(title: nil, message: "Sort By", preferredStyle: .actionSheet)
    
    let sortCases = PokemonSortCase.allCases
    sortCases.forEach { (sortCase) in
      let action = UIAlertAction(title: sortCase.rawValue.capitalizingFirstLetter(), style: .default) { action in
        guard let sortedArray = PokemonGenerator.shared.sortPokemansBy(sortCase: sortCase) else { return }
        self.pokemonArray = sortedArray
      }
      alert.addAction(action)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
  }

}
