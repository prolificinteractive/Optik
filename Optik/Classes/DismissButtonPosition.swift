//
//  DismissButtonPosition.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public enum DismissButtonPosition {
    
    case TopLeading
    case TopTrailing
    
    func xAnchorAttribute() -> NSLayoutAttribute {
        switch self {
        case .TopLeading:
            return .Leading
        case .TopTrailing:
            return .Trailing
        }
    }
    
    func yAnchorAttribute() -> NSLayoutAttribute {
        switch self {
        case .TopLeading, .TopTrailing:
            return .Top
        }
    }
    
}
