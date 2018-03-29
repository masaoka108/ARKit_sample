//
//  MeasureViewController.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MeasureViewController: UIViewController, ARSCNViewDelegate {
    var nodes: [SphereNode] = []

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
//        // Prevent the screen from being dimmed after a while.
//        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start a new session
        startNewSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func startNewSession() {
//        // Create a session configuration with horizontal plane detection
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//
//        // Run the view's session
//        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])

        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        
    }

    // MARK: ARSCNViewDelegate
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var status = "Loading..."
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            status = "Not available"
        case ARCamera.TrackingState.limited(_):
            status = "Analyzing..."
        case ARCamera.TrackingState.normal:
            status = "Ready"
        }
        infoLabel.text = status
    }
    
    // MARK: Gesture handlers
    @objc func handleTap(sender: UITapGestureRecognizer) {
        //タップされたlocation を取得
        let tapLocation = sender.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
        
        //タップされた場所の位置情報が取得できるか確認
        if let result = hitTestResults.first {
            //タップされた場所にSphereを追加
            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SphereNode(position: position)
            sceneView.scene.rootNode.addChildNode(sphere)
            
            //一個前に追加したノードを取得
            let lastNode = nodes.last

            nodes.append(sphere)

            if lastNode != nil {
                //一個前のノードが存在する場合は距離測定を行う
                //距離を取得-表示
                let distance = lastNode!.position.distance(to: sphere.position)
                infoLabel.text = String(format: "Distance: %.2f meters", distance)
                
                //LineGeometryを追加
                let measureLine = LineNode(from: (lastNode?.position)!, to: sphere.position, lineColor: UIColor.red, lineWidth: 0.004)
                sceneView.scene.rootNode.addChildNode(measureLine)
            }
        }
    }
    
}
