//
//  RecipeMockResponseTests.swift
//  RecipesTests
//
//  Created by Peter Wu on 1/21/25.
//
import Foundation
import Testing
@testable import Recipes

struct RecipeMockResponseTests {
    enum RecipeMockResponseTestsError: Error {
        case unableToLocateResource(name: String, extension: String)
    }
    
    
    /// Tests decoding mocks
    @Test func decodeMock() async throws {
        // Locate resource from bundle
        let fileName = "RecipesResponseAllRecipes"
        let fileExtension = ".json"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw RecipeMockResponseTestsError
                .unableToLocateResource(
                    name: fileName,
                    extension: fileExtension
                )
        }
        // Fetch data from resource
        let data = try Data(contentsOf: url)
        // Deserialize data and decode into Recipes Response DTO
        let decoder = JSONDecoder()
        let response = try decoder.decode(RecipesResponseDTO.self, from: data)
        // Asserts on recipes response dto from json file
        let firstRecipe = try #require(response.recipes.first)
        #expect(firstRecipe.cuisine == "Malaysian")
    }

}
