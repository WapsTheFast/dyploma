//
//  TeacherViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 20.12.22.
//

import UIKit
import CoreData

class TeacherViewController: UICollectionViewController {
    
    private let reuseIdentifier = "groupCell"
    
    var teacherInfo : Teacher!
    var groups : [Group]!
    var menu : UIMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureMenu()
        configureNavigationBar()
    }
    
    override func loadView() {
        super.loadView()
        setupGroups()
    }
    
    func setupGroups(){
        let groupSet = teacherInfo.groups?.mutableCopy() as? NSSet
        groups = groupSet?.allObjects as? [Group]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teacherInfo.groups?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->GroupCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! GroupCollectionViewCell
        cell.groupCellView.backgroundColor = groups[indexPath.row].color ?? UIColor.secondarySystemBackground
        //        let alertColor = UIAlertController(title: "color", message: String(describing: groups[indexPath.row].color), preferredStyle: .alert)
        //        alertColor.addAction(UIAlertAction(title: "ok", style: .cancel))
        //        self.present(alertColor, animated: true)
        cell.groupCellView.layer.cornerRadius = 5
        cell.groupText.text = groups[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? GroupTabBarViewController
        vc?.group = groups[indexPath.row]
        vc?.teacher = teacherInfo
        self.pushToNavigationController(vc!)
    }
    
}

extension TeacherViewController{
    
    func configureNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addGroupButtonAction))
        self.navigationItem.rightBarButtonItem?.menu = menu
        self.navigationItem.title = teacherInfo.name
    }
    
    func configureMenu(){
        let createNewGroup = UIAction(title: "создать новую группу", image: UIImage(systemName: "person.badge.plus")) { [weak self] (action) in
            self?.addGroupButtonAction(UIBarButtonItem())
        }
        let addExistingGroup = UIAction(title: "добавить существующую группу", image: UIImage(systemName: "person.line.dotted.person.fill")) { [weak self] (action) in
            self?.addExistingGroupButtonAction(AnyObject.self)
        }
        menu = UIMenu(title: "взаимодействие с группами", options: .displayInline, children: [createNewGroup , addExistingGroup])
    }
    
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
    
    func addExistingGroupButtonAction(_ sender : Any){
        let alert = UIAlertController(title: "Connect to",
                                      message: "input invite code:",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
            let inviteCodeTextField = alert.textFields![0] as UITextField
            connectToGroup(inviteCode: inviteCodeTextField.text ?? "")
            self.collectionView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addTextField{
            (textField) in
            textField.placeholder = "invite code"
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
    
    func connectToGroup(inviteCode : String){
        var flag = true
        let groups = CoreDataManager.shared.fetchGroups()
        for group in groups{
            if group.inviteCode == Int(inviteCode) ?? 0{
                flag = false
                var flag2 = true
                for selfGroup in self.groups{
                    if selfGroup == group{
                        flag2 = false
                        let alert = UIAlertController(title: "Nope", message: "this group already added < try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .cancel))
                        self.present(alert , animated: true)}
                }
                if flag2{
                    if let group = group as Group?,
                       var teacherGroup = group.teachers?.mutableCopy() as? NSSet{
                        teacherGroup = teacherGroup.addingObjects(from: [teacherInfo!]) as NSSet
                        teacherInfo.groups = (teacherInfo.groups?.addingObjects(from: [group]) ?? []) as NSSet
                        group.teachers = teacherGroup
                        self.groups.append(group)
                        CoreDataManager.shared.save()
                    }
                }}
        }
        if flag{
            let alert = UIAlertController(title: "Nope", message: "there is no group with this invite code< try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
            self.present(alert, animated: true)}
    }
    
}

extension TeacherViewController : UICollectionViewDelegateFlowLayout{
    func configureLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        
    }
    
}
