//
//  FocusObservable.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/13/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

protocol FocusObservable {
    var observers: [ObjectIdentifier: FocusObserver] { get set }
    
    func addObserver(_ observer: FocusObserver)
    func removeObserver(_ observer: FocusObserver)
    func notifyAllObserversLostFocus()
}
