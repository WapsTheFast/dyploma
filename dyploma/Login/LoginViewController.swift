//
//  ViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import UIKit
import CoreData

enum roleType : Int{
    case Student = 0
    case Teacher = 1
}

class LoginViewController: UIViewController {
    
//    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentationControl: UISegmentedControl!
    @IBOutlet weak var rolePopUpButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var registerFormView: UIView!
    @IBOutlet weak var registerFormStackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginTextFieldRegistration: UITextField!
    @IBOutlet weak var inviteCodeTextField: UITextField!
    @IBOutlet weak var passwordTextFieldRegistration: UITextField!
    
    var roleType : roleType = .Student
    
    var usersForTest : [User] = []
    
    let userRequest = ResourceRequest<User>(resourcePath: "\(Endpoints.users)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configurePopUpButton()
        closeKeyboard()     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initDataBase(){
//        CoreDataManager.shared.deleteAll(entity: .Teacher)
//        CoreDataManager.shared.deleteAll(entity: .Group)
//        CoreDataManager.shared.deleteAll(entity: .User)
//        CoreDataManager.shared.deleteAll(entity: .Student)
//        CoreDataManager.shared.deleteAll(entity: .Lecture)
        //let group = CoreDataManager.shared.createGroup(name: "44", course: "4", teachers : [], students : [])
        //CoreDataManager.shared.createTeacher(name: "teacherMGKCT", login: "testTeacher", password: "password", groups: [group])
        //CoreDataManager.shared.createStudent(name: "studentMGKCT", login: "testStudent", password: "password", group: group)
        //CoreDataManager.shared.createStudent(name: "studentMGKCT2", login: "testStudent2", password: "password", group: group)
//        users = CoreDataManager.shared.fetchUsers()
//        teachers = CoreDataManager.shared.fetchTeachers()
//        students = CoreDataManager.shared.fetchStudents()
//        groups = CoreDataManager.shared.fetchGroups()
//        lectures = CoreDataManager.shared.fetchLectures()
    }
}

extension LoginViewController{
    func closeKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func configurePopUpButton() {
        let studentPopUpButtonClosure = { [weak self] (action: UIAction) in
            self?.roleType = .Student
            self?.inviteCodeTextField.isHidden = false
        }
        let teacherPopUpButtonClosure = { [weak self] (action: UIAction) in
            self?.roleType = .Teacher
            self?.inviteCodeTextField.isHidden = true
        }
        
        rolePopUpButton.menu = UIMenu(children: [
            UIAction(title: "Учащийся", handler: studentPopUpButtonClosure),
            UIAction(title: "Преподаватель", handler: teacherPopUpButtonClosure)
        ])
        rolePopUpButton.showsMenuAsPrimaryAction = true
    }
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension LoginViewController{
    
    @IBAction func signInButtonAction(_ sender : Any){
        Auth().logout{}
        Auth().login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? ""){
            result in
            switch result{
            case .success:
                DispatchQueue.main.async {
                    Auth().getUserInfo(){
                        result, user in
                        switch result{
                        case .success:
                            DispatchQueue.main.async {
                                if user?.role == .teacher{
                                    let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                                    let vc = storyboard.instantiateInitialViewController() as! TeacherViewController
                                    vc.teacher = user
                                    self.updateRootViewController(vc)
                                }else if user?.role == .student{
                                    let storyboard = UIStoryboard(name: "Student", bundle: nil)
                                    let vc = storyboard.instantiateInitialViewController() as! StudentLecturesTableViewController
                                    vc.student = user
                                    self.updateRootViewController(vc)
                                }
                            }
                        case .failure:
                            let message = "Could not login. Check your credentials and try again"
                            ErrorPresenter.showError(message: message, on: self)
                        }
                    }
                }
            case .failure:
                let message = "Could not login. Check your credentials and try again"
                ErrorPresenter.showError(message: message, on: self)
            }
        }
    }
    
    func registerUser(name : String, surname : String, email : String, username : String, password : String, role : roleType, inviteCode : String){
        var role : Role
        if roleType == .Student{
            role = .student
        }else{
            role = .teacher
        }
        Auth().createUser(name: name, surname: surname, role: role, email: email, username: username, password: password){
            AuthResult, user  in
            switch AuthResult{
            case .failure:
                ErrorPresenter.showError(message: "Error with creating user", on: self)
            case .success:
                if role == .student{
                    DispatchQueue.main.async {
                        Auth().login(username: user!.username , password: password){
                            AuthResult in
                            switch AuthResult{
                            case .success:
                                DispatchQueue.main.async {
                                    Auth().attachUser(inviteCode: inviteCode){
                                        AuthResult in
                                        switch AuthResult{
                                        case .success:
                                            DispatchQueue.main.async {
                                                self.segmentationControl.selectedSegmentIndex = 1
                                                self.segmentControlClick(AnyObject.self)
                                            }
                                        case .failure:
                                            ErrorPresenter.showError(message: "Error with attaching user to group", on: self)
                                        }
                                    }
                                }
                            case .failure:
                                ErrorPresenter.showError(message: "Error with creating user", on: self)
                            }
                        }
                    }
                    
                }
                else if role == .teacher{
                    DispatchQueue.main.async {
                        self.segmentationControl.selectedSegmentIndex = 1
                        self.segmentControlClick(AnyObject.self)
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func segmentControlClick(_ sender : Any){
        switch segmentationControl.selectedSegmentIndex{
        case 0:
            loginFormView.isHidden = true
            registerFormView.isHidden = false
        case 1:
            loginFormView.isHidden = false
            registerFormView.isHidden = true
        default:
            break
        }
        
        
    }
    
    @IBAction func registerButtonAction(_ sender : Any){
        guard let name = nameTextField.text else{
            ErrorPresenter.showError(message: "Введите имя пользователя!", on: self)
            return
        }
        guard let surname = surnameTextField.text else{
            ErrorPresenter.showError(message: "Введите фамилию пользователя!", on: self)
            return
        }
        guard let email = emailTextField.text else{
            ErrorPresenter.showError(message: "Введите адресс электронной почты пользователя!", on: self)
            return
        }
        guard let username = loginTextFieldRegistration.text else{
            ErrorPresenter.showError(message: "Введите псевдоним пользователя!", on: self)
            return
        }
        guard let password = passwordTextFieldRegistration.text else{
            ErrorPresenter.showError(message: "Введите пароль пользователя!", on: self)
            return
        }
        guard let inviteCode = inviteCodeTextField.text else{
            ErrorPresenter.showError(message: "Введите код приглашения пользователя!", on: self)
            return
        }
        
        registerUser(name: name, surname: surname, email: email , username: username, password: password, role: roleType, inviteCode : inviteCode)
    }
    
}
