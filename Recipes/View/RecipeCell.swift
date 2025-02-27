//
//  RecipeCell.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//
import SwiftUI

struct RecipeCell: View {
    @Environment(ImageAssetViewModel.self) private var assetVm
    let data: CellData
    @State private var imageResult: Result<UIImage, Error>?
    
    var body: some View {
        HStack(alignment: .top) {
            cellImage
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.headline)
                    .lineLimit(3)
                    .padding(.bottom, 4)
                HStack {
                    Image(systemName: "globe")
                        .foregroundStyle(.cyan)
                    Text(data.cuisineName)
                        .font(.subheadline)
                        .foregroundStyle(.brown)
                }
            }
        }
        .task {
            if let imageUrl = data.imageUrl {
                imageResult = await assetVm.fetchImage(by: imageUrl)
            }
        }
    }
    
    @ViewBuilder var cellImage: some View {
        switch imageResult {
        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        case .failure:
            RoundedRectangle(cornerRadius: 8)
                .fill(.red)
        case nil:
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray)
        }
    }
    
    struct CellData: Equatable {
        let id: String
        let name: String
        let cuisineName: String
        let imageUrl: String?
    }
}

#Preview("Cell", traits: .modifier(BundleImageAssetPreviewData())) {
    RecipeCell(
        data: .init(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            name: "Apam Balik",
            cuisineName: "Malaysian",
            imageUrl: "UIImage_1"
        )
    )
    .padding()
}
