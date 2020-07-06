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

class CustomCollectionView: UICollectionView {

  //MARK: - Properties
  
  private var isWiggling = false

  private var longPressRecognizer: UILongPressGestureRecognizer = {
      let longPressRecognizer = UILongPressGestureRecognizer()
      longPressRecognizer.delaysTouchesBegan = false
      longPressRecognizer.cancelsTouchesInView = false
      longPressRecognizer.numberOfTouchesRequired = 1
      longPressRecognizer.minimumPressDuration = 0.1
      longPressRecognizer.allowableMovement = 10.0
      return longPressRecognizer
  }()

  //MARK: - Initializer

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
      super.init(frame: frame, collectionViewLayout: layout)
      commonInit()
  }

  fileprivate func commonInit() {
      longPressRecognizer.addTarget(self, action: #selector(CustomCollectionView.handleLongPress(_:)))
      longPressRecognizer.isEnabled = false
      self.addGestureRecognizer(longPressRecognizer)
  }
 
  //MARK: - DequeueReusableCell

  override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
      let cell: AnyObject = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath)
      if let cell = cell as? PokemonCollectionViewCell {
        cell.isEditing = isWiggling
      }
      if isWiggling {
          addWiggleAnimationTo(cell as! UICollectionViewCell)
      } else {
      if #available(iOS 13.0, *) {
        cell.layer.removeAllAnimations()
      } else {
        // Fallback on earlier versions
      }
    }
    return cell as! UICollectionViewCell

  }
  
  //MARK: - Action Event For Long Press Gesture Recognizer

  @objc fileprivate func handleLongPress(_ gesture: UILongPressGestureRecognizer) {

    switch(gesture.state) {
      case .began:
          guard let selectedIndexPath = indexPathForItem(at: gesture.location(in: self)) else {
              break
          }
          guard let cell = self.cellForItem(at: selectedIndexPath) as? PokemonCollectionViewCell else { return }
          cell.isEditing = false
          beginInteractiveMovementForItem(at: selectedIndexPath)
      case .changed:
          updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
      case .ended:
          endInteractiveMovement()
      default:
          cancelInteractiveMovement()
    }
  }

  //MARK: - Enable Dragging Of Cell Items

  public func enableDragging(_ enable: Bool) {
    longPressRecognizer.isEnabled = enable
  }

}

//MARK: - Wiggle Animation

extension CustomCollectionView {
  
    func startWiggle() {
      visibleCells.forEach{ addWiggleAnimationTo($0) }
      isWiggling = true
    }
    
    func stopWiggle() {
      visibleCells.forEach{ $0.layer.removeAllAnimations() }
      isWiggling = false
    }
    
    fileprivate func addWiggleAnimationTo(_ cell: UICollectionViewCell) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.add(rotationAnimation(), forKey: "rotation")
        cell.layer.add(bounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }
    
    fileprivate func rotationAnimation() -> CAKeyframeAnimation {
        
        let keyPath = "transform.rotation.z"
        let angle = CGFloat(0.04)
        let duration = TimeInterval(0.1)
        return animation(withKeyPath: keyPath, angle: angle, bounce: nil, duration: duration)
    }
    
    fileprivate func bounceAnimation() -> CAKeyframeAnimation {
        let keyPath = "transform.translation.y"
        let bounce = CGFloat(1.0)
        let duration = TimeInterval(0.12)
        return animation(withKeyPath: keyPath, angle: nil, bounce: bounce, duration: duration)
    }
    
    fileprivate func animation(withKeyPath keyPath: String, angle: CGFloat?, bounce: CGFloat?, duration: TimeInterval) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        let variance = Double(0.01)
        if let angle = angle {
          animation.values = [angle, -angle]
        }
        if let bounce = bounce {
          animation.values = [bounce, -bounce]
        }
        animation.autoreverses = true
        animation.duration = self.randomize(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
      }
  
    fileprivate func randomize(_ interval: TimeInterval, withVariance variance:Double) -> TimeInterval {
        
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random;
    }
  
}

