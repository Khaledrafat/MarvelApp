//
//  DetailsVM.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import Foundation
import Combine
import UIKit

final class DetailsVM: DetailsVMProtocol {
    
    var id = ""
    weak var coordinator: DetailsCoordinator?
    private var interactor: DetailsInteractorProtocol
    private var cancellable = Set<AnyCancellable>()
    private var collectionsData = [String:Comics?]()
    private var resourcesList = [String:String?]()
    private var list = [Resources]()
    private var output = PassthroughSubject<DetailsOutput , Never>()
    
    init(interactor: DetailsInteractorProtocol , id: String) {
        self.interactor = interactor
        self.id = id
        DetailsCollectionType.allCases.forEach({collectionsData[$0.rawValue] = nil})
    }
    
    func transform(input: AnyPublisher<DetailsInput, Never>) -> AnyPublisher<DetailsOutput, Never> {
        
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .resourceClicked(let res):
                guard let st_url = self.resourcesList[res.rawValue] else { return }
                if let url = URL(string: st_url.defaultString) {
                    self.coordinator?.openURLInBrowser(url: url)
                }
                
            case .getDetails:
                self.getDetails()
            }
        }
        .store(in: &cancellable)
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Get Details
    private func getDetails() {
        self.output.send(.loaderISHidden(false))
        interactor.getDetails(id: id)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.output.send(.loaderISHidden(true))
                switch response {
                case .finished:
                    print("FINISHED")
                case .failure(let error):
                    //Error Message HERE
                    print(error.message)
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                guard let response = data as? DetailsModel else { return }
                //Error Message HERE #1
                guard response.data?.results.count ?? 0 > 0 else { return }
                //Error Message HERE #2
                guard let result = response.data?.results[0] else { return }
                //Error Message HERE #3
                
                self.output.send(.name(result.name))
                self.output.send(.desc(result.description))
                let url = URLImages().getImageURL(
                    st_url: (result.thumbnail?.path).defaultString
                    , size: .detail
                    , imgExtension: (result.thumbnail?.thumbnailExtension).defaultString)
                self.output.send(.mainImage(url))
                self.output.send(.collection((DetailsCollectionType.series,result.series?.items?.count ?? 0)))
                self.output.send(.collection((DetailsCollectionType.stories,result.stories?.items?.count ?? 0)))
                self.output.send(.collection((DetailsCollectionType.comics,result.comics?.items?.count ?? 0)))
                self.output.send(.collection((DetailsCollectionType.events,result.events?.items?.count ?? 0)))
                
                let resou = result.urls ?? []
                resou.forEach { element in
                    if let value = Resources.init(rawValue: element.type.defaultString) {
                        self.resourcesList[value.rawValue] = element.url
                        self.list.append(value)
                    }
                }
                self.output.send(.resources(self.list))
                self.collectionsData[DetailsCollectionType.series.rawValue] = result.series
                self.collectionsData[DetailsCollectionType.comics.rawValue] = result.comics
                self.collectionsData[DetailsCollectionType.events.rawValue] = result.events
                self.collectionsData[DetailsCollectionType.stories.rawValue] = result.stories
            }
            .store(in: &cancellable)
    }
    
    //TO BE REMOVED
    // MARK: - Get Comics
    private func getComicsDetails(type: DetailsCollectionType) {
        interactor.getComicsDetails(id: id, type: type.rawValue)
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .finished:
                    print("FINISHED")
                case .failure(let error):
                    //Error Message HERE
                    print(error.message)
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                guard let response = data as? ComicsDetailsModel else { return }
                //Error Message HERE #1
                guard response.data?.results?.count ?? 0 > 0 else { return }
                //Error Message HERE #2
                
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Setup Cell
    func setupCell(cell: DetailsCollectionCellProtocol , index: Int , type: DetailsCollectionType) {
        guard let data = collectionsData[type.rawValue] ,
        index <= data?.items?.count ?? 0 else { return }
        guard let item = data?.items?[index] else { return }
        cell.setupCell(name: item.name.defaultString, image: item.resourceURI.defaultString)
    }
    
}
