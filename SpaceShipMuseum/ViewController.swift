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
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var scnNodeCoordinatesLabel: UILabel!
    @IBOutlet weak var firstMaterialCoordinatesLabel: UILabel!
    @IBOutlet weak var firstMaterialChildViewCoordinatesLabel: UILabel!
    
    var focusObservers = [ObjectIdentifier: FocusObserver]()
    var viewControllerDict = Dictionary<UIView, UIViewController>()
    
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
            
            DispatchQueue.main.async { [weak self] in // TODO see if this is necessary
                let arMenuViewController = ARMenuViewController.init(nibName: "ARMenuView", bundle: nil)
                self?.viewControllerDict[arMenuViewController.view] = arMenuViewController
                arMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self?.addObserver(arMenuViewController.arMenuView)
                plane.firstMaterial?.diffuse.contents = arMenuViewController.arMenuView
            }
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let centerImagePosition = sceneView.center
        
        // Conduct a hit test based on a feature point that ARKit detected to find out what 3D point this 2D coordinate relates to
        let hitTestResult = sceneView.hitTest(centerImagePosition, options: [.boundingBoxOnly: true])
        
        guard let hitNode = hitTestResult.first?.node else {
            scnNodeCoordinatesLabel.text = "Not looking at any SCNNodes."
            firstMaterialCoordinatesLabel.text = ""
            firstMaterialChildViewCoordinatesLabel.text = ""
            
            for observer in observers.values {
                observer.lostFocus()
            }
            
            return
        }
        
        guard let hitPlane = hitNode.geometry as? SCNPlane else {
            print("not a plane")
            return
        }
        
        let hitNodeContents = hitPlane.firstMaterial?.diffuse.contents
    
        if let hitView = hitNodeContents as? ARMenuView {
            guard let nodeHitCoordinates = hitTestResult.first?.localCoordinates,
                let nodeTextureHitCoordinates = hitTestResult.first?.textureCoordinates(withMappingChannel: hitPlane.firstMaterial?.diffuse.mappingChannel ?? 0) else { 
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
            
            //
            hitViewController.reverseHitTestViews(point: CGPoint(x: nodeTextureHitCoordinates.x, y: nodeTextureHitCoordinates.y))
        }
    }
}

extension ViewController: FocusObservable {
    var observers: [ObjectIdentifier: FocusObserver] {
        get {
           return focusObservers
        } set {
           focusObservers = newValue
        }
    }

    func addObserver(_ observer: FocusObserver) {
        observers[ObjectIdentifier(observer)] = observer
    }
    
    func removeObserver(_ observer: FocusObserver) {
        observers.removeValue(forKey: ObjectIdentifier(observer))
    }
}
