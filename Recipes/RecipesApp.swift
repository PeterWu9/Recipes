//
//  RecipesApp.swift
//  recipes
//
//  Created by Peter Wu on 1/21/25.
//

import RecipesRepository
import SwiftUI

@main
struct RecipesApp: App {
    #if DEBUG
    @State private var viewModel = ViewModel(repository: RemoteRecipesRepository.allRecipesNoCache)
    #else
    @State private var viewModel = ViewModel(
        repository: RemoteRecipesRepository
            .allRecipes)
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
