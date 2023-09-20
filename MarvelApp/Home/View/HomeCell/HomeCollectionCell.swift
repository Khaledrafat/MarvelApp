//
//  HomeCollectionCell.swift
//  MarvelTest
//
//  Created by mac on 18/09/2023.
//

import UIKit
import Combine
import SDWebImage

class HomeCollectionCell: UICollectionViewCell , HomeCollectionCellProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    
    @IBOutlet weak private var mainImage: UIImageView!
    @IBOutlet weak private var titleLbl: UILabel!
    
    func setData(data: Character) {
        self.titleLbl.text = data.name
        let url = URLImages().getImageURL(
            st_url: (data.thumbnail?.path).defaultString
            , size: .detail
            , imgExtension: (data.thumbnail?.thumbnailExtension).defaultString)
        self.mainImage.sd_setImage(with: url , placeholderImage: UIImage())
    }

}
