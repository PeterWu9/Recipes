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
            ScrollView {
                switch viewModel.loadingState {
                case .none:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let result):
                    switch result {
                    case .empty:
                        ContentUnavailableView("No recipes are available.  Please try again later!", image: "fork.knife.circle")
                    case .withLoad(let recipes):
                        RecipesList(recipes: recipes)
                            .padding()
                    case .withError:
                        ContentUnavailableView("We apologize.  We're running into some issues.  Please try again later!", image: "exclamationmark.circle")
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchAllRecipes()
            }
        }
    }
}

#Preview(traits: .modifier(PreviewData())) {
    ContentView()
}
