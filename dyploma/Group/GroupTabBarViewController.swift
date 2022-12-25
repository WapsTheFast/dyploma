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
//        let storyboard = UIStoryboard(name: "Group", bundle: nil)
//        let lections = storyboard.instantiateViewController(withIdentifier: "lecturesTeacher") as? TeacherLectionGroupTableViewController
        //let lections = self.tabBarController?.viewControllers?[0] as? TeacherLectionGroupTableViewController
//
//        lections?.group = group
//        let studentsList = self.tabBarController?.viewControllers?[1] as? TeacherStudentListGroupTableViewController
//        studentsList?.group = group
//        let settings = self.tabBarController?.viewControllers?[2] as? TeacherSettingsGroupTableViewController
//        settings?.group = group
        //self.navigationItem.title = group.name
        //self.children[0]

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
