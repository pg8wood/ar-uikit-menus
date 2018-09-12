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
        let imageView = UIImageView(image: UIImage(named: "dot"))
        imageView.frame.size.width = 10
        imageView.frame.size.height = 10
        imageView.center = CGPoint(x: 0, y: 0)
        arMenuView.addSubview(imageView)
        topButton.frame.origin = topButton.center
    }
    
    func reverseHitTestViews(point: CGPoint) {
        if arMenuView.point(inside: point, with: nil) {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let sSelf = self else {
                    return
                }
                let newDotPoint = CGPoint(x: point.x * 150, y: point.y * 150) // scale factor is off!
                
                sSelf.dotImage.alpha = 1
                sSelf.dotImage.layer.position = newDotPoint
                print("moving dot to \(point)")
            })
        } else {
            dotImage.alpha = 0
        }
        
        // need a way better way to do this
        reverseHitTestButton(button: topButton, point: point)
        reverseHitTestButton(button: bottomButton, point: point)
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
