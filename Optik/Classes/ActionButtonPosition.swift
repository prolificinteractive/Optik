//
//  ActionButtonPosition.swift
//  Pods
//
//  Created by Rodrigo Leite on 28/11/16.
//
//

import Foundation

/**
 Defines the position of the action button.
 
 - topLeading:  action button is constrained to the top and leading anchors of its superview.
 - topTrailing: action button is constrained to the top and trailing anchors of its superview.
 */
public enum ActionButtonPosition {
    
    case bottomLeading
    
    func xAnchorAttribute() -> NSLayoutAttribute {
        switch self {
        case .bottomLeading:
            return .leading
        }
    }
    
    func yAnchorAttribute() -> NSLayoutAttribute {
        switch self {
        case .bottomLeading:
            return .bottom
        }
    }
}
