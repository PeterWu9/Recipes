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
    /// Latest valid and non-empty fetched result from `fetchAllRecipes` call
    private(set) var cachedAllRecipes = [CellData]()
    
    private let repository: any RecipesRepository
    
    private(set) var loadingState: LoadingState<CellData>?
    
    enum LoadingState<Item> {
        case loading
        case loaded(Result<DataState, Error>)
        enum DataState {
            case empty, full([Item])
        }
    }
    
    init(repository: any RecipesRepository) {
        self.repository = repository
    }
    
    func fetchAllRecipes() async {
        if case .loading = loadingState {
            print("Still loading...skip")
            return
        }
        
        loadingState = .loading
        loadingState = await .loaded(
            Result {
                let fetched = try await repository.fetchAllRecipes().map {
                    CellData.init(
                        id: $0.id,
                        name: $0.name,
                        cuisineName: $0.cuisine.title,
                        imageUrl: $0.photoUrl?.urlString
                    )
                }
                return fetched.isEmpty
                ? LoadingState.DataState.empty
                : LoadingState.DataState.full(fetched)
            }
        )
        
        // update allRecipes cache
        if case .loaded(let result) = loadingState {
            switch result {
            case let .success(.full(recipes)):
                cachedAllRecipes = recipes
            default:
                break
            }
        }
    }
}
