//
//  TeacherSettingsGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherSettingsGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    var group : Group!
    
    var teacher : Teacher!
    
    var delegate: GroupTabBarViewController!

    @IBOutlet weak var nameLabel: UILabel!
        
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    @IBOutlet weak var createInviteCodeButton: UIButton!
    
    @IBOutlet weak var groupColorWell: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate.navigationItem.title = ""
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                let alertName = UIAlertController(title: "Изменить номер группы", message: "текущий номер группы: \(String(describing: group.name))", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "сохранить", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
                    let nameTextField = alertName.textFields![0] as UITextField
                    saveGroup(name: nameTextField.text ?? "")
                    self.tableView.reloadData()
                })
                alertName.addTextField(){(textField) in
                    textField.placeholder = "lecture theme"
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                alertName.addAction(saveAction)
                alertName.addAction(cancelAction)
                self.present(alertName, animated: true)
            case 1:
                let alertCourse = UIAlertController(title: "course", message: "course", preferredStyle: .alert)
                alertCourse.addAction(UIAlertAction(title: "ok", style: .cancel))
                self.present(alertCourse, animated: true)
            case 2:
                break
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                createInviteCodeButtonAction(AnyObject.self)
            default:
                break
            }
        default:
            break
        }
    }
    
    
    
    func createInviteCode(group : Group){
        group.inviteCode = Int64.random(in: 100000...999999)
        CoreDataManager.shared.save()
    }
}

extension TeacherSettingsGroupTableViewController{
    func createInviteCodeButtonAction(_ sender : Any){
        createInviteCode(group: self.group)
        inviteCodeLabel.text = group.inviteCode.description
    }
    
    @objc func colorWellChanged(_ sender: Any) {
        self.group.color = groupColorWell.selectedColor
        CoreDataManager.shared.save()
        }
    
    func configureSettings(){
        nameLabel.text = group.name
        courseLabel.text = group.course
        if let inviteCode = group.inviteCode as Int64?{
            inviteCodeLabel.text = String(describing: inviteCode)
        }
//        else{
//            inviteCodeLabel.text = "not created"
//        }
        groupColorWell.selectedColor = group.color
        groupColorWell.addTarget(self, action: #selector(colorWellChanged(_ : )), for: .valueChanged)
    }
    
}

extension TeacherSettingsGroupTableViewController{
    func saveGroup(name : String){
        group.name = name
        CoreDataManager.shared.save()
    }
}
