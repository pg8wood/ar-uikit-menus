//
//  UISCNNode.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/14/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import UIKit
import SceneKit

class UISCNNode: SCNNode {
    
    var viewController: UIViewController!
    
    init(viewController: UIViewController, geometry: SCNGeometry) {
        super.init()

        self.viewController = viewController
        self.geometry = geometry
        self.geometry?.firstMaterial?.diffuse.contents = viewController.view
        
        eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
