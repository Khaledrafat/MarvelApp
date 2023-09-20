//
//  ReusableTextSection.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

final class ReusableTextSection: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    //XIB Setup
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
    
}
