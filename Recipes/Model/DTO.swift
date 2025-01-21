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
    let cuisine, name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let uuid: String
    let sourceURL: String?
    let youtubeURL: String?
}

extension RecipeDTO: Identifiable {
    var id: String { uuid }
}
