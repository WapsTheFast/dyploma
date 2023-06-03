//
//  QRCodeViewController.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 25.04.23.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCode: UIImageView!
    
    var lectureID : UUID!
    
    var lectureRequest : ResourceRequest<Lecture>!
    
    var regenerateRequest : ResourceRequest<Lecture>!
    
    var lecture : Lecture!
  
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRequest()
    }
    
    // MARK: Functions
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 15, y: 15)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func makeRequest(){
        activityIndicator.startAnimating()
        lectureRequest.getAll{
            [weak self] lectureResult in
            switch lectureResult{
            case .success(let lecture):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.activityIndicator.stopAnimating()
                    self.lecture = lecture.first
                    configureImage()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    ErrorPresenter.showError(message: "Error with getting lecture", on: self)
                }
            }
        }
    }
    
    func regenerateCode(){
        activityIndicator.startAnimating()
        regenerateRequest.getAll{
            [weak self] regenerateResult in
            switch regenerateResult{
            case .success(let lecture):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else {return}
                    self.activityIndicator.stopAnimating()
                    self.lecture = lecture.first
                    configureImage()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    ErrorPresenter.showError(message: "Error with getting lecture", on: self)
                }
            
            }
        }
    }
}

// MARK: Actions

extension QRCodeViewController{
    @IBAction func shareButtonAction(_ sender: Any) {
        if let image = qrCode.image{
            let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(ac, animated: true)
        }
    }
    
    @IBAction func regenerateButtonAction(_ sender: Any){
        regenerateCode()
    }
}

// MARK: Configure

extension QRCodeViewController{
    func configureRequest(){
        let request = ResourceRequest<Lecture>(resourcePath: "\(Endpoints.lectures)\(Endpoints.one)/\(self.lectureID!)")
        self.lectureRequest = request
        let regenerateRequest = ResourceRequest<Lecture>(resourcePath: "\(Endpoints.lectures)\(Endpoints.regenerate)/\(self.lectureID!)")
        self.regenerateRequest = regenerateRequest
    }
    
    func configureActivityIndicator(){
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = qrCode.center
        activityIndicator.backgroundColor = UIColor.clear
        qrCode.addSubview(activityIndicator)
    }
    
    func configureImage(){
        qrCode.image = generateQRCode(from: "\(lecture.code!)")
    }
}
