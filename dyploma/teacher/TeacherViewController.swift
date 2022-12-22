//
//  TeacherViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import UIKit
import CoreData

private let reuseIdentifier = "groupCell"

class TeacherViewController: UICollectionViewController {
    
    var teacherInfo : Teacher!
    var groups : [Group]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addGroupButtonAction))
        self.navigationItem.title = teacherInfo.name
        //self.collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    override func loadView() {
        super.loadView()
        let groupSet = teacherInfo.groups?.mutableCopy() as? NSSet
        groups = groupSet?.allObjects as? [Group]
    }

   

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teacherInfo.groups?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupCollectionViewCell
        
        cell.groupText.text = groups[indexPath.row].name
    
    
        return cell
    }

}

extension TeacherViewController{
    @objc func addGroupButtonAction(_ sender : UIBarButtonItem){
        let alert = UIAlertController(title: "New Name",
                                        message: "Add a new name",
                                        preferredStyle: .alert)
          
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
                let numberTextField = alert.textFields![0] as UITextField
                let courseTextField = alert.textFields![1] as UITextField
            
            saveGroup(name: numberTextField.text ?? "", course: courseTextField.text ?? "")
            
            
            self.collectionView.reloadData()
            })
          
            let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel)
          
        alert.addTextField{
            (textField) in
                textField.placeholder = "Group name"
        }
        alert.addTextField{
            (textField) in
                textField.placeholder = "course number"
        }
          
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
          
          present(alert, animated: true)
    }
    
    func saveGroup(name : String, course : String){
        let group = CoreDataManager.shared.createGroup(name: name, course: course, teachers: [teacherInfo], students: [])
        CoreDataManager.shared.save()
        groups.append(group)
          
    }
}
