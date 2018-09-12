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
    
    override func viewDidLoad() {
//        let imageView = UIImageView(image: UIImage(named: "dot"))
//        imageView.frame.size.width = 10
//        imageView.frame.size.height = 10
//        imageView.center = topButton.center
//        arMenuView.addSubview(imageView)
//        topButton.frame.origin = topButton.center
    }
    
    func hitTestViews(point: CGPoint) {
        // need a way better way to do this
        hitTestButton(button: topButton, point: point)
//        hitTestButton(button: bottomButton, point: point)
    }
    
    // need a way better way to do this
    private func hitTestButton(button: UIButton, point: CGPoint) {
        let imageView = UIImageView(image: UIImage(named: "dot"))
        imageView.frame.size.width = 10
        imageView.frame.size.height = 10
//        let point = arMenuView.convert(point, to: button)
        imageView.center = point
        button.addSubview(imageView)
 
        button.alpha = button.point(inside: point, with: nil) ? 0.5 : 1.0
        print("testing button for point: \(point)")
    }
}
