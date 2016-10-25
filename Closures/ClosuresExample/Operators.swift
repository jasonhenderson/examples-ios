//
//  Operators.swift
//  ClosuresExample
//
//  Created by Jason Henderson on 9/22/15.
//
//  This file is part of examples-ios.
//
//  examples-ios is free software: you c an redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  examples-ios is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with examples-ios.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

/// Convenient overload of divide operator used to report progress
func /(left: Int, right: Int) -> Float {
    return Float(left) / Float(right)
}

/// Convenient overload of modulo operator used to report progress
func %(left: Float, right: Float) -> Int {
    return Int(left * 100) % Int(right * 100)
}

