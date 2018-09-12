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
    @IBOutlet weak var dotImage: UIImageView!
    
    override func viewDidLoad() {
        dotImage.layer.borderColor = UIColor.black.cgColor
        dotImage.layer.borderWidth = 1
    }
    
    func reverseHitTestViews(point: CGPoint) {
        if arMenuView.point(inside: point, with: nil) {
             let pointInARMenuView = CGPoint(x: point.x * view.frame.size.width, y: point.y * view.frame.size.height) // scale factor is off!
            
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let sSelf = self else {
                    return
                }
               
                sSelf.dotImage.alpha = 1
                sSelf.dotImage.layer.position = pointInARMenuView
                print("moving dot to \(pointInARMenuView)")
            })
            
            // need a way better way to do this
            reverseHitTestButton(button: topButton, point: pointInARMenuView)
            reverseHitTestButton(button: bottomButton, point: pointInARMenuView)
        } else {
            dotImage.alpha = 0
        }
    }
    
    func resetButtonAppearances() {
        topButton.alpha = 1
        bottomButton.alpha = 1
    }
    
    // need a way better way to do this
    private func reverseHitTestButton(button: UIButton, point: CGPoint) {
        button.alpha = button.point(inside: point, with: nil) ? 0.5 : 1.0
        print("testing button for point: \(point)")
    }
}
