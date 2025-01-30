//
//  Recipe.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

public protocol RecipesModel: Sendable & Codable & Identifiable & Hashable { }

public struct Recipe: RecipesModel {
    public let id: String
    public let cuisine: CuisineType
    public let name: String
    public let photoUrl: PhotoUrl?
    
    public enum PhotoUrl: Hashable, Codable, Sendable {
        case small(String), large(String)
    }

    public enum CuisineType: Hashable, Codable, Sendable {
        public enum KnownCuisine: String, Codable, Sendable {
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
        
        switch (dto.photoUrlSmall, dto.photoUrlLarge) {
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
