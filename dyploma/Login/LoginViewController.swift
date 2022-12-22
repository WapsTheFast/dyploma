//
//  ViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        CoreDataManager.shared.deleteAll(entity: .Teacher)
//        CoreDataManager.shared.deleteAll(entity: .Group)
//        CoreDataManager.shared.deleteAll(entity: .User)
//        CoreDataManager.shared.deleteAll(entity: .Student)
//        let group = CoreDataManager.shared.createGroup(name: "44", course: "4", teachers : [], students : [])
//        CoreDataManager.shared.createTeacher(name: "teacherMGKCT", login: "testTeacher", password: "password", groups: [group])
//        CoreDataManager.shared.createStudent(name: "studentMGKCT", login: "testStudent", password: "password", group: group)
//        CoreDataManager.shared.createStudent(name: "studentMGKCT2", login: "testStudent2", password: "password", group: group)
            users = CoreDataManager.shared.fetchUsers()
            teachers = CoreDataManager.shared.fetchTeachers()
            students = CoreDataManager.shared.fetchStudents()
            groups = CoreDataManager.shared.fetchGroups()
        
    }}

extension LoginViewController{
    
    @IBAction func signInButtonAction(_ sender : Any){
        let authCheck = auth(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        if authCheck.0{
            if let user = authCheck.1?.teacher{
                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! TeacherViewController
                vc.teacherInfo = user
                updateRootViewController(vc)
            }
            //self.present(UIAlertController(title: "u signed", message: "\(authCheck.1?.name ?? "")", preferredStyle: .alert), animated: true)
        }
        
    }
    
    func auth(email : String, password : String)->(Bool, User?){
        for user in users{
            if user.login == email && user.password == password{
                return (true, user)
            }
        }
        return (false, nil)
    }
    
}
