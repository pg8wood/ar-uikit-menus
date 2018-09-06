//
//  NibView.swift
//  SpaceShipMuseum
//
//  Created by Patrick Gatewood on 9/6/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class NibView: UIView {
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
}
private extension NibView {
    
    func setupNib() {
        backgroundColor = UIColor.clear
        view = UIView()
        view.backgroundColor = UIColor.red
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Fill parent view 
        view.translatesAutoresizingMaskIntoConstraints = false
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
//                                                      options: [],
//                                                      metrics: nil,
//                                                      views: ["childView": view]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
//                                                      options: [],
//                                                      metrics: nil,
//                                                      views: ["childView": view]))
    }
}
