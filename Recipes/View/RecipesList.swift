struct RecipesList: View {
    let recipes: [RecipeCell.CellData]
    
    var body: some View {
        List {
            ForEach(recipes, id: \.id) {
                RecipeCell(data: $0)
            }
        }
    }
}

import RecipesRepository

#Preview {
    @Previewable @State var recipes = [RecipeCell.CellData]()
    RecipesList(recipes: recipes)
        .task {
            if let repositoryRecipe = try? await InMemoryRecipesRepository().fetchAllRecipes() {
                recipes = repositoryRecipe
                    .map {
                        RecipeCell.CellData.init(
                            id: $0.id,
                            name: $0.name,
                            cuisineName: $0.cuisine.title,
                            imageUrl: $0.photoUrl?.urlString
                        )
                    }
            }
        }
}

extension Recipe.CuisineType {
    var title: String {
        switch self {
        case .known(let knownCuisine):
            knownCuisine.rawValue.capitalized
        case .custom(let customCuisine):
            customCuisine.capitalized
        }
    }
}

extension Recipe.PhotoUrl {
    var urlString: String {
        switch self {
        case .small(let urlString):
            urlString
        case .large(let urlString):
            urlString
        }
    }
}

