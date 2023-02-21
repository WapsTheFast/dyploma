//
//  TeacherStudentListGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherStudentListGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    var group : Group!
    var teacher : Teacher!
    
    var delegate: GroupTabBarViewController!
    var students : [Student]!
    
    let reuseIdentifier = "studentName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        super.loadView()
        setupStudents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    func setupStudents(){
        let studentSet = group.students?.mutableCopy() as? NSSet
        students = studentSet?.allObjects as? [Student]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.students?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let text = cell.viewWithTag(1) as! UILabel
        text.text = "\(indexPath.row+1).\t \(String(describing: students[indexPath.row].name!))"
        return cell
    }

}

extension TeacherStudentListGroupTableViewController{
    func configureNavBar(){
        self.delegate.navigationItem.title = String(describing:group.students?.count ?? 0)
    }
}
