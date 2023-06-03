//
//  Auth.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 16.05.23.
//

import Foundation
import UIKit

enum AuthResult {
  case success
  case failure
}

class Auth{
    static let keychainKey = "TIL-API-KEY"
    
    var token: String? {
        get {
            Keychain.load(key: Auth.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: Auth.keychainKey, data: newToken)
            } else {
                Keychain.delete(key: Auth.keychainKey)
            }
        }
    }
    
    func logout(completion: @escaping ()-> Void) {
        token = nil
        DispatchQueue.main.async {
            completion()
            
        }
    }
    
    func login(username: String, password: String, completion: @escaping (AuthResult)->Void){
        let path = "\(Constants.baseURL)\(Endpoints.users)\(Endpoints.login)"
        print(path)
        guard let url = URL(string: path) else{
            fatalError("Failed to convert URL")
        }
        guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else{
            fatalError("Failed to encode credentials")
        }
        var loginRequest = URLRequest(url: url)
        
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest){
            data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else{
                completion(.failure)
                return
            }
            
            do{
                let token = try JSONDecoder().decode(Token.self, from:  jsonData)
                self.token = token.value
                completion(.success)
            } catch{
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    func getUserInfo(completion: @escaping (AuthResult, _ user : User?)-> Void){
        let path = "\(Constants.baseURL)\(Endpoints.users)"
        guard let url = URL(string: path) else{
            fatalError("Failed to convert URL")
        }
        var userRequest = URLRequest(url: url)
        
        userRequest.addValue("Bearer \(self.token ?? "")", forHTTPHeaderField: "Authorization")
        userRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: userRequest){
            data, response, _ in
            
            guard let httpResonse = response as? HTTPURLResponse, httpResonse.statusCode == 200, let jsonData = data else{
                completion(.failure, nil)
                return
            }
            
            do{
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                
                completion(.success, user)
            }catch{
                completion(.failure, nil)
                
            }
        }
        dataTask.resume()
    }
    
    func createUser(name: String, surname : String, role : Role, email : String, username : String, password : String, completion: @escaping (AuthResult,  _ user : User?) -> Void){
        do{
        let path = "\(Constants.baseURL)\(Endpoints.users)"
        guard let url = URL(string: path) else{
            fatalError("Failed to convert URL")
        }
        var userRequest = URLRequest(url: url)
        userRequest.httpMethod = "POST"
        userRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let json : [String : Any] = [
                "name" : "\(name)",
                "surname" : "\(surname)",
                "role" : "\(role)",
                "email" : "\(email)",
                "username" : "\(username)",
                "password" : "\(password)"]
            userRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
        let dataTask = URLSession.shared.dataTask(with: userRequest){
            data, response, _ in
            guard let httpResonse = response as? HTTPURLResponse, httpResonse.statusCode == 200, let jsonData = data else{
                completion(.failure, nil)
                return
            }
            
            do{
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                
                completion(.success, user)
            }catch{
                completion(.failure, nil)
                
            }
        }
        dataTask.resume()
        
    } catch {
        completion(.failure, nil)
        }
    }
    
    func attachUser(inviteCode : String, completion : @escaping (AuthResult)->Void){
        let path = "\(Constants.baseURL)\(Endpoints.users)\(Endpoints.attach)/\(inviteCode)"
        guard let url = URL(string: path) else{
            fatalError("Failed to convert URL")
        }
        var userRequest = URLRequest(url: url)
        
        userRequest.addValue("Bearer \(self.token ?? "")", forHTTPHeaderField: "Authorization")
        userRequest.httpMethod = "PATCH"
        let dataTask = URLSession.shared.dataTask(with: userRequest){
            data, response, _ in
            
            guard let httpResonse = response as? HTTPURLResponse, httpResonse.statusCode == 200, let _ = data else{
                completion(.failure)
                return
            }
            completion(.success)
            
//            do{
////                let user = try JSONDecoder().decode(User.self, from: jsonData)
////
//
//            }catch{
//                completion(.failure)
//
//            }
        }
        dataTask.resume()
    }
}

