//
//  ViewController.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit
import Combine

class HomeVC: BaseVC {

    //Outlets
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    @IBOutlet weak private var homeCollectionView: UICollectionView!
    
    //Variables
    var homeVM: HomeVMProtocol?
    private var cancellable = Set<AnyCancellable>()
    private var collectionCells: Int = 0
    private var input = PassthroughSubject<HomeInput , Never>()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupVM()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.input.send(.getHomeData)
    }
    
    // MARK: - Setup ViewModel
    private func setupVM() {
        observeVM()
    }
    
    // MARK: - Observe VM
    private func observeVM() {
        guard let output = homeVM?.tranform(input: self.input.eraseToAnyPublisher()) else { return }
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            guard let self = self else { return }
            switch event {
                // MARK: - Loader
            case .loaderISHidden(let value):
                self.view.isUserInteractionEnabled = value
                self.loader.isHidden = value
                
                // MARK: - Data
            case .dataSourcePublisher(let count):
                self.collectionCells = count
                self.homeCollectionView.reloadData()
                
            case .showError(let message):
                self.showAlert(with: message)
            }
        }
            .store(in: &cancellable)
    }

    // MARK: - Setup Collection
    private func setupCollection() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionCell")
    }

}

// MARK: - CollectionView
extension HomeVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell else { return UICollectionViewCell() }
        homeVM?.setupHomeCell(cell: cell , index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height : CGFloat = 220
        let width : CGFloat = homeCollectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.homeCollectionView.contentOffset.y >= (self.homeCollectionView.contentSize.height - self.homeCollectionView.bounds.size.height)) {
            self.input.send(.paginate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.input.send(.cellClicked(indexPath.row))
    }
}
