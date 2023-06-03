//
//  StudentLecturesTableViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 26.12.22.
//

import UIKit

class StudentLecturesTableViewController: UITableViewController {
    
    var student : User!
    
    let reuseIdentifier = "studentLectures"
    
    var lectures : [Lecture] = []
    var onLecturesState : [StudentsOnLecture] = []
    
    let lecturesRequest = ResourceRequest<Lecture>(resourcePath: Endpoints.lectures + Endpoints.forStudent)
    let onLectureStateRequest = ResourceRequest<StudentsOnLecture>(resourcePath: Endpoints.lectures + Endpoints.checkForStudent)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(sender: self.refreshControl!)
    }

    
    @objc func refresh(sender : UIRefreshControl){
        lecturesRequest.getAll{
            [weak self] lectureResult in
            switch lectureResult{
            case .success(let lectures):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.lectures = lectures
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting lectures", on: self)
            }
        }
        onLectureStateRequest.getAll{
            [weak self] onLectureStateResult in
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
            switch onLectureStateResult{
            case .success(let onLecturesState):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.onLecturesState = onLecturesState
                    self.tableView.reloadData()
                }
            case .failure:
                ErrorPresenter.showError(message: "Error with getting students on lecture", on: self)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let theme = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        
        theme.text = lectures[indexPath.row].name
        date.text = lectures[indexPath.row].dateValue?.formatted(date: .long, time: .omitted)
        
        if isStudentBeenOnLecture(with: indexPath){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scanner = ScannerQRViewController()
        scanner.delegate = self
        self.pushToNavigationController(scanner)
    }
}

// MARK: Configure

extension StudentLecturesTableViewController{
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = student.name + " " + student.surname
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left.circle.fill"), style: .plain, target: self, action: #selector(logOutButtonAction))
    }
    
    func configureRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
}

extension StudentLecturesTableViewController{
    
    func isStudentBeenOnLecture(with indexPath : IndexPath)->Bool{
        if let lecture = lectures[indexPath.row].id{
            if onLecturesState.first(where: {$0.lecture.id == lecture})?.state != .notOnLecture {
                return true
            }
        }
        return false
    }
    
    @objc func logOutButtonAction(_ sender : UIBarButtonItem){
        Auth().logout {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! LoginViewController
            self.updateRootViewController(vc)
        }
        
    }
}
