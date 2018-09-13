//
//  ARMenuView.swift
//  SpaceShipMuseum
//
//  Created by Patrick Gatewood on 9/6/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class ARMenuViewController: UIViewController {
    @IBOutlet var arMenuView: ARMenuView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topButton: ARFocusableUIButton!
    @IBOutlet weak var bottomButton: ARFocusableUIButton!
    
    var hitPointIndicator: UIImageView!
    
    var focusObservers = [ObjectIdentifier: FocusObserver]()
    override func viewDidLoad() {
        renderHitPointIndicator()
        addObserver(topButton)
        addObserver(bottomButton)
    }
    
    private func renderHitPointIndicator() {
        hitPointIndicator = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hitPointIndicator.image = UIImage(named: "dot_orange")
        hitPointIndicator.contentMode = .scaleAspectFill
        
        arMenuView.addSubview(hitPointIndicator)
    }

    
    func hitTestViews(point: CGPoint) {
        // TODO this translation of coordinates is always necessary.
        let pointInARMenuView = CGPoint(x: point.x * arMenuView.frame.size.width, y: point.y * arMenuView.frame.size.height) // scale factor is off!
        
        if let arMenuHitTestResult = arMenuView.hitTest(pointInARMenuView, with: nil) {
            animateViewHitPointIndicator(toPoint: pointInARMenuView)
            
            if let observer = arMenuHitTestResult as? FocusObserver {
                // Only allow one observer to have focus at any given time
                notifyAllObserversLostFocus()
                
                observer.gainedFocus()
                return
            }
        }
        
        notifyAllObserversLostFocus()
    }
    
    private func animateViewHitPointIndicator(toPoint: CGPoint) {
        UIView.animate(withDuration: 0.05, animations: { [weak self] in
            guard let self = self else { return } // Yay Swift 4.2!
            
            self.hitPointIndicator.alpha = 1
            self.hitPointIndicator.layer.position = toPoint
            print("toPoint: \(toPoint) | hitPointIndicatorPosition: \(self.hitPointIndicator.layer.position)")
        })
    }
    
    func resetButtonAppearances() {
        topButton.alpha = 1
        bottomButton.alpha = 1
    }
    
}

extension ARMenuViewController: FocusObservable {
    var observers: [ObjectIdentifier: FocusObserver] {
        get {
            return focusObservers
        } set {
            focusObservers = newValue
        }
    }
    
    func addObserver(_ observer: FocusObserver) {
        observers[ObjectIdentifier(observer)] = observer
    }
    
    func removeObserver(_ observer: FocusObserver) {
        observers.removeValue(forKey: ObjectIdentifier(observer))
    }
    
    func notifyAllObserversLostFocus() {
        for observer in observers.values {
            observer.lostFocus()
        }
    }
}
