/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import UIKit


struct RGB {
  var r = 127
  var g = 127
  var b = 127
}

extension RGB: GameProtocol {
  
    static func - (lhs: RGB, rhs: RGB) -> Int {
      let rDiff = Double(lhs.r - rhs.r)
      let gDiff = Double(lhs.g - rhs.g)
      let bDiff = Double(lhs.b - rhs.b)
      
      //Adding maxValue of the sqrt expression for scaling
      //255 doesn't scale the value correctly as that's the max for a single color component
      let max = (255.0 * 255.0 * 3.0).squareRoot()
      let dividend = (rDiff * rDiff + gDiff * gDiff + bDiff * bDiff).squareRoot()
      
      //Updating formula to use max for correct scaling
      return Int((dividend / max)*100)
    }
    
    static func random(in range: ClosedRange<Int>) -> RGB {
        return RGB( r:   Int.random(in: range),
                    g:   Int.random(in: range),
                    b:   Int.random(in: range)
                  )
    }

 }

