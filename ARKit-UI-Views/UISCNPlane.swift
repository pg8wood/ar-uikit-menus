//
//  UISCNNode.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/14/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import UIKit
import SceneKit

class UISCNNode<T: UIViewController>: SCNNode {
    
    var viewController: T!
    
    init (nibName: String?, bundle: Bundle?, geometry: SCNGeometry) {
        super.init()
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController = T.init(nibName: nibName, bundle: bundle)
            self?.setupNode(with: geometry)
        }
    }
    
    // Note: the VC must be fully initialized on the main thread before using this initializer.
    init(viewController: UIViewController, geometry: SCNGeometry) {
        super.init()
        self.viewController = viewController as? T
        setupNode(with: geometry)
    }
    
    private func setupNode(with geometry: SCNGeometry) {
        self.geometry = geometry
        self.geometry?.firstMaterial?.diffuse.contents = viewController.view
        
        eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
