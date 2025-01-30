//
//  RecipesList.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//
import SwiftUI

struct RecipesList: View {
    let recipes: [RecipeCell.CellData]
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(recipes, id: \.id) {
                RecipeCell(data: $0)
            }
        }
    }
}

#Preview(
    traits: .modifier(AllRecipesPreviewData()), .modifier(BundleImageAssetPreviewData())
) {
    AllRecipesPreviewContainer { recipes in
        ScrollView {
            RecipesList(recipes: recipes)
        }
    }
    .padding()
}
