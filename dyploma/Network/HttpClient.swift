//
//  HttpClient.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 28.02.23.
//

import Foundation

//class ApiService{
//
//    private var dataTask : URLSessionDataTask?
//
//    func getUsersData(completion : @escaping(Result<UserModel, Error>)->Void){
//
//        let userURL = "https://f0fe-37-215-38-28.eu.ngrok.io/user"
//
//        guard let url = URL(string: userURL) else{
//            print("error bad url")
//            return
//        }
//
//        dataTask = URLSession.shared.dataTask(with: url){(data, response, error) in
//            if let error = error{
//                completion(.failure(error))
//                print("DataTaskError \(error.localizedDescription)")
//                return
//            }
//            guard let response = response as? HTTPURLResponse else{
//                print("empty response")
//                return
//            }
//            print("response .statusCode: \(response.statusCode)")
//
//            guard let data = data else{
//                print("empty data")
//                return
//            }
//
//            do{
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(UserModel.self, from: data)
//
//                DispatchQueue.main.async {
//                    completion(.success(jsonData))
//                }
//            }catch let error{
//                completion(.failure(error))
//            }
//        }
//        dataTask?.resume()
//    }
//}
enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
    
}

class HttpClient {
    private init () { }
    
    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        return object
    }
    
}
