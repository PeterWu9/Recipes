//
//  RecipesApp.swift
//  recipes
//
//  Created by Peter Wu on 1/21/25.
//

import Cache
import ImageLoader
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
    @State private var imageAssetViewModel = ImageAssetViewModel(
        imageService: RemoteImageLoader(cache: InMemoryCache())
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .environment(imageAssetViewModel)
        }
    }
}
