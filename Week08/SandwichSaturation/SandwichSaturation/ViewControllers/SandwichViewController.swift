//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

//MARK: - SandwichDataSource Protocol

protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
  func editSandwich(_ sandwich: Sandwich,
                    withName newName: String,
                    sauceAmount: SauceAmount)
}

//MARK: - Enumerations

public enum Layout: CGFloat {
  case list = 1.0
  case grid = 3.0
}

public enum Section {
  case main
}

//MARK: - SandwichViewController class implementation

class SandwichViewController: UIViewController {
  
  //MARK: - IBOutlets
  
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      //register grid cell
      let nibGridCell = UINib(nibName: SandwichCollectionCell.nib, bundle: nil)
      collectionView.register(nibGridCell,
                              forCellWithReuseIdentifier: Constants.gridCellReuseIdentifier)
      
      //register list cell
      let nibListCell = UINib(nibName: SandwichListCell.nib, bundle: nil)
      collectionView.register(nibListCell,
                              forCellWithReuseIdentifier: Constants.listCellReuseIdentifier)
      
      //configure collection view layout
      collectionViewLayoutModel = CollectionViewLayoutModel()
      collectionView.collectionViewLayout = collectionViewLayoutModel!.configureLayout(for: .grid)
      
      //configure collectionview data source
      collectionViewDataSource = CollectionViewDataSource(sandwiches: sandwiches,
                                                          sections: [.main],
                                                          collectionView: self.collectionView)
      collectionViewDataSource!.configureDataSource(forLayout: .grid)
      
      //apply snapshot for collectionview data source
      collectionViewDataSource!.applySnapshot(animatingDifferences: false)
      
      //set collection view delegate
      collectionView.delegate = self
    }
  }
  @IBOutlet private var deleteBarBtn: UIBarButtonItem!
  @IBOutlet private var listGridBarBtn: UIBarButtonItem!
  @IBOutlet private var sortBarBtn: UIBarButtonItem!
  
  //MARK: - Properties
  
  private var selectedLayout = Layout.grid
  private var sortIsAscending = true
  private var sandwiches = [Sandwich]()
  private let userDefaults = UserDefaults.standard
  
  private var collectionViewDataSource: CollectionViewDataSource?
  private var collectionViewLayoutModel: CollectionViewLayoutModel?
  
  private let searchController = UISearchController(searchResultsController: nil)
  private lazy var addBtn: UIButton = {
    let addBtn = UIButton(frame: .zero)
    addBtn.setImage(#imageLiteral(resourceName: "icons8-add"), for: .normal)
    addBtn.addTarget(self, action: #selector(didPressAddButton), for: .touchUpInside)
    addBtn.showsTouchWhenHighlighted = true
    return addBtn
  }()
  
  private struct Constants {
    private init() { }
    static let userDefaultsKeyFilterIndex = "selectedFilterIndex"
    static let addSegueIdentifier = "AddSandwichSegue"
    static let editSegueIdentifier = "EditSandwichSegue"
    static let listCellReuseIdentifier = SandwichListCell.reuseIdentifier
    static let gridCellReuseIdentifier = SandwichCollectionCell.reuseIdentifier
    static let gridIcon = "square.grid.2x2"
    static let listIcon = "list.bullet"
    static let ascendingIcon = "icons8-ascending-sort"
    static let descendingIcon = "icons8-descending-sort"
    static let searchPlaceholder = "Filter Sandwiches"
  }

  //MARK: - View Lifecycle
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadSandwiches()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK: - Setup View
  
  private func setupView() {
    
    //Add Edit bar button item
    navigationItem.leftBarButtonItem = self.editButtonItem
    navigationItem.rightBarButtonItem = deleteBarBtn
    navigationItem.rightBarButtonItems = [listGridBarBtn, sortBarBtn]
    
    // Setup Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Constants.searchPlaceholder
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    self.navigationItem.searchController = searchController
    self.navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
    let selectedScoreIndex = userDefaults.integer(forKey: Constants.userDefaultsKeyFilterIndex)
    searchController.searchBar.selectedScopeButtonIndex = selectedScoreIndex
    searchController.searchBar.delegate = self
    
    //Add Floating + Button
    addFloatingButton()
  }
  
  private func addFloatingButton() {
    
    view.addSubview(addBtn)
    addBtn.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      addBtn.widthAnchor.constraint(equalToConstant: 80),
      addBtn.heightAnchor.constraint(equalTo: addBtn.widthAnchor),
      addBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
      addBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
    ])
  }
  
  private func updateAddBtnHiddenState(isHidden: Bool) {
    addBtn.isHidden = isHidden
  }
  
  //MARK: - Setup Data Models
  
  private func loadSandwiches() {
    let dataMgr = DataManager.shared
    sandwiches = dataMgr.fetchSandwichModels()
    let _ = dataMgr.fetchSandwichSauceModels()
  }
  
  //MARK: - Editing Mode
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    updateAddBtnHiddenState(isHidden: isEditing)
    
    if isEditing {
      navigationItem.rightBarButtonItems = nil
      navigationItem.rightBarButtonItem = deleteBarBtn
    }
    else {
      navigationItem.rightBarButtonItem = nil
      navigationItem.rightBarButtonItems = [listGridBarBtn, sortBarBtn]
    }
    
    //reload collection view to show/hide delete icons on cells
    collectionViewDataSource?.isEditing = isEditing
    collectionView.allowsMultipleSelection = true
    collectionView.reloadData()
  }
  
  
  //MARK: - Sort, Delete, Insert, Filter & Refresh Sandwiches
  
  @objc private func didPressAddButton(_ sender: Any) {
    performSegue(withIdentifier: Constants.addSegueIdentifier, sender: self)
  }
  
  @IBAction private func gridListBarButton(_ sender: Any) {
    
    guard let collectionViewLayoutModel = collectionViewLayoutModel else { return }
    
    let currentLayout = selectedLayout
    
    //change bar button item image based on user selection
    let gridBtn = sender as! UIBarButtonItem
    gridBtn.image = currentLayout == .grid ?
      UIImage(systemName: Constants.gridIcon) : UIImage(systemName: Constants.listIcon)
    
    //refresh current selected layout
    selectedLayout = currentLayout == .grid ? .list : .grid
    
    //invalidate previous layout and reconfigure new layout based on the
    //and reapply current data snapshot to the data source
    let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    layout?.invalidateLayout()
    collectionView.collectionViewLayout = collectionViewLayoutModel.configureLayout(for: selectedLayout)
    collectionViewDataSource?.refreshSnapshot(forLayout: selectedLayout)
    collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
  }
  
  @IBAction private func sortBarButton(_ sender: Any) {
    
    sortIsAscending.toggle()
    
    //update the sort bar button item image based on user selection
    let sortBtn = sender as! UIBarButtonItem
    sortBtn.image = sortIsAscending ? UIImage(named: Constants.descendingIcon) :
      UIImage(named: Constants.ascendingIcon)
    
    //sort sandwiches in the data source
    collectionViewDataSource?.sortSandwiches(sortIsAscending: sortIsAscending)
  }
  
  @IBAction private func deleteSelectedItems() {
    
    //delete selcted cells from the data source
    guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
    collectionViewDataSource?.deleteItems(at: selectedIndexPaths)
    
    //update isEditing and refresh add bar button item state
    isEditing.toggle()
    updateAddBtnHiddenState(isHidden: isEditing)
    collectionViewDataSource?.isEditing = isEditing
    
    //reload collection view to show/hide delete icons on cells
    collectionView.reloadData()
  }
  
  // MARK: - Search Controller
  
  private var isFiltering: Bool {
    let searchBarScopeIsFiltering =
      searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive &&
      (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  private var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  //MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? AddSandwichViewController else {
      return
    }
    destinationVC.dataSource = collectionViewDataSource
    
    switch segue.identifier {
    case Constants.editSegueIdentifier:
      if let cell = sender as? EditableCell, let indexPath = collectionView.indexPath(for: cell) {
        guard let sandwich = collectionViewDataSource?.itemIdentifer(for: indexPath) else { return }
        destinationVC.sandwich = sandwich
      }
    default:
      break
    }
  }
}

// MARK: - UISearchResultsUpdating

extension SandwichViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    if !searchController.isActive {
      print("Cancelled")
      collectionViewDataSource?.filterContentForSearchText("", sauceAmount: nil)
      updateAddBtnHiddenState(isHidden: false)
    }
    else {
      updateAddBtnHiddenState(isHidden: true)
      let searchBar = searchController.searchBar
      guard let searchText = searchBar.text else { return }
      
      let sauceRawValue = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
      let sauceAmount = SauceAmount(rawValue: sauceRawValue)
      
      collectionViewDataSource?.filterContentForSearchText(searchText, sauceAmount: sauceAmount)
    }
  }
}

// MARK: - UISearchBarDelegate

extension SandwichViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    updateAddBtnHiddenState(isHidden: true)
    
    userDefaults.set(selectedScope, forKey: Constants.userDefaultsKeyFilterIndex)
    
    let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
    collectionViewDataSource?.filterContentForSearchText(searchBar.text!,
                                                         sauceAmount: sauceAmount)

  }
}

// MARK: - UICollectionViewDelegate

extension SandwichViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if isEditing || isFiltering {
      return
    }
    
    let cell = collectionView.cellForItem(at: indexPath)
    DispatchQueue.main.async { [weak self] in
      self?.performSegue(withIdentifier: Constants.editSegueIdentifier, sender: cell)
    }
  }
}
