//
//  SceneDelegate.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //UserDefaultsManager.storage.setBool(value: false, data: .onBoardingIsShowed)
        

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.center = window!.center
        var navigationController : NavigationController!
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let windowFirst = windowScene.windows.first else {
            return
        }

        // Create and configure the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = windowFirst.center
        activityIndicator.backgroundColor = UIColor.clear
        windowFirst.backgroundColor = UIColor.systemBackground
        windowFirst.addSubview(activityIndicator)
        self.window?.makeKeyAndVisible()
        windowFirst.bringSubviewToFront(activityIndicator)
        if Auth().token != nil{
            activityIndicator.startAnimating()
            Auth().getUserInfo{
                result, user in
                switch result{
                case .success:
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        if user?.role == .teacher{
                            let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                            let vc = storyboard.instantiateInitialViewController() as! TeacherViewController
                            vc.teacher = user
                            navigationController = NavigationController(rootViewController: vc)
                            self.window?.rootViewController = navigationController
                            self.window?.makeKeyAndVisible()
                        }else if user?.role == .student{
                            let storyboard = UIStoryboard(name: "Student", bundle: nil)
                            let vc = storyboard.instantiateInitialViewController() as! StudentLecturesTableViewController
                            vc.student = user
                            navigationController = NavigationController(rootViewController: vc)
                            self.window?.rootViewController = navigationController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        navigationController = NavigationController(rootViewController: UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
            
        }else{
            navigationController = NavigationController(rootViewController: UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!)
            window?.rootViewController = navigationController
                    window?.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//        CoreDataManager.shared.save()
    }


}

