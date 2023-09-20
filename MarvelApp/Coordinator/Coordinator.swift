//
//  Coordinator.swift
//  MarvelApp
//
//  Created by mac on 19/09/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator , HomeCoordinator , DetailsCoordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navCon: UINavigationController) {
        self.navigationController = navCon
    }
    
    func start() {
        goHome()
    }
    
    // MARK: - GO Home
    func goHome() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: .main)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let homeVM = HomeVM(interactor: HomeInteractor())
        homeVM.coordinator = self
        homeVC.homeVM = homeVM
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func goToDetails(id: String) {
        let detailsVC = DetailsVC()
        let detailsVM = DetailsVM(interactor: DetailsInteractor(), id: id)
        detailsVM.coordinator = self
        detailsVC.detailsVM = detailsVM
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func openURLInBrowser(url: URL) {
        UIApplication.shared.open(url)
    }
    
}
