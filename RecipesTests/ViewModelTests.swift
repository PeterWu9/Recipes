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
    
    @Test func loadingStateEmpty() async throws {
        let vm = await ViewModel(repository: RemoteRecipesRepository.empty)
        await vm.fetchAllRecipes()
        await #expect(vm.loadingState == .loaded(.empty))
    }
    
    @Test func loadingStateWithError() async throws {
        let repository = RemoteRecipesRepository.malFormed
        let vm = await ViewModel(repository: RemoteRecipesRepository.malFormed)
        await vm.fetchAllRecipes()
        do {
            _ = try await repository.fetchAllRecipes()
        } catch {
            await #expect(
                vm.loadingState ==
                    .loaded(.withError(error.localizedDescription))
            )
        }
    }

}
