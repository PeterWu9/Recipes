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

#Preview(traits: .modifier(PreviewData())) {
    AllRecipesPreviewContainer { recipes in
        ScrollView {
            RecipesList(recipes: recipes.map {
                RecipeCell.CellData.init(
                    id: $0.id,
                    name: $0.name,
                    cuisineName: $0.cuisine.title,
                    imageUrl: $0.photoUrl?.urlString
                )
            })
        }
    }
    .padding()
}
