//
//  PreviewData.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

import Cache
import ImageLoader
import RecipesRepository
import SwiftUI

struct AllRecipesPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ViewModel {
        .init(
            repository: InMemoryRecipesRepository(
                configuration: .init(mode: .allRecipes)
            )
        )
    }
    func body(content: Content, context: ViewModel) -> some View {
        content
            .environment(context)
    }
}

struct EmptyPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ViewModel {
        .init(
            repository: InMemoryRecipesRepository(
                configuration: .init(mode: .empty)
            )
        )
    }
    func body(content: Content, context: ViewModel) -> some View {
        content
            .environment(context)
    }
}

struct MalformedPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ViewModel {
        .init(
            repository: InMemoryRecipesRepository(
                configuration: .init(mode: .malformed)
            )
        )
    }
    func body(content: Content, context: ViewModel) -> some View {
        content
            .environment(context)
    }
}

struct BundleImageAssetPreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ImageAssetViewModel {
        .init(
            imageService: BundleImageLoader(
                maxLoadingTime: 1,
                cache: InMemoryCache()
            )
        )
    }
    func body(content: Content, context: ImageAssetViewModel) -> some View {
        content
            .environment(context)
    }
}

// TODO: Conditionally compile only when running SwiftUI Preview
struct AllRecipesPreviewContainer<Content: View>: View {
    @Environment(ViewModel.self) var viewModel
    var makeContentWithRecipes: ([RecipeCell.CellData]) -> Content
    var body: some View {
        makeContentWithRecipes(viewModel.allRecipes)
            .task {
                await viewModel.fetchAllRecipes()
            }
    }
}
