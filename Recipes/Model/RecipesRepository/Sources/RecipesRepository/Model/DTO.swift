//
//  DTO.swift
//  Recipes
//
//  Created by Peter Wu on 1/21/25.
//

import Foundation

struct RecipesResponseDTO: Sendable, Decodable {
    let recipes: [RecipeDTO]
}

struct RecipeDTO: Sendable, Decodable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?
}

extension RecipeDTO: Identifiable {
    var id: String { uuid }
}
