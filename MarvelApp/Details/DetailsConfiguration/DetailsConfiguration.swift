//
//  DetailsConfiguration.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import Foundation
import Combine

enum DetailsCollectionType: String , CaseIterable {
    case series , stories , comics , events
    var tag: Int {
        switch self {
        case .events: return 1
        case .comics: return 2
        case .stories: return 3
        case .series: return 4
        }
    }
    
    static func returnSelf(tag: Int) -> Self {
        switch tag {
        case 1: return .events
        case 2: return .comics
        case 3: return .stories
        case 4: return .series
        default: return .events
        }
    }
}

enum Resources: String {
    case detail , wiki , comiclink
}

enum DetailsInput {
    case resourceClicked(Resources) , getDetails
}

enum DetailsOutput {
    case loaderISHidden(Bool) , mainImage(URL?) , name(String?) , desc(String?)
    case resources([Resources]) , collection((DetailsCollectionType , Int))
    case showError(String)
}

protocol DetailsVMProtocol {
    func setupCell(cell: DetailsCollectionCellProtocol , index: Int , type: DetailsCollectionType)
    func transform(input: AnyPublisher<DetailsInput , Never>) -> AnyPublisher<DetailsOutput , Never>
}

protocol DetailsInteractorProtocol {
    func getDetails(id: String) -> Future<AnyObject?, Result_Errors>
    func getComicsDetails(id: String , type: String) -> Future<AnyObject?, Result_Errors>
}

protocol DetailsCollectionCellProtocol {
    func setupCell(name: String , image: String)
}

protocol DetailsCoordinator: AnyObject {
    func openURLInBrowser(url: URL)
}
