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
    typealias CellData = ViewModel.CellData
    let recipesData: [CellData]
    
    @State private var recipes = [CellData]()
    @State private var sortSelection = SortSelection.name
    @State private var orderSelection = Order.alphabetical
    @State private var query = ""
    
    init(recipes: [CellData]) {
        self.recipesData = recipes
    }
    
    enum SortSelection: String, CaseIterable {
        case name, cuisine
    }
    enum Order: String, CaseIterable {
        case alphabetical = "A-Z"
        case alphabeticalReversed = "Z-A"
        
        var sortOrder: SortOrder {
            switch self {
            case .alphabetical: .forward
            case .alphabeticalReversed: .reverse
            }
        }
    }

    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(recipes) {
                RecipeCell(data: $0)
            }
        }
        .searchable(
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search by name or cuisine")
        )
        .task {
            self.recipes = recipesData.sorted(using: KeyPathComparator(\.name))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Sort By") {
                    Picker("Cuisine or Name", selection: $sortSelection) {
                        ForEach(SortSelection.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                                .tag($0)
                        }
                    }
                    Picker("Order", selection: $orderSelection) {
                        ForEach(Order.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                }
            }
        }
        .onChange(of: query, { _, _ in
            filterAndSort()
        })
        .onChange(of: sortSelection, { _, _ in
            filterAndSort()
        })
        .onChange(of: orderSelection) { _, _ in
            filterAndSort()
        }
    }
    
    private func filterAndSort() {
        let query = query.lowercased()
        recipes = recipesData
            .lazy
            .filter {
                guard !query.isEmpty else {
                    return true
                }
                return $0.name
                    .lowercased()
                    .contains(query)
                || $0.cuisineName.lowercased()
                    .contains(query)
            }
            .sorted(using: comparator(sortSelection, orderSelection))
    }
    
    private func comparator(_ sortSelection: SortSelection, _ orderSelection: Order) -> KeyPathComparator<CellData> {
        switch sortSelection {
        case .cuisine:
            KeyPathComparator(\.cuisineName, order: orderSelection.sortOrder)
        case .name:
            KeyPathComparator(\.name, order: orderSelection.sortOrder)
        }
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

extension ViewModel.CellData: Identifiable { }
