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
    
    private(set) var loadingState: LoadingState?
    
    enum LoadingState: Equatable {
        case loading
        case loaded(LoadResult)
        enum LoadResult: Equatable {
            case empty, withLoad([CellData]), withError(String)
        }
    }
    
    init(repository: any RecipesRepository) {
        self.repository = repository
    }
    
    func fetchAllRecipes() async {
        if loadingState == .loading {
            print("Still loading...skip")
            return
        }
        
        loadingState = .loading
        
        do {
            let fetched = try await repository.fetchAllRecipes().map {
                CellData.init(
                    id: $0.id,
                    name: $0.name,
                    cuisineName: $0.cuisine.title,
                    imageUrl: $0.photoUrl?.urlString
                )
            }
            
            if fetched.isEmpty {
                loadingState = .loaded(.empty)
            } else {
                loadingState = .loaded(.withLoad(fetched))
                cachedAllRecipes = fetched
            }
        } catch {
            loadingState = LoadingState
                .loaded(.withError(error.localizedDescription))
        }
    }
}
