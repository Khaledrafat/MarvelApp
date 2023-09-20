//
//  HomeDataModel.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import Foundation

struct HomeDataModel: Codable {
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: HomeData?
    let message: String?
}

// MARK: - DataClass
struct HomeData: Codable {
    let offset, limit, total, count: Int?
    let results: [Character]?
}

// MARK: - Result
struct Character: Codable {
    let id: Int?
    let name, description: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series, stories, events: Comics?
    let urls: [URLElement]?
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String?
    let url: String?
}
