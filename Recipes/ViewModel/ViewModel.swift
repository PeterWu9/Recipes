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
    var allRecipes = [Recipe]()
    
    private let repository: any RecipesRepository
    
    init(repository: any RecipesRepository) {
        self.repository = repository
    }
    
    func fetchAllRecipes() async {
        do {
            allRecipes = try await repository.fetchAllRecipes()
        } catch {
            // TODO: Error handling
            print(error.localizedDescription)
        }
    }
}
