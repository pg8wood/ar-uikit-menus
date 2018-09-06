//
//  ViewController.swift
//  SpaceShipMuseum
//
//  Created by Brian Advent on 09.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
//    let arMenuView: NibView = NibView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        sceneView.session.delegate = self
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            print("No images available")
            return
        }

        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            let arMenuViewController = ARMenuViewController.init(nibName: "ARMenuView", bundle: nil)
            arMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            plane.firstMaterial?.diffuse.contents = arMenuViewController.view
            
            let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
            shipNode.position = SCNVector3Zero
            shipNode.position.z = 0.15
            
            planeNode.addChildNode(shipNode)
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    // MARK: - ARSessionDelegate
    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        print("did update frame")
//        guard let rawFeaturePoints = frame.rawFeaturePoints else {
//            return
//        }
//
//
//        for point in rawFeaturePoints.points  {
//            print("adding node to scene")
//            let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.5))
//            sphereNode.position = SCNVector3(point)
//
//            sceneView.scene.rootNode.addChildNode(sphereNode)
//        }
//    }
}
