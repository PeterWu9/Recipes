//
//  Recipe+.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

import Foundation
import RecipesRepository

extension Recipe.CuisineType {
    var title: String {
        switch self {
        case .known(let knownCuisine):
            knownCuisine.rawValue.capitalized
        case .custom(let customCuisine):
            customCuisine.capitalized
        }
    }
}

extension Recipe.PhotoUrl {
    var urlString: String {
        switch self {
        case .small(let urlString):
            urlString
        case .large(let urlString):
            urlString
        }
    }
}
