//
//  ViewController.swift
//  ARKit-UI-Views
//
//  Created by Patrick Gatewood on 9/13/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var scnNodeCoordinatesLabel: UILabel!
    @IBOutlet weak var firstMaterialCoordinatesLabel: UILabel!
    
    var viewControllerDict = Dictionary<UIView, UIViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        sceneView.scene = scene
        
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 2
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            
            let arMenuViewController = ARMenuViewController.init(nibName: "ARMenuView", bundle: nil)
            
            let arMenuSCNNode = UISCNNode(viewController: arMenuViewController, geometry: plane)
            
            node.addChildNode(arMenuSCNNode)
        }
        return node
    }
}

// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let centerImagePosition = sceneView.center
        
        // Conduct a hit test based on a feature point that ARKit detected to find out what 3D point this 2D coordinate relates to
        let hitTestResult = sceneView.hitTest(centerImagePosition, options: [.boundingBoxOnly: true])
        
        // TODO: Try making custom UISCNNode (or whatever) to reduce the number of guards / conditional lets below
        guard let hitNode = hitTestResult.first?.node,
            let hitPlane = hitNode.geometry as? SCNPlane,
            hitPlane.firstMaterial != nil,
            let hitView = hitPlane.firstMaterial?.diffuse.contents as? UIView
            else {
                handleNoSCNNodesInFocus()
                return
        }
        
        guard let nodeHitCoordinates = hitTestResult.first?.localCoordinates,
            let nodeTextureHitCoordinates = hitTestResult.first?.textureCoordinates(withMappingChannel: hitPlane.firstMaterial!.diffuse.mappingChannel) else {
                print("no local coordinates")
                return
        }
        
        guard let hitViewController = viewControllerDict[hitView] as? ARMenuViewController else {
            print("didn't find a ViewController to use")
            return
        }
        
        // update labels
        scnNodeCoordinatesLabel.text = String(format: "\(type(of: hitNode)) coordinates: (%.2f, %.2f)", nodeHitCoordinates.x, nodeHitCoordinates.y)
        firstMaterialCoordinatesLabel.text = String(format: "\(type(of: hitView)) coordinates: (%.2f, %.2f)", nodeTextureHitCoordinates.x, nodeTextureHitCoordinates.y)
        
        hitViewController.hitTestViews(point: CGPoint(x: nodeTextureHitCoordinates.x, y: nodeTextureHitCoordinates.y))
    }
    
    private func handleNoSCNNodesInFocus() {
        scnNodeCoordinatesLabel.text = "Not looking at any SCNNodes."
        firstMaterialCoordinatesLabel.text = ""
        
        for focusObservable in viewControllerDict.values.compactMap({ $0 as? FocusObservable }) {
            focusObservable.notifyAllObserversLostFocus()
        }
    }
}
