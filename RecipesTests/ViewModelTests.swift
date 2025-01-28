//
//  ViewModelTests.swift
//  RecipesTests
//
//  Created by Peter Wu on 1/28/25.
//

@testable import Recipes
@testable import RecipesRepository
import Testing

struct ViewModelTests {
    
    @Test func loadingStateFullLoad() async throws {
        let repository = RemoteRecipesRepository.allRecipes
        let vm = await ViewModel(repository: repository)
        await vm.fetchAllRecipes()
        let fetchedFromRepository = try await repository.fetchAllRecipes().map {
            RecipeCell
            .CellData.init(
                id: $0.id,
                name: $0.name,
                cuisineName: $0.cuisine.title,
                imageUrl: $0.photoUrl?.urlString
            )}
        await #expect(
            vm.loadingState == .loaded(.withLoad(fetchedFromRepository))
        )
    }

}
