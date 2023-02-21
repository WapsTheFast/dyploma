//
//  TeacherLectionGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherLectionGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    let reuseIdentifier = "teacherLecture"
    
    var group : Group!
    var teacher : Teacher!
    var lecturesForGroup : [Lecture] = []
    var delegate: GroupTabBarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override func loadView() {
        super.loadView()
        updateLecturesForGroup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate.navigationItem.title = group.name 
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecturesForGroup.count
    }
    
    func updateLecturesForGroup(){
        lecturesForGroup = lectures.filter{ $0.group == group }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        let theme = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        
        theme.text = lecturesForGroup[indexPath.row].theme
        date.text = lecturesForGroup[indexPath.row].date?.formatted(date: .long, time: .omitted)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LectureTeacher", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LectureTeacherTableViewController
        vc.lecture = lecturesForGroup[indexPath.row]
        self.pushToNavigationController(vc)
    }
    
}
extension TeacherLectionGroupTableViewController{
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.delegate.navigationItem.title = group.name
        self.delegate.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addLectureButtonAction))
    }
    
    @objc func addLectureButtonAction(_ sender : UIBarButtonItem){
        let alert = UIAlertController(title: "New Lecture",
                                      message: "Add a new Lecture",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
            let themeTextField = alert.textFields![0] as UITextField
            saveLecture(theme: themeTextField.text ?? "")
            updateLecturesForGroup()
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField{(textField) in
            textField.placeholder = "lecture theme"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func saveLecture(theme : String){
        let lecture = CoreDataManager.shared.createLecture(theme: theme, matherials: nil, state: .planned, group: group, teacher: teacher, date : Date())
        CoreDataManager.shared.save()
        lectures.append(lecture)
        
    }
    
}
