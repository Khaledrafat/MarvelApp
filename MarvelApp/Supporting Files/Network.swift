//
//  Network.swift
//  MarvelTest
//
//  Created by mac on 18/09/2023.
//

import Alamofire
import Foundation

class Network {
    
    // MARK: - Get HTTPHeader + Remove Empty Values
    private func getHeader(_ headers : [String : String]) -> HTTPHeaders {
        var header : HTTPHeaders = [:]
        for (key , value) in headers {
            if !value.isEmpty {
                header[key] = value
            }
        }
        return header
    }
    
    // MARK: - Main Request
    func request<T : Codable>(url : URL , params : [String : Any]? , headers : [String : String]? , method : HTTPMethod , completionHandler : @escaping (Swift.Result<T , Result_Errors>)->()) {
        
        var header : HTTPHeaders? = nil
        if let headers = headers {
            header = getHeader(headers)
        }
        
        Alamofire.request(url, method: method , parameters: params, encoding: JSONEncoding.default , headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(_) :
                    print(response.description)
                    do {
                        guard let data = response.data else { return }
                        let responseData = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(responseData))
                    } catch let error {
                        let err : Result_Errors = .errorMessage(message: error.localizedDescription)
                        completionHandler(.failure(err))
                    }
                case .failure(let error) :
                    let err : Result_Errors = .errorMessage(message: error.localizedDescription)
                    completionHandler(.failure(err))
                }
            }
    }
}

// MARK: - Error
enum Result_Errors : Error {
    case errorMessage(message : String)
    
    var message : String {
        switch self {
        case .errorMessage(message: let value):
            return "Sorry , \(value)"
        }
    }
}

