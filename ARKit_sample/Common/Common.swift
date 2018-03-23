//
//  Common.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/23.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit


struct SampleMenu {
    let title: String
    let storyBoadName: String
//    let detail: String
    let viewController: UIViewController
    
    func getController() -> UIViewController {
        let storyboard = UIStoryboard(name: storyBoadName, bundle: nil)
        let controller:UIViewController = storyboard.instantiateViewController(withIdentifier: storyBoadName)
        controller.title = title
        return controller
    }
}


let menu = [
    SampleMenu(title:"add_box", storyBoadName:"AddBox", viewController:AddBoxViewController()),
    SampleMenu(title:"plane_detective", storyBoadName:"AddBox", viewController:AddBoxViewController()),

]

func getController(viewControllerName:String, title:String) -> UIViewController {
    let storyboard = UIStoryboard(name: viewControllerName, bundle: nil)
    guard let controller = storyboard.instantiateInitialViewController() else {fatalError()}
    controller.title = title
    return controller
}
