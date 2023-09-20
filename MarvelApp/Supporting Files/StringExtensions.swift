//
//  StringExtensions.swift
//  MarvelApp
//
//  Created by mac on 17/09/2023.
//

import Foundation

extension Optional where Wrapped == String {
    var defaultString : String {
        self ?? ""
    }
}
