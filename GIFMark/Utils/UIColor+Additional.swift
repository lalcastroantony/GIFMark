//
//  UIColor+Additional.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import Foundation
import UIKit

extension UIColor {
    static func getRandomColor() -> UIColor{
        let colors: [UIColor] = [.systemBlue,.systemOrange,.systemCyan,.systemPink,.systemBrown,.systemIndigo,.systemPurple,.systemYellow,.systemGreen,.systemMint]
        let randomIndex = Int.random(in: 0...9)
        return colors[randomIndex]
    }
}
