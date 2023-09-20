//
//  DetailsCollectionCell.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import UIKit

class DetailsCollectionCell: UICollectionViewCell , DetailsCollectionCellProtocol {

    //Outlets
    @IBOutlet private weak var mainImg: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    
    //Variables
    
    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImg.layer.cornerRadius = 5
    }

    // MARK: - Setup Cell
    func setupCell(name: String , image: String) {
        titleLbl.text = name
        let url = URLImages().getImageURL(
            st_url: image
            , size: .detail
            , imgExtension: "jpg")
        self.mainImg.sd_setImage(with: url , placeholderImage: UIImage(named: "Splash"))
    }
    
}
