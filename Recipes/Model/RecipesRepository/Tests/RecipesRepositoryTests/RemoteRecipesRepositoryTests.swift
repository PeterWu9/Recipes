//
//  RemoteRecipesRepositoryTests.swift
//  RecipesTests
//
//  Created by Peter Wu on 1/24/25.
//
@testable import RecipesRepository
import Testing

struct RemoteRecipesRepositoryTests {

    @Test func allRecipes() async throws {
        let repository = RemoteRecipesRepository.allRecipes
        let recipes = try await repository.fetchAllRecipes()
        #expect(!recipes.isEmpty)
    }
    
    @Test func malformedRecipesData() async throws {
        let repository = RemoteRecipesRepository.malFormed
        await #expect(throws: RemoteRecipesRepository.RemoteRecipesError.self, performing: {
            _ = try await repository.fetchAllRecipes()
        })
    }
    
    @Test func emptyData() async throws {
        let repository = RemoteRecipesRepository.empty
        let recipes = try await repository.fetchAllRecipes()
        #expect(recipes.isEmpty)
    }

}
