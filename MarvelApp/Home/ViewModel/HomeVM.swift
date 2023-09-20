//
//  HomeVM.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit.UIImage
import Combine

final class HomeVM: HomeVMProtocol {
    
    weak var coordinator: HomeCoordinator?
    private var interactor: HomeInteractorProtocol
    private var currentLimit: Int = 0
    private var currentCharacters = [Character]()
    private var cancellable = Set<AnyCancellable>()
    private var isPaginating = false
    private var output = PassthroughSubject<HomeOutput , Never>()
    
    // MARK: - INIT
    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
    }
    
    // MARK: - Transform Input -> Output
    func tranform(input: AnyPublisher<HomeInput, Never>) -> AnyPublisher<HomeOutput, Never> {
        input.sink {[weak self] event in
            guard let self = self else { return }
            switch event {
            case .paginate:
                guard !self.isPaginating else { return }
                self.isPaginating = true
                self.getHomeData()
            case .cellClicked(let index):
                let id = "\(self.currentCharacters[index].id.defaultIntZero)"
                self.coordinator?.goToDetails(id: id)
            case .getHomeData:
                self.getHomeData()
            }
        }
        .store(in: &cancellable)
        return self.output.eraseToAnyPublisher()
    }
    
    // MARK: - Get Home Data
    private func getHomeData() {
        self.output.send(.loaderISHidden(false))
        self.interactor.getHomeData(offset: currentLimit)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.output.send(.loaderISHidden(true))
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                    self.isPaginating = false
                }
                switch completion {
                case .finished:
                    print("FINISHED")
                case .failure(let err):
                    //Error Message HERE
                    print(err.message)
                }
            } receiveValue: {[weak self] data in
                guard let self = self else { return }
                guard let response = data as? HomeDataModel else { return }
                //Error Message HERE #1
                guard let characters = response.data?.results else { return }
                //Error Message HERE #2
                self.currentLimit += 10
                characters.forEach({self.currentCharacters.append($0)})
                self.output.send(.dataSourcePublisher(self.currentCharacters.count))
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Setup Home Cell
    func setupHomeCell(cell: HomeCollectionCellProtocol, index: Int) {
        let char = currentCharacters[index]
        cell.setData(data: char)
    }
}
