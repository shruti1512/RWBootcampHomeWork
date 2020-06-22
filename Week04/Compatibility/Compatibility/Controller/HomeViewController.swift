//
//  HomeViewController.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  //MARK: - IBOutlets
   @IBOutlet private weak var collectionView: UICollectionView!
  
  //MARK: - Properties
   private var avatars = [String]()
   private var person1Image, person2Image: String!
   private var dataSource: CollectionViewDataSource!
   private var delegate: CollectionViewDelegate!
   private let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

  //MARK: - View Controller LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      collectionView.reloadData()
      delegate.refresh()
    }
  
  //MARK: - Update Collection View on View Transition Changes
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)

      guard let collectionView = self.collectionView else {
        return
      }
      collectionView.collectionViewLayout.invalidateLayout()
      collectionView.reloadData()
  }


  //MARK: - Initial Setup Methods

    private func setupCollectionView() {
      setupCollectionViewLayout()
      setupCollectionViewDataSource()
      setupCollectionViewDelegate()
    }
  
    func setupCollectionViewLayout() {
      let layout = UICollectionViewFlowLayout()
      layout.sectionInset = sectionInsets
      layout.minimumLineSpacing = sectionInsets.left
      layout.minimumInteritemSpacing = sectionInsets.left
      collectionView.collectionViewLayout = layout
    }

    func setupCollectionViewDataSource() {
      
      var maleAvatars = [String]()
      for i in 1...8 {
        let imageName = "male_00\(i)"
        maleAvatars.append(imageName)
      }
      var femaleAvatars = [String]()
      for i in 1...8 {
        let imageName = "female_00\(i)"
        femaleAvatars.append(imageName)
      }
      avatars += maleAvatars + femaleAvatars
      let dataSource = CollectionViewDataSource(models: avatars, reuseIdentifier: "AvatarCollectionViewCell")
      self.dataSource = dataSource
      collectionView.dataSource = self.dataSource
    }
   
    func setupCollectionViewDelegate() {
      
      let delegate = CollectionViewDelegate(dataSourceArray: avatars, sectionInsets: sectionInsets, itemsPerRow: 4) {
                      (person1Image, person2Image) in
                              self.person1Image = person1Image
                              self.person2Image = person2Image
                              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                                self?.performSegue(withIdentifier: "GameVC", sender: nil)
                              }
                     }
      self.delegate = delegate
      collectionView.delegate = self.delegate
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destinationVC = segue.destination as? GameViewController {
        destinationVC.person1Image = person1Image
        destinationVC.person2Image = person2Image
      }
    }

}
