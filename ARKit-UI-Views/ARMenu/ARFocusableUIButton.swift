//
//  ARFocusableUIButton.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/13/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import UIKit

class ARFocusableUIButton: UIButton, FocusObserver {
    func gainedFocus() {
        alpha = 0.5
    }
    
    func lostFocus() {
        alpha = 1.0
    }
}
