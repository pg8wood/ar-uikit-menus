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
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var hitPointIndicator: UIImageView!
    
    override func viewDidLoad() {
        hitPointIndicator.layer.borderColor = UIColor.black.cgColor
        hitPointIndicator.layer.borderWidth = 1
    }

    
    func reverseHitTestViews(point: CGPoint) {
        if arMenuView.point(inside: point, with: nil) {
            // TODO this translation of coordinates is always necessary
            let pointInARMenuView = CGPoint(x: point.x * view.frame.size.width, y: point.y * view.frame.size.height) // scale factor is off!
            
            if let arMenuHitTestResult = arMenuView.hitTest(pointInARMenuView, with: nil) {
                print("ar menu hit test: \(arMenuHitTestResult)")
                
                if let observer = arMenuHitTestResult as? FocusObserver {
                    print("\(type(of: arMenuHitTestResult)) gained focus")
                    observer.gainedFocus()
                }

                // TODO unset: probably best to listen for when enters and leaves this view
            }

            animateViewHitPointIndicator(toPoint: pointInARMenuView)
        } else {
            hitPointIndicator.alpha = 0
        }
    }
    
    private func animateViewHitPointIndicator(toPoint: CGPoint) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            // Yay Swift 4.2!!!
            guard let self = self else { return }
            
            self.hitPointIndicator.alpha = 1
            self.hitPointIndicator.layer.position = toPoint
//            print("moving dot to \(toPoint)")
        })
    }
    
    func resetButtonAppearances() {
        topButton.alpha = 1
        bottomButton.alpha = 1
    }
    
}
