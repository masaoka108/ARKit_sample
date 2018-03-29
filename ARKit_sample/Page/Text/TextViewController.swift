//,
//  TextViewController.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class TextViewController: UIViewController,ARSCNViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textInput: UITextField!
    
    let defaults = UserDefaults.standard
    let session = ARSession()
    var textNode:SCNNode?
    var textSize:CGFloat = 5
    var textDistance:Float = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup sceneView
        setupScene()
        //SettingsViewController.registerDefaults()
        
//        // Do any additional setup after loading the view, typically from a nib.
//        NotificationCenter.default.addObserver(self, selector: #selector(TextViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(TextViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textInput.delegate = self
        
//        self.growingTextView.layer.cornerRadius = 4
//        self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        self.growingTextView.textView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
//        self.growingTextView.placeholderAttributedText = NSAttributedString(string: "Placeholder text",
//                                                                            attributes: [NSAttributedStringKey.font: self.growingTextView.textView.font!,
//                                                                                         NSAttributedStringKey.foregroundColor: UIColor.gray
//            ]
        //)
        
        if (UserDefaults.standard.object(forKey:"textDistance") == nil) {
            UserDefaults.standard.register(defaults: ["textDistance":10])
        }
        
        if (UserDefaults.standard.object(forKey:"textFont") == nil) {
            UserDefaults.standard.register(defaults: ["textFont":25])
        }
        
        if (UserDefaults.standard.object(forKey:"textColor") == nil) {
            UserDefaults.standard.setColor(color: UIColor.white, forKey: "textColor")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        //sceneView.showsStatistics = true
        
        enableEnvironmentMapWithIntensity(25.0)
        
        DispatchQueue.main.async {
            //self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            //camera.wantsExposureAdaptation = true
            //camera.exposureOffset = -1
            //camera.minimumExposure = -1
        }
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    
//    @objc func keyboardWillHide(_ sender: Notification) {
//        if let userInfo = (sender as NSNotification).userInfo {
//            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
//                //key point 0,
//                //self.sendButton.constant =  0
//                //textViewBottomConstraint.constant = keyboardHeight
//                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
//            }
//        }
//    }
//    @objc func keyboardWillShow(_ sender: Notification) {
//        if let userInfo = (sender as NSNotification).userInfo {
//            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
//                //self.sendButton.constant = keyboardHeight
//                UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                    self.view.layoutIfNeeded()
//                })
//            }
//        }
//    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textInput?.resignFirstResponder()
        return true;
    }
    
    @IBAction func clickSend(_ sender: UIButton) {
        if let text = textInput.text {
            self.showText(text: text)
        }else{
            print("empty string")
        }
        textInput.text = ""
//        self.view.endEditing(true)
    }
    
    
    func showText(text:String) -> Void{
        let fontSize = CGFloat(defaults.float(forKey: "textFont"))
        let textDistance = defaults.float(forKey: "textDistance")
        let textColor = defaults.colorForKey(key: "textColor")
        
        let textScn = ARText(text: text, font: UIFont .systemFont(ofSize: fontSize), color: textColor!, depth: fontSize/10)
//        let textNode = TextNode(distance: textDistance/10, scntext: textScn, sceneView: self.sceneView, scale: 1/100.0)
        let textNode = TextNode(distance: textDistance/2, scntext: textScn, sceneView: self.sceneView, scale: 0.08)
        self.sceneView.scene.rootNode.addChildNode(textNode)
    }

}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }else{
            color = UIColor.white
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    
}
