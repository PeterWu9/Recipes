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
    @State private var viewModel = ViewModel(repository: RemoteRecipesRepository.allRecipesNoHttpCache)
    #else
    @State private var viewModel = ViewModel(
        repository: RemoteRecipesRepository
            .allRecipes)
    #endif
    @State private var imageAssetViewModel = ImageAssetViewModel(
        imageService: RemoteImageLoader(
            cache: Self.cache
        )
    )
    static var cache: any CacheProtocol<String, Data> = {
        var cache: any CacheProtocol<String, Data>
        do {
            cache = try DiskCache(directoryName: Bundle.main.bundleIdentifier ?? "com.peterwu.recipes")
        } catch {
            print("Disk cache initialization failed due to \(error.localizedDescription).\nRevert to memory cache")
            // Uses memory cache when disk cache fails
            cache = InMemoryCache()
        }
        return cache
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .environment(imageAssetViewModel)
        }
    }
}
