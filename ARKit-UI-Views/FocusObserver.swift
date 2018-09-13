//
//  FocusObserver.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/13/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

protocol FocusObserver: class { // FocusObserver may only be implemented by classes
    func gainedFocus()
    func lostFocus()
}
