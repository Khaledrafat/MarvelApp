//
//  HomeInteractor.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import Foundation
import Combine

class HomeInteractor: HomeInteractorProtocol {
    let network = Network()
    
    func getHomeData(offset : Int) -> Future<AnyObject? , Result_Errors> {
        return Future<AnyObject? , Result_Errors> { [weak self] promise in
            guard let self = self else { return promise(.failure(.errorMessage(message: "ERROR"))) }
            let hash = Constants.hashCode.md5
            let st_url = Constants.baseURL + "characters" + "?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(hash)&offset=\(offset)&limit=10"
    //        let header = ["limit" : "10" , "apikey" : Constants.publicKey , "hash" : hash , "ts" : Constants.ts]
    //        let st_url = Constants.baseURL + "characters"
            guard let url = URL(string: st_url) else
            { return promise(.failure(.errorMessage(message: "ERROR URL"))) }
            
            self.network.request(url: url, params: nil, headers: nil, method: .get) { (res : Result<HomeDataModel , Result_Errors>) in
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
