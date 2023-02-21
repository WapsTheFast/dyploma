//
//  LectureTeacherTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 13.02.23.
//

import UIKit

class LectureTeacherTableViewController: UITableViewController {
    
    @IBOutlet weak var generateCodeButton: UIButton!
    
    var lecture : Lecture!
    
    var studentsInGroup : [Student] = []
    
    let reuseIdentifier = "StudentRow"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCodeButton()
        updateStudentsInGroup()
        
    }
    
    func updateStudentsInGroup(){
        studentsInGroup = students.filter{$0.group == lecture.group}
    }
    
    func configureCodeButton(){
        if let inviteCode = lecture.code as Int64?{
            //print(String(describing: inviteCode))
            if inviteCode == 0{
                generateCodeButton.setTitle("Create code", for: .normal)
            }else{
                generateCodeButton.setTitle(String(describing: inviteCode), for: .normal)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInGroup.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        let studentName = cell.viewWithTag(1) as! UILabel
        let state = cell.viewWithTag(2) as! UILabel
        
        studentName.text = studentsInGroup[indexPath.row].name
        if lecture.students!.contains(studentsInGroup[indexPath.row]){
            state.text = ""
        }else{
            state.text = "Н"
        }
        return cell
    }

}

extension LectureTeacherTableViewController{
    
    @IBAction func generateCodeButtonAction(_ sender : UIButton){
        lecture.code = Int64.random(in: 100000...999999)
        CoreDataManager.shared.save()
        configureCodeButton()
    }
}
