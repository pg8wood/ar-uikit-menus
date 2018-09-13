//
//  ARFocusableUIButton.swift
//  SpaceShipMuseum
//
//  Created by Patrick Gatewood on 9/13/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class ARFocusableUIButton: UIButton, FocusObserver {
    func gainedFocus() {
        alpha = 1.0
    }
    
    func lostFocus() {
        alpha = 0.5
    }
}
