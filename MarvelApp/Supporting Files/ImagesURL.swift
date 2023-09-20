//
//  ImagesURL.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import Foundation

enum ImageSize: String {
    case standard_fantastic , standard_xlarge , standard_medium , standard_large
    case portrait_small , portrait_fantastic , portrait_xlarge , portrait_medium
    case landscape_xlarge , landscape_fantastic , landscape_small , landscape_medium
    case detail , full_size = "full-size image"
}


class URLImages {
    func getImageURL(st_url: String , size: ImageSize , imgExtension: String) -> URL? {
        var stringURL = st_url
        if !st_url.contains("https") , st_url.contains("http") {
            stringURL = st_url.replacingOccurrences(of: "http", with: "https", options: .literal, range: nil)
        }
        let stURL = stringURL + "/\(size.rawValue)" + ".\(imgExtension)"
        return URL(string: stURL)
    }
}
