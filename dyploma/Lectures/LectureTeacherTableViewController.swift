//
//  LectureTeacherTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 13.02.23.
//

import UIKit

class LectureTeacherTableViewController: UITableViewController {
    
    @IBOutlet weak var generateCodeButton: UIButton!
    
    var menu : UIMenu!
    
    var lecture : Lecture!
    var students : [User] = []
    
    var studentsOnLecture : [StudentsOnLecture] = []
    
    var studentsRequest : ResourceRequest<User>!
    var studentsOnLectureRequest : ResourceRequest<StudentsOnLecture>!
    
    let reuseIdentifier = "StudentRow"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRequest()
        configureMenu()
        configureNavigationController()
        configureRefreshControl()
        closeKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(sender: self.refreshControl!)
    }
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: reuseIdentifier, with: indexPath)
    }
    
    func configureCell(for reuseId : String, with indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        let studentName = cell.viewWithTag(1) as! UILabel
        let state = cell.viewWithTag(2) as! UILabel
        
        studentName.text = students[indexPath.row].name
        if let stateOnLecture = studentsOnLecture.first(where: {$0.user.id == students[indexPath.row].id!}){
            switch stateOnLecture.state{
            case .notOnLecture:
                state.text = "Н"
            case .late:
                state.text = "О"
            case .onLecture:
                state.text = " "
            }
        }
        return cell
    }
    
    
    
    @objc func refresh(sender : UIRefreshControl){
        studentsRequest.getAll{
            [weak self] studentResult in
            switch studentResult{
            case .success(let students):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.students = students
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting students", on: self)
            }
        }
        studentsOnLectureRequest.getAll{
            [weak self] studentResult in
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
            switch studentResult{
            case .success(let studentsOnLecture):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.studentsOnLecture = studentsOnLecture
                    self.tableView.reloadData()
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting students on lecture", on: self)
            }
        }
    }
}

// MARK: Segue
extension LectureTeacherTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "toQrCode":
            prepareQrCodeScreen(segue)
        default:
            break
        }
    }
    
    func prepareQrCodeScreen(_ segue: UIStoryboardSegue){
        guard let destinationVC = segue.destination as? QRCodeViewController else{
            return
        }
        destinationVC.lectureID = self.lecture.id
    }
}

// MARK: configure methods

extension LectureTeacherTableViewController{
    func configureMenu(){
        let setLectureDone = UIAction(title: "Лекция завершена", image: UIImage(systemName: "checkmark")) { [weak self] (action) in
            self?.lecture.state = .done
        }
        let setLectureNow = UIAction(title: "Лекция идёт сейчас", image: UIImage(systemName: "arrow.down.to.line")) { [weak self] (action) in
            self?.lecture.state = .onGoing
        }
        let setLectureLater = UIAction(title: "Лекция будет потом", image: UIImage(systemName: "clock")) { [weak self] (action) in
            self?.lecture.state = .planned
        }
        menu = UIMenu(title: "взаимодействие с лекцией", options: .displayInline, children: [setLectureDone , setLectureNow, setLectureLater])
    }
    
    func configureNavigationController(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .actions, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.menu = menu
    }
    
    func configureRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    func configureRequest(){
        let request = ResourceRequest<User>(resourcePath: "\(Endpoints.lectures)\(Endpoints.getStudentsForLecture)/\(lecture.id!)")
        self.studentsRequest = request
        let studentsOnLectureRequest = ResourceRequest<StudentsOnLecture>(resourcePath: "\(Endpoints.lectures)\(Endpoints.checkStudents)/\(lecture.id!)")
        self.studentsOnLectureRequest = studentsOnLectureRequest
    }
    
    func closeKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

}

extension LectureTeacherTableViewController{
    
    @IBAction func generateCodeButtonAction(_ sender : UIButton){
        
    }
}
