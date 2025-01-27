//
//  RecipeCell.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//
import SwiftUI

struct RecipeCell: View {
    let data: CellData
    
    var body: some View {
        HStack(alignment: .center) {
            // Placeholder Image
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray)
                .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.headline)
                Text(data.cuisineName)
                    .font(.subheadline)
                    .foregroundStyle(.brown)
            }
        }
    }
    
    struct CellData {
        let id: String
        let name: String
        let cuisineName: String
        let imageUrl: String?
    }
}

#Preview("Cell") {
    RecipeCell(
        data: .init(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            name: "Apam Balik",
            cuisineName: "Malaysian",
            imageUrl: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        )
    )
    .padding()
}
