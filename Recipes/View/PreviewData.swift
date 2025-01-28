//
//  PreviewData.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

import RecipesRepository
import SwiftUI

struct PreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ViewModel {
        .init(repository: InMemoryRecipesRepository())
    }
    func body(content: Content, context: ViewModel) -> some View {
        content
            .environment(context)
    }
}

// TODO: Conditionally compile only when running SwiftUI Preview
struct AllRecipesPreviewContainer<Content: View>: View {
    @Environment(ViewModel.self) var viewModel
    var makeContentWithRecipes: ([RecipeCell.CellData]) -> Content
    var body: some View {
        makeContentWithRecipes(viewModel.cachedAllRecipes)
            .task {
                await viewModel.fetchAllRecipes()
            }
    }
}
