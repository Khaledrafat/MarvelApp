//
//  HomeConfiguration.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import Foundation
import Combine

enum HomeInput {
    case paginate , cellClicked(Int) , getHomeData
}

enum HomeOutput {
    case loaderISHidden(Bool) , dataSourcePublisher(Int)
}


protocol HomeInteractorProtocol {
    func getHomeData(offset : Int) -> Future<AnyObject? , Result_Errors>
}

protocol HomeCollectionCellProtocol: AnyObject {
    func setData(data: Character)
}

protocol HomeVMProtocol {
    func setupHomeCell(cell: HomeCollectionCellProtocol, index: Int)
    func tranform(input: AnyPublisher<HomeInput , Never>) -> AnyPublisher<HomeOutput , Never>
}

protocol HomeCoordinator: AnyObject {
    func goToDetails(id: String)
}
