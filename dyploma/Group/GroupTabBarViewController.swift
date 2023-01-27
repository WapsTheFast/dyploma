//
//  GroupTabBarViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class GroupTabBarViewController: UITabBarController {
    
    var group : Group!
    var teacher : Teacher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        guard let viewControllers = viewControllers else {return}
        for vc in viewControllers{
            var rvc = vc as? GroupTabBarProtocol
            rvc?.delegate = self
            rvc?.group = group
            rvc?.teacher = teacher
        }
    }
    
}
