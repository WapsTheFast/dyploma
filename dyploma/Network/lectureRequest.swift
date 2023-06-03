//
//  lectureRequest.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 3.06.23.
//

import Foundation
import UIKit

struct lectureRequest{
    
    let baseURL = Constants.baseURL
    let resourceURL: URL
    
    init(){
        guard let resourceURL = URL(string: baseURL) else{
           fatalError("Failed to convert baseURL to a URL")
        }
        self.resourceURL = resourceURL.appendingPathComponent(Endpoints.lectures)
    }
    
    func mark(code: String, completion: @escaping (Result<[StudentsOnLecture], ResourceRequestError>)->Void){
        guard let token = Auth().token else {
            Auth().logout{
                guard let applicationDelegate =
                  UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let rootController =
                  UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
                applicationDelegate.window?.rootViewController = rootController
            }
          return
        }
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.url?.append(path: "\(Endpoints.mark)/\(code)")
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){
            data, _, error in
            guard let jsonData = data else{
                completion(.failure(.noData))
                return
            }
            do {
                print(String(describing: jsonData))
                let resources = try JSONDecoder().decode([StudentsOnLecture].self, from: jsonData)
                completion(.success(resources))
            } catch {
                do {
                    print(String(describing: jsonData))
                    let resource = try JSONDecoder().decode(StudentsOnLecture.self, from: jsonData)
                    completion(.success([resource]))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }
        dataTask.resume()
    }
}
