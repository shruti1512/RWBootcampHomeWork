//
//  PostDraftViewController.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/24/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class PostDraftViewController: UIViewController {

  //MARK: - IBOutlets
  
  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var imgView: UIImageView!
  @IBOutlet private weak var postBtn: UIButton!

  //MARK: - Properties

  private var maxCharLimitForPost = 240
  private var maxCharLimitForUsernameOrTitle = 25
  private var selectedImage: UIImage!
  private var imagePicker: ImagePicker!

  private lazy var accessory: UIView = {
      let accessoryView = UIView(frame: .zero)
      accessoryView.backgroundColor = .white
      return accessoryView
  }()
  
  private lazy var lineView: UIView = {
      let lineView = UIView(frame: .zero)
      lineView.backgroundColor = .lightGray
      lineView.alpha = 0.7
      return lineView
  }()

  private lazy var charactersLbl: UILabel = {
      let charactersLbl = UILabel(frame: .zero)
      charactersLbl.text = "240"
      charactersLbl.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
      return charactersLbl
  }()

  private lazy var pictureBtn: UIButton = {
      let pictureBtn = UIButton(type: .custom)
      pictureBtn.setImage(#imageLiteral(resourceName: "icons8-picture"), for: .normal)
      pictureBtn.addTarget(self, action:
      #selector(pictureBtnTapped), for: .touchUpInside)
      return pictureBtn
  }()

  private lazy var sendButton: UIButton! = {
      let sendButton = UIButton(type: .custom)
      sendButton.setImage(#imageLiteral(resourceName: "icons8-send"), for: .normal)
      sendButton.addTarget(self, action:
      #selector(sendButtonTapped), for: .touchUpInside)
      return sendButton
  }()

  //MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK: - View Setup

  private func setupView() {
    textField.becomeFirstResponder()
    addAccessory()
    textView.roundWithCornerRadius(5.0, borderWidth: 1.0,
                                   borderColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0))
    postBtn.isEnabled = false
    sendButton.isEnabled = false
  }

  private func addAccessory() {
      accessory.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 45)
    
      accessory.translatesAutoresizingMaskIntoConstraints = false
      lineView.translatesAutoresizingMaskIntoConstraints = false
      pictureBtn.translatesAutoresizingMaskIntoConstraints = false
      sendButton.translatesAutoresizingMaskIntoConstraints = false
      charactersLbl.translatesAutoresizingMaskIntoConstraints = false
    
      accessory.addSubview(pictureBtn)
      accessory.addSubview(sendButton)
      accessory.addSubview(lineView)
      accessory.addSubview(charactersLbl)
    
      textView.inputAccessoryView = accessory
      textField.inputAccessoryView = accessory
    
      addConstraintsToAccessoryView()
  }

  private func addConstraintsToAccessoryView() {
    
    NSLayoutConstraint.activate([
      lineView.leadingAnchor.constraint(equalTo: accessory.leadingAnchor),
      lineView.trailingAnchor.constraint(equalTo: accessory.trailingAnchor),
      lineView.topAnchor.constraint(equalTo: accessory.topAnchor),
      lineView.heightAnchor.constraint(equalToConstant: 1),
      charactersLbl.centerYAnchor.constraint(equalTo: accessory.centerYAnchor),
      charactersLbl.centerXAnchor.constraint(equalTo: accessory.centerXAnchor),
      pictureBtn.leadingAnchor.constraint(equalTo:
      accessory.leadingAnchor, constant: 20),
      pictureBtn.centerYAnchor.constraint(equalTo:
      accessory.centerYAnchor),
      sendButton.trailingAnchor.constraint(equalTo:
      accessory.trailingAnchor, constant: -20),
      sendButton.centerYAnchor.constraint(equalTo:
      accessory.centerYAnchor)
    ])
  }
  
  //MARK: - Add Media Post
  private func addMediaPostWithDetails(userName: String, body: String) {
    
    var mediaPost: MediaPost
    if let selectedImage = self.selectedImage {
      mediaPost = ImagePost(textBody: body, userName: userName, timestamp: Date(), image: selectedImage)
      self.selectedImage = nil
    }
    else {
      mediaPost = TextPost(textBody: body, userName: userName, timestamp: Date())
    }
    MediaPostsHandler.shared.addMediaPost(mediaPost: mediaPost)
    dismiss(animated: true, completion: nil)
  }

  //MARK: - IBActions

  @objc private func pictureBtnTapped(sender: UIButton) {
    
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    imagePicker.present(from: sender)
  }

  @IBAction func sendButtonTapped(_ sender: Any) {
    guard let textBody = textView.text, let titleText = textField.text else { return }
    self.addMediaPostWithDetails(userName: titleText, body: textBody)
  }
    
  @IBAction func cancelBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    let charsTyped = (maxCharLimitForUsernameOrTitle - sender.text!.count)
    postBtn.isEnabled = !(charsTyped == maxCharLimitForUsernameOrTitle)
    sendButton.isEnabled = !(charsTyped == maxCharLimitForUsernameOrTitle)
    charactersLbl.text = String(charsTyped)
  }
  
}

// MARK:- UITextViewDelegate

extension PostDraftViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    let charsTyped = (maxCharLimitForPost - textView.text.count)
    postBtn.isEnabled = !(charsTyped == maxCharLimitForPost)
    sendButton.isEnabled = !(charsTyped == maxCharLimitForPost)
    charactersLbl.text = String(charsTyped)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    charactersLbl.text = String(maxCharLimitForPost)
    if textView.textColor == .lightGray {
       textView.text = ""
       textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
       textView.text = "Body"
       textView.textColor = UIColor.lightGray
    }
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return textView.text.count + (text.count - range.length) <= maxCharLimitForPost
  }


}

// MARK:- ImagePickerDelegate

extension PostDraftViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    self.selectedImage = image
    imgView.image = image
  }

}

// MARK:- UIScrollViewDelegate

extension PostDraftViewController: UIScrollViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    textView.resignFirstResponder()
    textField.resignFirstResponder()
  }
  
}

// MARK:- UITextFieldDelegate

extension PostDraftViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    charactersLbl.text = String(maxCharLimitForUsernameOrTitle)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      return textField.text!.count + (string.count - range.length) <= maxCharLimitForUsernameOrTitle
  }
}
  
