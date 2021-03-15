//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  //MARK: - Instance Properties
  
  private let cellReuseIdentifier = ClueTableViewCell.reuseIdentifier
  private let jeopardyImageUrl = "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg"
  private let audioPlayerOffImage = "icons8-no-audio"
  private let audioPlayerOnImage = "icons8-audio"
  private let animationDuration = 0.8
  private let animationDelay = 1.5
  
  private let soundManager = SoundManager.shared
  private var game = GameModel()
  private var soundPreferences: Bool? {
    didSet {
      if soundPreferences == false {
        soundButton.setImage(UIImage(named: audioPlayerOffImage), for: .normal)
        soundManager.stopThemeSound()
      } else {
        soundButton.setImage(UIImage(named: audioPlayerOnImage), for: .normal)
        soundManager.playThemeSound()
      }
    }
  }
  
  //MARK: - IBOutlets
  
  @IBOutlet private weak var soundButton: UIButton!
  @IBOutlet private weak var categoryLabel: UILabel!
  @IBOutlet private weak var clueLabel: UILabel!
  @IBOutlet private weak var scoreLabel: UILabel!
  
  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      let nib = UINib(nibName: ClueTableViewCell.nib, bundle: nil)
      tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }
  }
  
  @IBOutlet private weak var logoImageView: UIImageView! {
    didSet {
      logoImageView.loadImage(fromURL: jeopardyImageUrl)
    }
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setupViewsForNetworking(isHidden: true)
    loadThemeSound()
    loadData()
  }
  
  //MARK: - Load Data and Update View
  
  private func loadThemeSound() {
    
    soundPreferences = soundManager.isSoundEnabled
  }
  
  private func loadData() {
    
    game.fetchCategory() { [weak self] in
      guard let self = self else { return }
      self.setupViewsForNetworking(isHidden: false)
      self.updateViewForData()
    }
  }
  
  private func loadDataForNextQuestion() {
    
    game.fetchCategory() { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDelay) {
        self.updateViewForData()
      }
    }
  }
  
  private func updateViewForData() {
        
    UIView.transition(with: self.view, duration: animationDuration,
                      options: .transitionCrossDissolve,
                      animations: { [weak self] in
      guard let self = self else { return }
                        
      self.view.isUserInteractionEnabled = true
      self.tableView.reloadData()
      self.categoryLabel.text = self.game.category?.title.uppercased()
      self.clueLabel.text = self.game.correctAnswerClue?.question.capitalizingFirstLetter()
      
    }, completion: nil)
  }
  
  //MARK: - Setup View
  
  private func setupViewsForNetworking(isHidden: Bool) {
    
    categoryLabel.isHidden = isHidden
    clueLabel.isHidden = isHidden
    scoreLabel.isHidden = isHidden
    tableView.isHidden = isHidden
  }
  
  //MARK: - Animate Score & Correct Answer

  private func highlightCorrectAnswer() {
    
    for (index, cell) in tableView.visibleCells.enumerated() {
      
      guard let clueCell = cell as? ClueTableViewCell else { return }
      guard index == game.correctAnsClueIndex else { continue }
      clueCell.animateForCorrectAnswer()
      break
    }
  }
  
  func animateScoreLabel() {
    
    UIView.animate(withDuration: 1.0, animations: {
      self.scoreLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
    }) { _ in
      UIView.animate(withDuration: 1.0) {
         self.scoreLabel.transform = .identity
      }
    }
  }
  
  //MARK: - IBAction
  
  @IBAction private func didPressVolumeButton(_ sender: Any) {
    
    soundManager.toggleThemeSoundPreference()
    soundPreferences = soundManager.isSoundEnabled
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return game.clues.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                   for: indexPath) as? ClueTableViewCell else {
                                                    fatalError("Cell could not be dequeued")
    }
    cell.delegate = self
    cell.refresh()
    let clue = game.clues[indexPath.row]
    let trimmedAnswer = clue.answer.removeSpecialCharacters().capitalizingFirstLetter()
    cell.clueTitleButton.setTitle(trimmedAnswer, for: .normal)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = tableView.cellForRow(at: indexPath) as? ClueTableViewCell else {
      return
    }
    clueButtonTapped(cell)
  }
  
}

//MARK: - ClueTableViewCellDelegate

extension ViewController: ClueTableViewCellDelegate {
  
  func clueButtonTapped(_ cell: ClueTableViewCell) {
    
    guard let indexPath = tableView.indexPath(for: cell)  else { return }
    var selectedClue: Clue?
    
    if indexPath.row < game.clues.count {
      selectedClue = game.clues[indexPath.row]
    }
    
    loadDataForNextQuestion()
    
    guard let clue = selectedClue else { return }
    
    game.calculateScore(forClue: clue) { [weak self] in
      
      guard let self = self else { return }
      self.view.isUserInteractionEnabled = false
      $0 == true ? soundManager.playCorrectAnswerAudio() : soundManager.playIncorrectAnswerAudio()
      $0 == false ? cell.updateForWrongAnswer() : ()
      self.highlightCorrectAnswer()
      let previousScore = Int(scoreLabel.text!)
      self.scoreLabel.text = String(game.score)
      previousScore != game.score ? self.animateScoreLabel() : ()
    }
  }
  
  
}
