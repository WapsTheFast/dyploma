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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentationControl: UISegmentedControl!
    @IBOutlet weak var rolePopUpButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var registerFormView: UIView!
    @IBOutlet weak var registerFormStackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextFieldRegistration: UITextField!
    @IBOutlet weak var inviteCodeTextField: UITextField!
    @IBOutlet weak var passwordTextFieldRegistration: UITextField!
    
    var roleType : roleType = .Student
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupPopUpButton()
        closeKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDataBase()
    }
    
    func initDataBase(){
        //CoreDataManager.shared.deleteAll(entity: .Teacher)
        //CoreDataManager.shared.deleteAll(entity: .Group)
        //CoreDataManager.shared.deleteAll(entity: .User)
        //CoreDataManager.shared.deleteAll(entity: .Student)
        //let group = CoreDataManager.shared.createGroup(name: "44", course: "4", teachers : [], students : [])
        //CoreDataManager.shared.createTeacher(name: "teacherMGKCT", login: "testTeacher", password: "password", groups: [group])
        //CoreDataManager.shared.createStudent(name: "studentMGKCT", login: "testStudent", password: "password", group: group)
        //CoreDataManager.shared.createStudent(name: "studentMGKCT2", login: "testStudent2", password: "password", group: group)
        users = CoreDataManager.shared.fetchUsers()
        teachers = CoreDataManager.shared.fetchTeachers()
        students = CoreDataManager.shared.fetchStudents()
        groups = CoreDataManager.shared.fetchGroups()
        lectures = CoreDataManager.shared.fetchLectures()
    }
    
    func closeKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupPopUpButton() {
        let studentPopUpButtonClosure = { [weak self] (action: UIAction) in
            self?.roleType = .Student
            self?.inviteCodeTextField.isHidden = false
        }
        let teacherPopUpButtonClosure = { [weak self] (action: UIAction) in
            self?.roleType = .Teacher
            self?.inviteCodeTextField.isHidden = true
        }
        
        rolePopUpButton.menu = UIMenu(children: [
            UIAction(title: "Student", handler: studentPopUpButtonClosure),
            UIAction(title: "Teacher", handler: teacherPopUpButtonClosure)
        ])
        rolePopUpButton.showsMenuAsPrimaryAction = true
    }
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension LoginViewController{
    
    @IBAction func signInButtonAction(_ sender : Any){
        let authCheck = auth(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        if authCheck.0{
            if let teacher = authCheck.1?.teacher{
                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! TeacherViewController
                vc.teacherInfo = teacher
                updateRootViewController(vc)
            }
            if let student = authCheck.1?.student{
                let storyboard = UIStoryboard(name: "Student", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! StudentLecturesTableViewController
                vc.student = student
                updateRootViewController(vc)
            }
        }
        else{
            let alert = UIAlertController(title: "Ошибка", message: "Войти не удалось, такого пользователя не найдено. Попробуйте зарегистрироваться", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Регистрация", style: .default){[weak self] _ in
                self?.segmentationControl.selectedSegmentIndex = 0
                self?.segmentControlClick(AnyObject.self)
            })
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            self.present(alert, animated: true)
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
    
    func registerUser(login : String, password : String, role : roleType, inviteCode : String, name : String ){
        if roleType == .Student{
            var flag = true
            for group in groups{
                if group.inviteCode == Int(inviteCode) ?? 0{
                    flag = false
                    students.append(CoreDataManager.shared.createStudent(name: name, login: login, password: password, group: group))
                    CoreDataManager.shared.save()
                    segmentationControl.selectedSegmentIndex = 1
                    segmentControlClick(AnyObject.self)
                }
            }
            if flag{
                self.present(UIAlertController(title: "Nope", message: "there is no group with this invite code< try again", preferredStyle: .alert), animated: true)}
        }
        else if roleType == .Teacher{
            teachers.append(CoreDataManager.shared.createTeacher(name: name, login: login, password: password, groups: []))
            CoreDataManager.shared.save()
            segmentationControl.selectedSegmentIndex = 1
            segmentControlClick(AnyObject.self)
        }
        //initDataBase()
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
        registerUser(login: loginTextFieldRegistration.text ?? "", password: passwordTextFieldRegistration.text ?? "", role: roleType , inviteCode: inviteCodeTextField.text ?? "", name: nameTextField.text ?? "")
    }
    
}
