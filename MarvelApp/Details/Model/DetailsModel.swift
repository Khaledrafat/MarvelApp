//
//  DetailsModel.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import Foundation

// MARK: - Welcome
struct DetailsModel: Codable {
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
    let message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int
    let results: [Character]
}

enum TypeEnum: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}
