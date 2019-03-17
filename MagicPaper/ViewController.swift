//
//  ViewController.swift
//  MagicPaper
//
//  Created by Antonakakis Nikolaos on 17.03.19.
//  Copyright © 2019 Antonakakis Nikolaos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        // indicate what we will be tracking. In our case, an image, thus
        // indicate that our configuration is tracking an Image
        let configuration = ARImageTrackingConfiguration()
        // check if the images we track are included in our bundle
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main) {
            // once we are certain that are tracked images we set them to be those specified above as trackedImages
            configuration.trackingImages = trackedImages
            // specify the max amount of images our configuration accepts
            configuration.maximumNumberOfTrackedImages = 1
            
            

        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // In order to receive the events from our scene when it detects a new image we need to add a delegate method
    // anchor is the image that it finds; we need to return a node to be displayed in our scene
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // first create a node
        let node = SCNNode()
        // check if this anchor is actually of the datatype image anchor
        if let imageAnchor = anchor as? ARImageAnchor {
            // create our plane
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set its material to a new UIColor
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            // create a plane node
            let planeNode = SCNNode(geometry: plane)
            // rotate the plane 90 degreess counterclockwise so that it's flat on the image
            planeNode.eulerAngles.x = -.pi / 2
            // tap into this node and add the child node that we created, i.e. planeNode
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
    

}
