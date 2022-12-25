//
//  TeacherLectionGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherLectionGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    var group : Group!
    
    var teacher : Teacher!
    
    var delegate: GroupTabBarViewController!
    
    let reuseIdentifier = "teacherLecture"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.delegate.navigationItem.title = group.name
        //self.navigationItem.title = group.name
        self.delegate.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addLectureButtonAction))
        //self.present(UIAlertController(title: group.name, message: group.course, preferredStyle: .actionSheet), animated: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lectures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let theme = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
    
        theme.text = lectures[indexPath.row].theme
        date.text = String(describing: lectures[indexPath.row].date!)

        return cell
    }
    
    @objc func addLectureButtonAction(_ sender : UIBarButtonItem){
        let alert = UIAlertController(title: "New Lecture",
                                        message: "Add a new Lecture",
                                        preferredStyle: .alert)
          
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
                let themeTextField = alert.textFields![0] as UITextField
                //let TextField = alert.textFields![1] as UITextField
            
            //saveGroup(name: numberTextField.text ?? "", course: courseTextField.text ?? "")
            saveLecture(theme: themeTextField.text ?? "")
            
            self.tableView.reloadData()
            })
          
            let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel)
          
        alert.addTextField{
            (textField) in
                textField.placeholder = "lecture theme"
        }
//        alert.addTextField{
//            (textField) in
//                textField.placeholder = "course number"
//        }
          
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
          
          present(alert, animated: true)
    }
    
    func saveLecture(theme : String){
        let lecture = CoreDataManager.shared.createLecture(theme: theme, matherials: nil, status: .planned, group: group, teacher: teacher, date : Date())
        CoreDataManager.shared.save()
        lectures.append(lecture)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
