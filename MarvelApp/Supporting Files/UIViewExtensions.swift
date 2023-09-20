//
//  UIViewExtensions.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

extension UIView {
    func loadViewFromNib() -> UIView? {
        let nibName = "\(type(of: self))"
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
}
