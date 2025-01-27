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
                RecipesList(recipes: viewModel.allRecipes)
                    .padding()
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
