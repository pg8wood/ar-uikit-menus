//
//  ARMenuView.swift
//  SpaceShipMuseum
//
//  Created by Patrick Gatewood on 9/6/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class ARMenuViewController: UIViewController {
    @IBOutlet var arMenuView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton:UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
//        titleLabel.textColor = #colorLiteral(red: 0.2078431373, green: 0.2352941176, blue: 0.2509803922, alpha: 1)
        leftButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
//        rightButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    }
}
