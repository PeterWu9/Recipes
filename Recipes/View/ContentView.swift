//
//  ContentView.swift
//  recipes
//
//  Created by Peter Wu on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    @State private var refreshTask: Task<Void, Never>?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    switch viewModel.loadingState {
                    case .none:
                        EmptyView()
                    case .isLoading(let isInitial) where isInitial == true:
                        ProgressView()
                            .scaleEffect(2)
                            .frame(minWidth: 200)
                            .padding(.top, .topPadding)
                    default:
                        view(for: viewModel.loadingResult)
                    }
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .refreshable(action: {
            refreshTask = Task {
                await viewModel.fetchAllRecipes()
            }
        })
        .onDisappear {
            refreshTask?.cancel()
        }
        .task {
            await viewModel.fetchAllRecipes()
        }
    }
    
    @ViewBuilder func view(for loadingResult: Result<[ViewModel.CellData], Error>?) -> some View {
        switch viewModel.loadingResult {
        case .success(let recipes):
            if recipes.isEmpty {
                ContentUnavailableView("No recipes are available.  Please try again later!", systemImage: "fork.knife.circle")
                    .padding(.top, .topPadding)
            } else {
                RecipesList(recipes: recipes)
                    .padding()
                    .ignoresSafeArea(edges: .bottom)
            }
        case .failure:
            ContentUnavailableView("We apologize.  We're running into some issues.  Please try again later!", systemImage: "exclamationmark.circle")
                .padding(.top, .topPadding)
        case .none:
            EmptyView()
        }
    }
}

extension CGFloat {
    static let topPadding: Self = 100
}

#Preview(
    traits: .modifier(AllRecipesPreviewData()),
    .modifier(BundleImageAssetPreviewData())
) {
    ContentView()
}

#Preview(
    "Empty",
    traits: .modifier(EmptyPreviewData()),
    .modifier(BundleImageAssetPreviewData())
) {
    ContentView()
}

#Preview(
    "Malformed",
    traits: .modifier(MalformedPreviewData()),
    .modifier(BundleImageAssetPreviewData())
) {
    ContentView()
}
