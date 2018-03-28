//
//  PaintViewController.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PaintViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var previousPoint: SCNVector3?
    @IBOutlet weak var button: UIButton!
    //var lineColor = UIColor.white
    
    var buttonHighlighted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        // Create a new scene
//        let scene = SCNScene(named: "world.scn")!
        // Set the scene to the view
//        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.buttonHighlighted = self.button.isHighlighted
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        //currentPositionを取得
        guard let pointOfView = sceneView.pointOfView else { return }
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position + (dir * 0.1)
        
        if buttonHighlighted {
            //ボタンが押されていればcurrentPositionにシリンダーを配置
            let cylinderGeometry = SCNCylinder(radius: CGFloat(0.005), height: 0.001)
            let boxNode = SCNNode()
            boxNode.geometry = cylinderGeometry
            boxNode.position = currentPosition
            boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            sceneView.scene.rootNode.addChildNode(boxNode)
        }
        previousPoint = currentPosition
    }

    
}

