//
//  Array.swift
//  GoogleMapGB
//
//  Created by LACKY on 22.05.2022.
//

import Foundation

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        
        return self[middleIndex]
    }
}
