//
//  PutPictureViewController.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PutPictureViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        showUIImagePicker()
    }
    
    private func showUIImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            pickerView.modalPresentationStyle = .overFullScreen
            self.present(pickerView, animated: true, completion: nil)
        }
    }

    private func setImageToScene(image: UIImage) {
        if let camera = sceneView.pointOfView {
            // 偏差のベクトルを生成する
            let position = SCNVector3(x: 0, y: 0, z: -0.5)

            //現在の中心からzに-0.5ズラした場所
            let convertPosition = camera.convertPosition(position, to: nil)

            //ノード(SCNBoxにUIImageをセットしたもの)を作成
            let node = createPhotoNode(image, position: convertPosition)

            //ノードを追加
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    private func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNBox(width: image.size.width * scale / image.size.height,
                              height: scale,
                              length: 0.00000001,
                              chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
}

extension PutPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //選択した写真(UIImage)をsceneに追加
            setImageToScene(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
