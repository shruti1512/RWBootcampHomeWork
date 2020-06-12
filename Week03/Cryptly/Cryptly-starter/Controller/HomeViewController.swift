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

class HomeViewController: UIViewController{

  //MARK:- IBOutlets
  
  @IBOutlet weak var view1: CryptoCurrencyView!
  @IBOutlet weak var view2: UIView!
  @IBOutlet weak var view3: UIView!
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var view1TextLabel: UILabel!
  @IBOutlet weak var view2TextLabel: UILabel!
  @IBOutlet weak var view3TextLabel: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  @IBOutlet weak var mostFallingView: UIView!
  @IBOutlet weak var mostRisingView: UIView!
  @IBOutlet weak var mostRisingLabel: UILabel!
  @IBOutlet weak var mostFallingLabel: UILabel!
  @IBOutlet weak var mostFallingDataTextLabel: UILabel!
  @IBOutlet weak var mostRisingDataTextLabel: UILabel!
  @IBOutlet weak var tapGestureAllCurrencies: UITapGestureRecognizer!
  @IBOutlet weak var tapGestureRisingCurrencies: UITapGestureRecognizer!
  @IBOutlet weak var tapGestureFallingCurrencies: UITapGestureRecognizer!

  //MARK: - Properties
  let cryptoData = DataGenerator.shared.generateData()
  
  //MARK:- View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLabels()
    
    guard let _ = cryptoData else {
      return
    }
    switchPressed(themeSwitch!)
    setView1Data()
    setView2Data()
    setView3Data()
    setMostFallingMostRisingData()
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
  }

  //MARK:- View Setup
  
  func setupLabels() {
    headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    view1TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    view2TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
  }
  
  func setView1Data() {
    guard let cryptoData = cryptoData else {
      return
    }
    view1TextLabel.text = cryptoData.map{ $0.name }.joined(separator: ", ")
  }
  
  func setView2Data() {
    guard let cryptoData = cryptoData else {
      return
    }
    view2TextLabel.text = cryptoData.filter{ $0.currentValue > $0.previousValue }.map{ $0.name }.joined(separator: ", ")
  }
  
  func setView3Data() {
    guard let cryptoData = cryptoData else {
      return
    }
    view3TextLabel.text = cryptoData.filter{ $0.currentValue < $0.previousValue }.map{ $0.name }.joined(separator: ", ")
  }
  
  func setMostFallingMostRisingData() {
    guard let cryptoData = cryptoData else {
      return
    }
    let mostRising = cryptoData.filter{ $0.trend == .rising }.map{ $0.percentageRise }.max()
    mostRisingDataTextLabel.text = "\(mostRising!)"
    
    let mostFalling = cryptoData.filter{ $0.trend == .falling }.map{ $0.percentageRise }.min()
    mostFallingDataTextLabel.text = "\(mostFalling!)"
  }
  
  //MARK:- IBActions

  @IBAction func switchPressed(_ sender: Any) {
    if themeSwitch.isOn {
      ThemeManager.shared.set(theme: DarkTheme())
    }
    else {
      ThemeManager.shared.set(theme: LightTheme())
    }
  }

  @IBAction func tapGestureSent(sender: UITapGestureRecognizer) {
    //performSegue(withIdentifier: "ChartsSegue", sender: nil)
  }

  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? BarChartsViewController {
      switch segue.identifier {
      case "AllCurrenciesSegue":
        destinationVC.xAxisData = cryptoData!.map{ $0.name }
        destinationVC.yAxisData = cryptoData!.map{ $0.currentValue }
      case "RisingCurrenciesSegue":
        let risingCurrencies = cryptoData!.filter{ $0.trend == .rising }
        destinationVC.xAxisData = risingCurrencies.map{ $0.name }
        destinationVC.yAxisData = risingCurrencies.map{ $0.currentValue }
      case "FallingCurrenciesSegue":
        let fallingCurrencies = cryptoData!.filter{ $0.trend == .falling }
        destinationVC.xAxisData = fallingCurrencies.map{ $0.name }
        destinationVC.yAxisData = fallingCurrencies.map{ $0.currentValue }
      default:
        break
      }
    }
  }
}



//MARK: - Themeable

extension HomeViewController: Themeable {
  
  func registerForTheme() {
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged),
                                           name: Notification.Name.init("themeChanged"),
                                           object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    
    guard let currentTheme = ThemeManager.shared.currentTheme else {
      return
    }
    view1.backgroundColor = currentTheme.widgetBackgroundColor
    view2.backgroundColor = currentTheme.widgetBackgroundColor
    view3.backgroundColor = currentTheme.widgetBackgroundColor
    mostRisingView.backgroundColor = currentTheme.widgetBackgroundColor
    mostFallingView.backgroundColor = currentTheme.widgetBackgroundColor

    view1.layer.borderColor = currentTheme.borderColor.cgColor
    view2.layer.borderColor = currentTheme.borderColor.cgColor
    view3.layer.borderColor = currentTheme.borderColor.cgColor
    mostRisingView.layer.borderColor = currentTheme.borderColor.cgColor
    mostFallingView.layer.borderColor = currentTheme.borderColor.cgColor

    view1TextLabel.textColor = currentTheme.textColor
    view2TextLabel.textColor = currentTheme.textColor
    view3TextLabel.textColor = currentTheme.textColor
    headingLabel.textColor = currentTheme.textColor
    mostRisingDataTextLabel.textColor = currentTheme.textColor
    mostFallingDataTextLabel.textColor = currentTheme.textColor
    mostRisingLabel.textColor = currentTheme.textColor
    mostFallingLabel.textColor = currentTheme.textColor

    view.backgroundColor = currentTheme.backgroundColor
  }
  
  
}
