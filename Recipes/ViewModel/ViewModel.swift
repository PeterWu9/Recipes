//
//  ViewModel.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

import Foundation
import RecipesRepository

@MainActor
@Observable
final class ViewModel {
    typealias CellData = RecipeCell.CellData
    var allRecipes = [CellData]()
    
    private let repository: any RecipesRepository
    
    init(repository: any RecipesRepository) {
        self.repository = repository
    }
    
    func fetchAllRecipes() async {
        do {
            allRecipes = try await repository.fetchAllRecipes().map {
                CellData.init(
                    id: $0.id,
                    name: $0.name,
                    cuisineName: $0.cuisine.title,
                    imageUrl: $0.photoUrl?.urlString
                )
            }
        } catch {
            // TODO: Error handling
            print(error.localizedDescription)
        }
    }
}
