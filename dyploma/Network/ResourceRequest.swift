//
//  ResourceRequest.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//

import Foundation
import UIKit

struct ResourceRequest<ResourceType> where ResourceType: Codable{
    
    let baseURL = Constants.baseURL
    let resourceURL: URL
    
    init(resourcePath: String){
        guard let resourceURL = URL(string: baseURL) else{
           fatalError("Failed to convert baseURL to a URL")
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }
    
//    func getUserInfo(completion: @escaping (Result<[User], ResourceRequestError>) -> Void){
//        let dataTask = URLSession.shared.dataTask(with: resourceURL)
//    }
    
    func getAll(completion: @escaping (Result<[ResourceType], ResourceRequestError>)->Void){
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
                let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                do {
                    print(String(describing: jsonData))
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success([resource]))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }
        dataTask.resume()
    }
    
    func save<CreateType>(
      _ saveData: CreateType,
      completion: @escaping (Result<ResourceType, ResourceRequestError>) -> Void
    ) where CreateType: Codable {
      do {
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
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(saveData)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
          guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.noData))
            return
          }
          guard
            httpResponse.statusCode == 200,
            let jsonData = data
          else {
            if httpResponse.statusCode == 401 {
                Auth().logout{
                    guard let applicationDelegate =
                      UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    let rootController =
                      UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
                    applicationDelegate.window?.rootViewController = rootController
                }
            }
            completion(.failure(.noData))
            return
          }

          do {
            let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
            completion(.success(resource))
          } catch {
            completion(.failure(.decodingError))
          }
        }
        dataTask.resume()
      } catch {
        completion(.failure(.encodingError))
      }
    }
}
