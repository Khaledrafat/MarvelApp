//
//  ReusableCollectionSection.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

final class ReusableCollectionSection: UIView {
    
    //XIB Setup
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var titlelLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        guard let view = self.loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    // MARK: - Setup Collection
    func setupCollection(cellID: String , delegate: UICollectionViewDelegate , datasource: UICollectionViewDataSource , tag: Int){
        self.dataCollection.delegate = delegate
        self.dataCollection.dataSource = datasource
        let nib = UINib(nibName: cellID, bundle: nil)
        self.dataCollection.register(nib, forCellWithReuseIdentifier: cellID)
        self.dataCollection.tag = tag
    }
    
}
