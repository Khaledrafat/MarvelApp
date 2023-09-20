//
//  ResusableResources.swift
//  MarvelApp
//
//  Created by mac on 19/09/2023.
//

import UIKit
import Combine

class ResusableResources: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var WikiView: UIView!
    @IBOutlet weak var DetailsView: UIView!
    @IBOutlet weak var comicsView: UIView!
    
    @Published var buttonClicked: Resources?
    
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
    
    @IBAction func detailsButton(_ sender: UIButton) {
        buttonClicked = .detail
    }
    
    @IBAction func wikiButton(_ sender: Any) {
        buttonClicked = .wiki
    }
    
    @IBAction func comicsButton(_ sender: Any) {
        buttonClicked = .comiclink
    }
    
}
