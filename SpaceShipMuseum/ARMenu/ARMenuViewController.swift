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
            let pointInARMenuView = CGPoint(x: point.x * view.frame.size.width, y: point.y * view.frame.size.height) // scale factor is off!
            
            animateViewHitPointIndicator(toPoint: pointInARMenuView)

            // need a way better way to do this
            reverseHitTestButton(button: topButton, point: pointInARMenuView)
            reverseHitTestButton(button: bottomButton, point: pointInARMenuView)
        } else {
            hitPointIndicator.alpha = 0
        }
    }
    
    private func animateViewHitPointIndicator(toPoint: CGPoint) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let sSelf = self else {
                return
            }
            
            sSelf.hitPointIndicator.alpha = 1
            sSelf.hitPointIndicator.layer.position = toPoint
            print("moving dot to \(toPoint)")
        })
    }
    
    func resetButtonAppearances() {
        topButton.alpha = 1
        bottomButton.alpha = 1
    }
    
    // need a way better way to do this
    private func reverseHitTestButton(button: UIButton, point: CGPoint) {
        button.alpha = button.point(inside: point, with: nil) ? 0.5 : 1.0
        print("testing button for point: \(point)")
        
        // TODO: update child's child label. Perhaps make a SCNOverlay protocol that ViewController.swift conforms to in an extension. something like AROverlayDelegate.updateChildChildLabel() with the coordinates or something. i dunno :P
    }
}
