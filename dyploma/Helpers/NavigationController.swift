//
//  NavigationController\.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//


import UIKit

class NavigationController : UINavigationController{
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setNavigationBarHidden(true, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNavigationBarHidden(true, animated: true)
    }
    
}

extension UIViewController{
    
    func updateRootViewController(_ viewController : UIViewController, animated : Bool = true){
        navigationController?.setViewControllers([viewController], animated: animated )
    }
    
    func pushToNavigationController(_ viewController : UIViewController, animated : Bool = true){
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    
}
