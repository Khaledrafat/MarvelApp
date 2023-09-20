//
//  DetailsVC.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit
import Combine
import SDWebImage

class DetailsVC: BaseVC {
    
    var detailsVM: DetailsVMProtocol?
    private var cancellable = Set<AnyCancellable>()
    private var collectionCount: [String:Int] = [:]
    private var input = PassthroughSubject<DetailsInput , Never>()

    @IBOutlet weak var resourcesView: ResusableResources!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var seriesView: ReusableCollectionSection!
    @IBOutlet weak var storiesView: ReusableCollectionSection!
    @IBOutlet weak var eventsView: ReusableCollectionSection!
    @IBOutlet weak var comicsView: ReusableCollectionSection!
    @IBOutlet weak var descView: ReusableTextSection!
    @IBOutlet weak var nameView: ReusableTextSection!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeDetailsVM()
        setupCollections()
        observeViews()
    }
    
    // MARK: - Setup Collections
    private func setupCollections() {
        self.seriesView.setupCollection(cellID: "DetailsCollectionCell",
                                        delegate: self, datasource: self ,
                                        tag: DetailsCollectionType.series.tag)
        self.storiesView.setupCollection(cellID: "DetailsCollectionCell",
                                         delegate: self, datasource: self ,
                                         tag: DetailsCollectionType.stories.tag)
        self.eventsView.setupCollection(cellID: "DetailsCollectionCell",
                                        delegate: self, datasource: self ,
                                        tag: DetailsCollectionType.events.tag)
        self.comicsView.setupCollection(cellID: "DetailsCollectionCell",
                                        delegate: self, datasource: self ,
                                        tag: DetailsCollectionType.comics.tag)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.nameView.titleLbl.text = "Name"
        self.descView.titleLbl.text = "Description"
        self.seriesView.titlelLbl.text = "Series"
        self.comicsView.titlelLbl.text = "Comics"
        self.eventsView.titlelLbl.text = "Events"
        self.storiesView.titlelLbl.text = "Stories"
        DetailsCollectionType.allCases.forEach({collectionCount[$0.rawValue] = 0 })
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.getDetails)
        self.storiesView.dataCollection.reloadData()
    }
    
    // MARK: - VM Observers
    private func observeDetailsVM() {
        guard let outlet = self.detailsVM?.transform(input: self.input.eraseToAnyPublisher())
        else { return }
        outlet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self = self else { return }
                switch events {
                    // MARK: -  Loader
                case .loaderISHidden(let value):
                    self.loader.isHidden = value
                    self.view.isUserInteractionEnabled = value
                    
                    // MARK: -  Desc
                case .desc(let text):
                    self.descView.isHidden = text.defaultString.isEmpty
                    self.descView.descLbl.text = text
                    
                    // MARK: -  Name
                case .name(let text):
                    self.nameView.isHidden = text.defaultString.isEmpty
                    self.nameView.descLbl.text = text
                    
                    // MARK: -  Image
                case .mainImage(let url):
                    guard let url = url else { return }
                    self.headerImg.sd_setImage(with: url , placeholderImage: UIImage())
                    
                    // MARK: - Show Error Message
                case .showError(let message):
                    self.showAlert(with: message)
                    
                    // MARK: -  Resources
                case .resources(let resources):
                    guard resources.count > 0 else {
                        self.resourcesView.isHidden = true
                        return
                    }
                    self.resourcesView.isHidden = false
                    resources.forEach { resource in
                        switch resource {
                        case .comiclink: self.resourcesView.comicsView.isHidden = false
                        case .detail: self.resourcesView.DetailsView.isHidden = false
                        case .wiki: self.resourcesView.WikiView.isHidden = false
                        }
                    }
                    
                    // MARK: - Collections
                case .collection(let data):
                    self.collectionCount[data.0.rawValue] = data.1
                    switch data.0 {
                    case .comics:
                        self.comicsView.isHidden = data.1 == 0
                        self.comicsView.dataCollection.reloadData()
                    case .events:
                        self.eventsView.isHidden = data.1 == 0
                        self.eventsView.dataCollection.reloadData()
                    case .series:
                        self.seriesView.isHidden = data.1 == 0
                        self.seriesView.dataCollection.reloadData()
                    case .stories:
                        self.storiesView.isHidden = data.1 == 0
                        self.storiesView.dataCollection.reloadData()
                    }
                }
            }
        .store(in: &cancellable)
    }
    
    // MARK: - Views Observers
    private func observeViews() {
        self.resourcesView.$buttonClicked
            .sink { [weak self] resource in
                guard let self = self , let resource = resource else { return }
                self.input.send(.resourceClicked(resource))
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailsVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCount[DetailsCollectionType.returnSelf(tag: collectionView.tag).rawValue].defaultIntZero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionCell", for: indexPath) as? DetailsCollectionCell else { return UICollectionViewCell() }
        let type = DetailsCollectionType.returnSelf(tag: collectionView.tag)
        self.detailsVM?.setupCell(cell: cell, index: indexPath.row, type: type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width : CGFloat = 100
        return CGSize(width: width, height: height)
    }
}
