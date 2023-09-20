//
//  DetailsInteractor.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import Foundation
import Combine

class DetailsInteractor: DetailsInteractorProtocol {
    let network = Network()
    
    // MARK: - Char Details
    func getDetails(id: String) -> Future<AnyObject?, Result_Errors> {
        return Future<AnyObject?, Result_Errors> { [weak self] promise in
            guard let self = self else { return promise(.failure(.errorMessage(message: "ERROR"))) }
            let hash = Constants.hashCode.md5
            let st_url = Constants.baseURL + "characters" + "/\(id)" + "?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(hash)"
            guard let url = URL(string: st_url) else
            { return promise(.failure(.errorMessage(message: "ERROR URL"))) }
            
            self.network.request(url: url, params: nil, headers: nil, method: .get) { (res : Result<DetailsModel , Result_Errors>) in
                switch res {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let response):
                    if response.message != nil {
                        promise(.failure(.errorMessage(message: response.message.defaultString)))
                    } else {
                        promise(.success(response as AnyObject?))
                    }
                }
            }
        }
    }
    
    // MARK: - Get Comics Details
    func getComicsDetails(id: String , type: String) -> Future<AnyObject?, Result_Errors> {
        return Future<AnyObject?, Result_Errors> { [weak self] promise in
            guard let self = self else { return promise(.failure(.errorMessage(message: "ERROR"))) }
            let hash = Constants.hashCode.md5
            let st_url = Constants.baseURL + "characters" + "/\(id)" + "/\(type)" + "?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(hash)&limit=15"
            guard let url = URL(string: st_url) else
            { return promise(.failure(.errorMessage(message: "ERROR URL"))) }
            
            self.network.request(url: url, params: nil, headers: nil, method: .get) { (res : Result<DetailsModel , Result_Errors>) in
                switch res {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let response):
                    if response.message != nil {
                        promise(.failure(.errorMessage(message: response.message.defaultString)))
                    } else {
                        promise(.success(response as AnyObject?))
                    }
                }
            }
        }
    }
    
}
