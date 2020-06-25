//
//  PostDraftViewController.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/24/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class PostDraftViewController: UIViewController {

  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var imgView: UIImageView!
  @IBOutlet private weak var postBtn: UIButton!

  var maxCharLimitForPost = 240
  var maxCharLimitForUsernameOrTitle = 25

  var selectedImage: UIImage!
  var imagePicker: ImagePicker!

  let accessory: UIView = {
      let accessoryView = UIView(frame: .zero)
      accessoryView.backgroundColor = .white
      return accessoryView
  }()
  
  let lineView: UIView = {
      let lineView = UIView(frame: .zero)
      lineView.backgroundColor = .lightGray
      lineView.alpha = 0.7
      return lineView
  }()

  let charactersLbl: UILabel = {
      let charactersLbl = UILabel(frame: .zero)
      charactersLbl.text = "240"
      charactersLbl.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
      return charactersLbl
  }()

  let pictureBtn: UIButton = {
      let pictureBtn = UIButton(type: .custom)
      pictureBtn.setImage(#imageLiteral(resourceName: "icons8-picture"), for: .normal)
      pictureBtn.addTarget(self, action:
      #selector(pictureBtnTapped), for: .touchUpInside)
      return pictureBtn
  }()

  let sendButton: UIButton! = {
      let sendButton = UIButton(type: .custom)
      sendButton.setImage(#imageLiteral(resourceName: "icons8-send"), for: .normal)
      sendButton.addTarget(self, action:
      #selector(sendButtonTapped), for: .touchUpInside)
      return sendButton
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    postBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    textField.becomeFirstResponder()
    addAccessory()
    textView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
    textView.layer.borderWidth = 1.0
    textView.layer.cornerRadius = 5
  }

  func addAccessory() {
      accessory.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 45)
    
      accessory.translatesAutoresizingMaskIntoConstraints = false
      lineView.translatesAutoresizingMaskIntoConstraints = false
      pictureBtn.translatesAutoresizingMaskIntoConstraints = false
      sendButton.translatesAutoresizingMaskIntoConstraints = false
      charactersLbl.translatesAutoresizingMaskIntoConstraints = false
      textView.inputAccessoryView = accessory
      accessory.addSubview(pictureBtn)
      accessory.addSubview(sendButton)
      accessory.addSubview(lineView)
      accessory.addSubview(charactersLbl)

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

  @objc func pictureBtnTapped(sender: UIButton) {
    
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    imagePicker.present(from: sender)
  }

  @objc func sendButtonTapped() {
    guard let textBody = textView.text, let titleText = textField.text else { return }
    self.addMediaPostWithDetails(userName: titleText, body: textBody)
  }
  
  func addMediaPostWithDetails(userName: String, body: String) {
    
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
  
  @IBAction func cancelBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension PostDraftViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    charactersLbl.text = "\(maxCharLimitForPost - textView.text.count)"
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
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

extension PostDraftViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    self.selectedImage = image
    imgView.image = image
  }

}

extension PostDraftViewController: UIScrollViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    textView.resignFirstResponder()
    textField.resignFirstResponder()
  }
  
}

extension PostDraftViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      return textField.text!.count + (string.count - range.length) <= maxCharLimitForUsernameOrTitle
  }
}
