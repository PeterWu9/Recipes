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
    @State private var imageResult: ImageAssetViewModel.ImageResult?
    
    var body: some View {
        HStack(alignment: .center) {
            Group {
                switch imageResult {
                case .loaded(let uIImage):
                    Image(uiImage: uIImage)
                        .aspectRatio(contentMode: .fill)
                case .withError:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.red)
                case nil:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                }
            }
            .frame(width: 100, height: 100)
            .clipped()
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.headline)
                Text(data.cuisineName)
                    .font(.subheadline)
                    .foregroundStyle(.brown)
            }
        }
        .task {
            if let imageUrl = data.imageUrl {
                imageResult = await assetVm.fetchImage(by: imageUrl)
            }
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
