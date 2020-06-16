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
  
  @IBOutlet private weak var view1: CryptoCurrencyView!
  @IBOutlet private weak var view2: CryptoCurrencyView!
  @IBOutlet private weak var view3: CryptoCurrencyView!
  @IBOutlet private weak var headingLabel: UILabel!
  @IBOutlet private weak var view1TextLabel: UILabel!
  @IBOutlet private weak var view2TextLabel: UILabel!
  @IBOutlet private weak var view3TextLabel: UILabel!
  @IBOutlet private weak var themeSwitch: UISwitch!
  @IBOutlet private weak var mostFallingView: CryptoCurrencyView!
  @IBOutlet private weak var mostRisingView: CryptoCurrencyView!
  @IBOutlet private weak var mostRisingLabel: UILabel!
  @IBOutlet private weak var mostFallingLabel: UILabel!
  @IBOutlet private weak var mostFallingDataTextLabel: UILabel!
  @IBOutlet private weak var mostRisingDataTextLabel: UILabel!
  private let allCurrenciesSegueID = "AllCurrenciesSegue"
  private let risingCurrenciesSegueID = "RisingCurrenciesSegue"
  private let fallingCurrenciesSegueID = "FallingCurrenciesSegue"

  //MARK: - Properties
  private let cryptoData = DataGenerator.shared.generateData()
  private var risingCurrencies: [CryptoCurrency]? {
    return cryptoData != nil ? cryptoData!.filter{ $0.trend == .rising } : [CryptoCurrency]()
  }
  private var fallingCurrencies: [CryptoCurrency]? {
    return cryptoData != nil ? cryptoData!.filter{ $0.trend == .falling } : [CryptoCurrency]()
  }

  //MARK:- View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLabels()
    
    guard let _ = cryptoData else {
      return
    }
    setView1Data()
    setView2Data()
    setView3Data()
    setMostFallingMostRisingData()
  }
     
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
    switchPressed(themeSwitch!)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
  }

  //MARK:- View Setup
  
  private func setupLabels() {
    headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    view1TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    view2TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
  }
  
  private func setView1Data() {
    if cryptoData != nil  {
      view1TextLabel.text = cryptoData!.map{ $0.name }.joined(separator: ", ")
    }
  }
  
  private func setView2Data() {
    if risingCurrencies != nil  {
      view2TextLabel.text = risingCurrencies!.map{ $0.name }.joined(separator: ", ")
    }
  }
  
  private func setView3Data() {
    if fallingCurrencies != nil  {
      view3TextLabel.text = fallingCurrencies!.map{ $0.name }.joined(separator: ", ")
    }
  }
  
  private func setMostFallingMostRisingData() {
    if risingCurrencies != nil {
       let mostRising = risingCurrencies!.map{ $0.valueRise }.max()
       mostRisingDataTextLabel.text = mostRising != nil ? "\(mostRising!)" : ""
    }
    if fallingCurrencies != nil {
       let mostFalling = fallingCurrencies!.map{ $0.valueRise }.min()
       mostFallingDataTextLabel.text = mostFalling != nil ? "\(mostFalling!)" : ""
    }
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

  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let destinationVC = segue.destination as? BarChartsViewController {
      
      switch segue.identifier {
      case allCurrenciesSegueID:
        if cryptoData != nil {
          destinationVC.barChartColor = UIColor(red: 160/255, green: 230/255, blue: 250/255, alpha: 1.0)
          destinationVC.xAxisData = cryptoData!.map{ $0.symbol }
          destinationVC.yAxisData = cryptoData!.map{ $0.currentValue }
          destinationVC.barChartDescription = "Current value of all cryptoCurrencies in USD"
        }
      case risingCurrenciesSegueID:
        if risingCurrencies != nil {
          destinationVC.barChartColor = UIColor(red: 101/255, green: 200/255, blue: 22/255, alpha: 1.0)
          destinationVC.xAxisData = risingCurrencies!.map{ $0.symbol }
          destinationVC.yAxisData = risingCurrencies!.map{ $0.currentValue }
          destinationVC.barChartDescription = "Current value of rising cryptoCurrencies in USD"
        }
      case fallingCurrenciesSegueID:
        destinationVC.barChartColor = UIColor(red: 214/255, green: 87/255, blue: 69/255, alpha: 1.0)
        if fallingCurrencies != nil {
          destinationVC.xAxisData = fallingCurrencies!.map{ $0.symbol }
          destinationVC.yAxisData = fallingCurrencies!.map{ $0.currentValue }
          destinationVC.barChartDescription = "Current value of falling cryptoCurrencies in USD"
        }
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
                                           name: .ThemeDidChange,
                                           object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    
    guard let currentTheme = ThemeManager.shared.currentTheme else {
      return
    }
    
    let views: [CryptoCurrencyView] = [view1, view2, view3, mostRisingView, mostFallingView]
    views.forEach{ $0.backgroundColor = currentTheme.widgetBackgroundColor
                   $0.layer.borderColor = currentTheme.borderColor.cgColor
    }
    
    let labels:[UILabel] = [view1TextLabel, view2TextLabel, view3TextLabel, headingLabel,
                  mostRisingDataTextLabel, mostFallingDataTextLabel, mostRisingLabel, mostFallingLabel]
    labels.forEach{ $0.textColor = currentTheme.textColor }

    view.backgroundColor = currentTheme.backgroundColor
  }
  
  
}
