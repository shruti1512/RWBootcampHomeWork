//
//  ViewController.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/23/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!

    enum ActionSheetType: String {
      case sort = "Sort By"
      case filter = "Filter By"
    }
  
    var dataSource: TableViewDataSource!
    let mediaPostsHandler = MediaPostsHandler.shared
  
    override func viewDidLoad() {
      super.viewDidLoad()
      setUpTableView()
      addFloatingButton()
      searchBar.showsCancelButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.dataSource.models = MediaPostsHandler.shared.mediaPosts
      self.tableView.reloadData()
    }
  
    override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: true)
      tableView.setEditing(editing, animated: true)
    }
  
    func setUpTableView() {
      
      navigationItem.leftBarButtonItem = editButtonItem
      tableView.allowsSelectionDuringEditing = true

      //set up data source
      let dataSource = TableViewDataSource(models: MediaPostsHandler.shared.mediaPosts)
      self.dataSource = dataSource
      self.tableView.dataSource = self.dataSource
      self.tableView.reloadData()
    }
    
  func addFloatingButton() {
    let addBtn = UIButton()
    addBtn.setImage(#imageLiteral(resourceName: "icons8-add"), for: .normal)
    addBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
    addBtn.showsTouchWhenHighlighted = true
    addBtn.makeCircular()
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
  
    @objc func addBtnClicked() {
      performSegue(withIdentifier: "PostDraftScreen", sender: nil)
    }
  
    @IBAction func didPressSortBarButtonItem(_ sender: Any) {
      showActionSheetFor(.sort)
    }

    @IBAction func didPressFilterBarButtonItem(_ sender: Any) {
      showActionSheetFor(.filter)
    }

    func showActionSheetFor(_ sheetType: ActionSheetType) {
      
      let alert = UIAlertController(title: nil, message: sheetType.rawValue, preferredStyle: .actionSheet)
      
      switch sheetType {
      case .sort:
        let sortCases = MediaPostsSortAttribute.allCases
        sortCases.forEach { (sortCase) in
          let action = UIAlertAction(title: sortCase.rawValue, style: .default) { [weak self] action in
            guard let self = self else { return }
            MediaPostsHandler.shared.sortPostsBy(sortCase)
            self.dataSource.models = MediaPostsHandler.shared.mediaPosts
            self.tableView.reloadData()
          }
          alert.addAction(action)
        }
      case .filter:
        let filterCases = MediaPostsFilterAttribute.allCases
        filterCases.forEach { (filterCase) in
          let action = UIAlertAction(title: filterCase.rawValue, style: .default) { [weak self] action in
            guard let self = self else { return }
            self.dataSource.models = MediaPostsHandler.shared.filterPostsBy(filterCase)
            self.tableView.reloadData()
          }
          alert.addAction(action)
        }
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      present(alert, animated: true, completion: nil)
    }
    
}

extension PostsViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    editButtonItem.isEnabled = false
    searchBar.showsCancelButton = true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchTerm = searchBar.text else { return }
    let searchResults = MediaPostsHandler.shared.searchMediaPostsBy(searchTerm)
    self.dataSource.models = searchResults
    self.tableView.reloadData()
    searchBar.resignFirstResponder()
    editButtonItem.isEnabled = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    editButtonItem.isEnabled = true
    searchBar.text = ""
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
    self.dataSource.models = MediaPostsHandler.shared.mediaPosts
    self.tableView.reloadData()
  }

}
