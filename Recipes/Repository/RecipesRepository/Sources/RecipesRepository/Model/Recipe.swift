//
//  Recipe.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

struct Recipe: RecipesModel {
    let id: String
    let cuisine: CuisineType
    let name: String
    let photoUrl: PhotoUrl?
    
    enum PhotoUrl: Hashable, Codable {
        case small(String), large(String)
    }

    enum CuisineType: Hashable, Codable {
        enum KnownCuisine: String, Codable {
            case american
            case british
            case canadian
            case croatian
            case french
            case greek
            case italian
            case malaysian
            case portugese
            case polish
            case russian
            case tunisian
        }
        
        case known(KnownCuisine)
        case custom(String)
        
        init(_ rawValue: String) {
            if let known = KnownCuisine(rawValue: rawValue) {
                self = .known(known)
            } else {
                self = .custom(rawValue)
            }
        }
    }
}

extension Recipe {
    init(from dto: RecipeDTO) {
        id = dto.uuid
        name = dto.name
        
        switch (dto.photoURLSmall, dto.photoURLLarge) {
        case (.some(let smallPhotoUrl), _):
            photoUrl = .small(smallPhotoUrl)
        case (nil, .some(let largePhotoUrl)):
            photoUrl = .large(largePhotoUrl)
        default:
            photoUrl = nil
        }
        
        cuisine = .init(dto.cuisine)
    }
}
