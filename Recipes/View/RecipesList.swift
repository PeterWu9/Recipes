//
//  RecipesList.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//
import Cache
import ImageLoader
import RecipesRepository
import SwiftUI

struct RecipesList: View {
    let recipesData: [RecipeCell.CellData]
    
    @State private var recipes: [RecipeCell.CellData]
    @State private var nameSortSelection = SortSelection.default
    
    init(recipes: [RecipeCell.CellData]) {
        self.recipesData = recipes
        _recipes = .init(wrappedValue: recipes)
    }
    
    enum SortSelection: String {
        case alphabetical = "A-Z"
        case alphabeticalReversed = "Z-A"
        case `default` = "default"
    }

    var body: some View {
        let _ = Self._printChanges()
        LazyVStack(alignment: .leading) {
            ForEach(recipes) {
                RecipeCell(data: $0)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Sort By") {
                    Picker("Name", selection: $nameSortSelection) {
                        Text(SortSelection.default.rawValue)
                            .tag(SortSelection.default)
                        Text(SortSelection.alphabetical.rawValue)
                            .tag(SortSelection.alphabetical)
                        Text(SortSelection.alphabeticalReversed.rawValue)
                            .tag(SortSelection.alphabeticalReversed)
                    }
                }
            }
        }
        .onChange(of: nameSortSelection, { _, newValue in
                switch newValue {
                case .alphabetical:
                    recipes = recipesData.sorted(using: KeyPathComparator(\.name))
                case .alphabeticalReversed:
                    recipes = recipesData
                        .sorted(using: KeyPathComparator(\.name, order: .reverse))
                case .default:
                    recipes = recipesData
                }
        })
    }
}

struct PreviewContainer: View {
    @State private var viewModel = ViewModel(
        repository: InMemoryRecipesRepository(
            configuration: .init(mode: .allRecipes)
        )
    )
    @State private var imageAssetViewModel = ImageAssetViewModel.init(
        imageService: BundleImageLoader(
            maxLoadingTime: 1,
            cache: InMemoryCache()
        )
    )
    var body: some View {
        NavigationStack {
            ScrollView {
                RecipesList(recipes: viewModel.allRecipes)
                    .padding()
                    .task {
                        await viewModel.fetchAllRecipes()
                    }
            }
        }
        .environment(viewModel)
        .environment(imageAssetViewModel)
    }
}

#Preview {
    PreviewContainer()
}

// TODO: Investigate - maybe a bug in traits not able to work with @State?
//#Preview(
//    traits: .modifier(AllRecipesPreviewData()), .modifier(BundleImageAssetPreviewData())
//) {
//    AllRecipesPreviewContainer { recipes in
//        ScrollView {
//            RecipesList(recipes: recipes)
//        }
//    }
//    .padding()
//}

extension RecipeCell.CellData: Identifiable { }
