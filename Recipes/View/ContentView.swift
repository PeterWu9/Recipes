//
//  ContentView.swift
//  recipes
//
//  Created by Peter Wu on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.loadingState {
                case .none:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let result):
                    switch result {
                    case .empty:
                        ContentUnavailableView("No recipes are available.  Please try again later!", systemImage: "fork.knife.circle")
                            .padding(.bottom, .bottomPadding)
                    case .withLoad(let recipes):
                        ScrollView {
                            RecipesList(recipes: recipes)
                                .padding()
                                .ignoresSafeArea(edges: .bottom)
                        }
                    case .withError:
                        ContentUnavailableView("We apologize.  We're running into some issues.  Please try again later!", systemImage: "exclamationmark.circle")
                            .padding(.bottom, .bottomPadding)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchAllRecipes()
            }
        }
    }
}

extension CGFloat {
    static let bottomPadding: Self = 200
}

#Preview(traits: .modifier(AllRecipesPreviewData())) {
    ContentView()
}

#Preview("Empty", traits: .modifier(EmptyPreviewData())) {
    ContentView()
}

#Preview("Malformed", traits: .modifier(MalformedPreviewData())) {
    ContentView()
}
