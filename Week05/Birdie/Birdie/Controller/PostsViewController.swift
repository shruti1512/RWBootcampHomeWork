//
//  ViewController.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/23/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
  
  //MARK: - IBOutlets
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchBar: UISearchBar!

  //MARK: - Properties

    private lazy var addBtn: UIButton = {
        let addBtn = UIButton(frame: .zero)
        addBtn.setImage(#imageLiteral(resourceName: "icons8-add"), for: .normal)
        addBtn.addTarget(self, action: #selector(didPressAddButton), for: .touchUpInside)
        addBtn.showsTouchWhenHighlighted = true
        return addBtn
    }()

    private enum ActionSheetType: String {
      case sort = "Sort By"
      case filter = "Filter By"
    }
  
    private var mediaPosts = [MediaPost]() {
      didSet {
        guard let dataSource = dataSource else { return }
        dataSource.models = mediaPosts
        tableView.reloadData()
      }
    }
    private var dataSource: TableViewDataSource?
    private let mediaPostsHandler = MediaPostsHandler.shared
  
  //MARK: - View Life Cycle

    override func viewDidLoad() {
      super.viewDidLoad()
      setupView()
      setupData()
      searchBar.showsCancelButton = true
    }
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.mediaPosts = MediaPostsHandler.shared.mediaPosts
      addBtn.layoutIfNeeded()
    }
  
    override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: true)
      tableView.setEditing(editing, animated: true)
    }
  
  //MARK: - Set up View

    private func setupView() {
      navigationItem.leftBarButtonItem = editButtonItem
      tableView.allowsSelectionDuringEditing = true
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

  //MARK: - Set up Data

    private func setupData() {
      let dataSource = TableViewDataSource(models: mediaPosts)
      self.dataSource = dataSource
      self.tableView.dataSource = self.dataSource
    }
  
  //MARK: - IBActions

    @objc private func didPressAddButton() {
      performSegue(withIdentifier: "PostDraftScreen", sender: nil)
    }
  
    @IBAction func didPressSortBarButtonItem(_ sender: Any) {
      showActionSheetFor(.sort)
    }

    @IBAction func didPressFilterBarButtonItem(_ sender: Any) {
      showActionSheetFor(.filter)
    }

  //MARK: - Show Action Sheet for Sort & Filter

    private func showActionSheetFor(_ sheetType: ActionSheetType) {
      
      let alert = UIAlertController(title: nil, message: sheetType.rawValue, preferredStyle: .actionSheet)
      
      switch sheetType {
      case .sort:
        let sortCases = MediaPostsSortAttribute.allCases
        sortCases.forEach { (sortCase) in
          let action = UIAlertAction(title: sortCase.rawValue, style: .default) { [weak self] action in
            guard let self = self else { return }
            MediaPostsHandler.shared.sortPostsBy(sortCase)
            self.mediaPosts = MediaPostsHandler.shared.mediaPosts
          }
          alert.addAction(action)
        }
      case .filter:
        let filterCases = MediaPostsFilterAttribute.allCases
        filterCases.forEach { (filterCase) in
          let action = UIAlertAction(title: filterCase.rawValue, style: .default) { [weak self] action in
            guard let self = self else { return }
            self.mediaPosts = MediaPostsHandler.shared.filterPostsBy(filterCase)
          }
          alert.addAction(action)
        }
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UISearchBarDelegate

extension PostsViewController: UISearchBarDelegate {
  
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    editButtonItem.isEnabled = false
    searchBar.showsCancelButton = true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
    let searchResults = MediaPostsHandler.shared.searchMediaPostsBy(searchTerm)
    mediaPosts = searchResults
    self.tableView.reloadData()
    searchBar.resignFirstResponder()
    editButtonItem.isEnabled = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    editButtonItem.isEnabled = true
    searchBar.text = ""
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
    mediaPosts = MediaPostsHandler.shared.mediaPosts
  }
  
}
