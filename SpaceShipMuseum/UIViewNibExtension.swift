//
//  UIViewNibExtension.swift
//  SpaceShipMuseum
//
//  Created by Patrick Gatewood on 9/6/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
