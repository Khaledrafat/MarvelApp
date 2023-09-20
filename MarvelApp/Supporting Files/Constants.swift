//
//  Constants.swift
//  MarvelTest
//
//  Created by mac on 18/09/2023.
//

import Foundation

class Constants {
    static var ts = "\(NSDate().timeIntervalSince1970)"
    static var baseURL = "https://gateway.marvel.com:443/v1/public/"
    static var publicKey = "b0c31a4df3013d123975fdb69748cc0d"
    static var privateKey = "1f6996df5fd122c47230cc0e6c951c789b89e300"
    static var hashCode = ts + privateKey + publicKey
}
