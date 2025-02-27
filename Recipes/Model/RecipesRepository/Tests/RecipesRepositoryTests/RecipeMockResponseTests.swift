//
//  RecipeMockResponseTests.swift
//  RecipesTests
//
//  Created by Peter Wu on 1/21/25.
//
import Foundation
import Testing
@testable import RecipesRepository
@testable import SharedResources

struct RecipeMockResponseTests {
    enum RecipeMockResponseTestsError: Error {
        case unableToLocateResource(name: String, extension: String)
    }
    
    
    /// Tests decoding mocks
    @Test func decodeMock() async throws {
        // Locate resource from bundle
        // SharedResources.decode(type: RecipesResponseDTO.self, fileName: "", fileExtension: "")
        let response = try SharedResources.decode(
            type: RecipesResponseDTO.self,
            fileName: "RecipesResponseAllRecipes",
            fileExtension: ".json"
        )
        // Asserts on recipes response dto from json file
        let firstRecipe = try #require(response.recipes.first)
        #expect(firstRecipe.cuisine == "Malaysian")
    }
}
