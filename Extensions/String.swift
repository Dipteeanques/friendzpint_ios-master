//
//  String.swift
//  FriendzPoint
//
//  Created by Anques on 12/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import Foundation

extension String{
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
}
