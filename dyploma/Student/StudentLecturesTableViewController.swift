//
//  StudentLecturesTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 26.12.22.
//

import UIKit

class StudentLecturesTableViewController: UITableViewController {
    
    var student : Student! = nil
    
    let reuseIdentifier = "studentLectures"
    
    var lecturesForGroup : [Lecture] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override func loadView() {
        super.loadView()
        updateLecturesForGroup()
    }
    
    func updateLecturesForGroup(){
        lecturesForGroup = lectures.filter{ $0.group == student.group }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecturesForGroup.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let theme = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        
        theme.text = lecturesForGroup[indexPath.row].theme
        date.text = lecturesForGroup[indexPath.row].date?.formatted(date: .long, time: .omitted)
        
        //print(isStudentBeenOnLecture(with: indexPath))
        if isStudentBeenOnLecture(with: indexPath){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Input lecture code", message: "сюда вводить код лекции шоб отметилось", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let checkAction = UIAlertAction(title: "Check", style: .default){
        [unowned self] action  in
            let codeTextField = alert.textFields![0] as UITextField
            checkLecture(with : codeTextField.text ?? "",for : indexPath)
            self.tableView.reloadData()
        }
        alert.addAction(checkAction)
        alert.addTextField()
        self.present(alert, animated: true)
    }
}

extension StudentLecturesTableViewController{
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = student.name
    }
    
    func checkLecture(with code : String, for indexPath : IndexPath){
        if String(describing: lecturesForGroup[indexPath.row].code) == code{
            lecturesForGroup[indexPath.row].students = lecturesForGroup[indexPath.row].students?.addingObjects(from: [student!]) as NSSet?
            CoreDataManager.shared.save()
        }
    }
    
    func isStudentBeenOnLecture(with indexPath : IndexPath)->Bool{
        if lecturesForGroup[indexPath.row].students!.contains(student!){
            return true
        }
        return false
    }
}
