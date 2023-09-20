//
//  IntExtensions.swift
//  MarvelApp
//
//  Created by mac on 19/09/2023.
//

import Foundation

extension Optional where Wrapped == Int {
    var defaultIntZero : Int {
        self ?? 0
    }
}
