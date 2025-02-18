//
//  ViewModel.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

import Foundation
import RecipesRepository
import SwiftUI

@MainActor
@Observable
final class ViewModel {
    
    private let repository: any RecipesRepository
            
    var allRecipes: [CellData] {
        if case .success(let recipes) = loadingResult {
            recipes
        } else {
            []
        }
    }
    
    private(set) var loadingResult: Result<[CellData], Error>?

    private(set) var loadingState: LoadingState = .none
        
    init(repository: any RecipesRepository) {
        self.repository = repository
    }
    
    func fetchAllRecipes() async {
        print(#function)
        if loadingState.isLoading {
            print("Still loading...skip")
            return
        }
        
        loadingState.start()
        
        do {
            let allRecipes = try await repository.fetchAllRecipes().map {
                CellData.init(
                    id: $0.id,
                    name: $0.name,
                    cuisineName: $0.cuisine.title,
                    imageUrl: $0.photoUrl?.urlString
                )
            }
            
            loadingState = .loaded()
            loadingResult = .success(allRecipes)
            print("Fetch completed")
        } catch {
            print(error.localizedDescription)
            loadingState = .loaded(withError: error.localizedDescription)
            loadingResult = .failure(error)
            print("Fetch completed with error")
        }
    }
}

extension ViewModel {
    enum LoadingState: Equatable {
        case none, isLoading(isInitial: Bool), loaded(withError: String? = nil)
        
        var isLoading: Bool {
            if case .isLoading = self {
                true
            } else {
                false
            }
        }
        
        mutating func start() {
            switch self {
            case .isLoading:
                print("Already loading - invalid operation")
            case .loaded:
                self = .isLoading(isInitial: false)
            case .none:
                self = .isLoading(isInitial: true)
            }
        }
        
        mutating func stop(with error: Error? = nil) {
            switch self {
            case .none:
                print("Never started - invalid operation")
            case .isLoading:
                self = .loaded(withError: error?.localizedDescription)
            case .loaded:
                print("Already stopped - invalid operation")
            }
        }
    }
}

extension ViewModel {
    struct CellData: Equatable {
        let id: String
        let name: String
        let cuisineName: String
        let imageUrl: String?
    }
}
