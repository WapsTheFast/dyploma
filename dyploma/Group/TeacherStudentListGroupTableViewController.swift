//
//  TeacherStudentListGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherStudentListGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    var group : Group!
    var teacher : User!
    
    var delegate: GroupTabBarViewController!
    var students : [User]!
    
    var studentsRequest : ResourceRequest<User>!
    
    var reuseIdentifier = "studentName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRequest()
        configureRefreshControl()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        refresh(sender: self.refreshControl!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let text = cell.viewWithTag(1) as! UILabel
        text.text = "\(indexPath.row+1).\t \(String(describing: students[indexPath.row].name)) \(String(describing: students[indexPath.row].surname))"
        return cell
    }
    
    @objc func refresh(sender : UIRefreshControl){
        studentsRequest.getAll{
            [weak self] studentsResult in
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
            switch studentsResult{
            case .success(let students):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.students = students
                    configureNavBar()
                    self.tableView.reloadData()
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting students", on: self)
            
            }
        }
    }

}

//MARK: Configure
extension TeacherStudentListGroupTableViewController{
    func configureNavBar(){
        self.delegate.navigationItem.title = String(describing:students?.count ?? 0)
    }
    
    func configureRequest(){
        let request = ResourceRequest<User>(resourcePath: "\(Endpoints.groups)\(Endpoints.students)/\(self.group.id!)")
        self.studentsRequest = request
    }
    
    func configureRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
}
