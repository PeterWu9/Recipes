//
//  Result+.swift
//  Recipes
//
//  Created by Peter Wu on 1/27/25.
//

extension Result {
    init(catching body: () async throws(Failure) -> Success) async {
        do {
            self = try await .success(body())
        } catch {
            self = .failure(error)
        }
    }
}
