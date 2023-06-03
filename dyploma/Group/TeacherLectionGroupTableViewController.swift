//
//  TeacherLectionGroupTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 23.12.22.
//

import UIKit

class TeacherLectionGroupTableViewController: UITableViewController, GroupTabBarProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let reuseIdentifier = "teacherLecture"
    
    var menu : UIMenu!
    
    var filterState : Int16 = 0
    
    var group : Group!
    var teacher : User!
    var lectures : [Lecture] = []
    var lecturesFiltered : [Lecture] = []
    var delegate: GroupTabBarViewController!
    
    var lecturesRequest : ResourceRequest<Lecture>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRequest()
        configureMenu()
        configureSearchBar()
        configureNavBar()
        configureRefreshControl()
        //closeKeyboard()
        
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate.navigationItem.title = group.name
        refresh(sender: self.refreshControl!)
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBarIsEmpty() || self.filterState != 0{
            return lecturesFiltered.count
        }else{
            return lectures.count
        }
        
    }
    
    func closeKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let theme = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        let status = cell.viewWithTag(3) as! UILabel
        if !searchBarIsEmpty(){
            theme.text = lecturesFiltered[indexPath.row].name
            date.text = lecturesFiltered[indexPath.row].dateValue?.formatted(date: .long, time: .omitted)
        }else{
            theme.text = lectures[indexPath.row].name
            date.text = lectures[indexPath.row].dateValue?.formatted(date: .long, time: .omitted)
        }
        
        switch lectures[indexPath.row].state{
        case .done:
            status.text = "☑️"
        case .onGoing:
            status.text = "⬇️"
        case .planned:
            status.text = "🕐"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LectureTeacher", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LectureTeacherTableViewController
        vc.lecture = lectures[indexPath.row]
        self.pushToNavigationController(vc)
    }
    
}

//MARK: Configure
extension TeacherLectionGroupTableViewController{
    
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.delegate.navigationItem.title = group.name
        self.delegate.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addLectureButtonAction))
    }
    
    func configureSearchBar(){
        searchBar.delegate = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var toolBarButtons = [flexibleSpace]
        let barButtons = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        barButtons.menu = menu
        toolBarButtons.append(contentsOf: [barButtons])
        toolBar.items = toolBarButtons
        searchBar.inputAccessoryView = toolBar
    }
    
    func configureMenu(){
        let setLectureDone = UIAction(title: "Лекция завершена", image: UIImage(systemName: "checkmark")) { [weak self] (action) in
            self?.filterState = 1
            self?.filterLectures(theme: self?.searchBar.text?.lowercased() ?? "", status: self?.filterState ?? 0)
            self?.tableView.reloadData()
        }
        let setLectureNow = UIAction(title: "Лекция идёт сейчас", image: UIImage(systemName: "arrow.down.to.line")) { [weak self] (action) in
            self?.filterState = 2
            self?.filterLectures(theme: self?.searchBar.text?.lowercased() ?? "", status: self?.filterState ?? 0)
            self?.tableView.reloadData()
        }
        let setLectureLater = UIAction(title: "Лекция будет потом", image: UIImage(systemName: "clock")) { [weak self] (action) in
            self?.filterState = 3
            self?.filterLectures(theme: self?.searchBar.text?.lowercased() ?? "", status: self?.filterState ?? 0)
            self?.tableView.reloadData()
        }
        let setDefault = UIAction(title: "Все лекции", image: UIImage(systemName: "arrowshape.turn.up.left.2")) { [weak self] (action) in
            self?.filterState = 0
            self?.filterLectures(theme: self?.searchBar.text?.lowercased() ?? "", status: self?.filterState ?? 0)
            self?.tableView.reloadData()
        }
        menu = UIMenu(title: "взаимодействие с лекцией", options: .displayInline, children: [setLectureDone , setLectureNow, setLectureLater, setDefault])
    }
    
    func configureRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    func configureRequest(){
        let request = ResourceRequest<Lecture>(resourcePath: "\(Endpoints.lectures)/\(self.group.id!)")
        self.lecturesRequest = request
    }
    
    
    
}

extension TeacherLectionGroupTableViewController{
    @objc func addLectureButtonAction(_ sender : UIBarButtonItem){
        let alert = UIAlertController(title: "Новая лекция",
                                      message: "Создать новую лекцию",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Создать", style: UIAlertAction.Style.default, handler: { [unowned self] action  in
            let themeTextField = alert.textFields![0] as UITextField
            saveLecture(theme: themeTextField.text ?? "")
            refresh(sender: self.refreshControl!)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addTextField{(textField) in
            textField.placeholder = "тема лекции"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func refresh(sender : UIRefreshControl){
        lecturesRequest.getAll{
            [weak self] lecturesResult in
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
            switch lecturesResult{
            case .success(let lectures):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.lectures = lectures
                    self.tableView.reloadData()
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting lectures", on: self)
            
            }
        }
    }
    
    func saveLecture(theme : String){
//        let lecture = CoreDataManager.shared.createLecture(theme: theme, matherials: nil, state: .planned, group: group, teacher: teacher, date : Date())
//        CoreDataManager.shared.save()
//        lectures.append(lecture)
        
    }
}

extension TeacherLectionGroupTableViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterLectures(theme: self.searchBar.text?.lowercased() ?? "", status: self.filterState )
            
            //searching = true
            tableView.reloadData()
            
        }

        
    func filterLectures(theme : String, status : Int16){
//        if status == 0{
//            lecturesFiltered = lecturesForGroup.filter({( lecture : Lecture) -> Bool in
//                return lecture.theme?.lowercased().contains(theme) ?? false
//            })
//        }else if theme == ""{
//            lecturesFiltered = lecturesForGroup.filter({( lecture : Lecture) -> Bool in
//                return lecture.state == status
//            })
//        }else{
//            lecturesFiltered = lecturesForGroup.filter({( lecture : Lecture) -> Bool in
//                return lecture.theme?.lowercased().contains(theme) ?? false && lecture.state == status
//            })
//        }
    }
    
        func searchBarIsEmpty() -> Bool {
            return searchBar.text?.isEmpty ?? true
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
