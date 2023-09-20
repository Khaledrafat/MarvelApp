//
//  ComicsDetailsModel.swift
//  MarvelApp
//
//  Created by mac on 19/09/2023.
//

import Foundation

// MARK: - Welcome
struct ComicsDetailsModel: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: ComicsDetails?
}

// MARK: - DataClass
struct ComicsDetails: Codable {
    let offset, limit, total, count: Int?
    let results: [ComicsResult]?
}

// MARK: - Result
struct ComicsResult: Codable {
    let id: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String?
    let modified: Date?
    let isbn, upc, diamondCode, ean: String?
    let issn, format: String?
    let pageCount: Int?
    let resourceURI: String?
    let urls: [URLElement]?
    let series: Comics?
    let variants: [Comics]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Character?
    let stories: Comics?
    let events: Character?
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [CreatorsItem]?
    let returned: Int?
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String?
    let name, role: String?
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: String?
    let date: Date?
}

// MARK: - Price
struct Price: Codable {
    let type: String?
    let price: Double?
}
