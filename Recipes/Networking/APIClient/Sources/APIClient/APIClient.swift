//
//  APIClient.swift
//
//  Created by Peter Wu on 1/21/25.
//

import Foundation

final class APIClient {
    private lazy var baseComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components
    }()
    
    private let scheme: String
    private let host: String
    private let session: URLSession
    
    private let decoder = JSONDecoder()
        
    init(
        session: URLSession = .shared,
        scheme: String = "https",
        host: String
    ) {
        self.scheme = scheme
        self.host = host
        self.session = session
    }
    
    func fetch<T: Sendable & Decodable>(path: String, headers: [String: String]? = nil, queries: [String: String]? = nil) async throws -> T {
        // TODO: separate concerns on components / request / response parsing
        // Adds query items and path to url component
        var component = baseComponents
        component.path = path
        if let queries {
            component.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        }
        
        // Creates url from components
        guard let url = component.url else {
            throw APIError.errorCreatingUrlFrom(component)
        }
        
        // Create url request (add any headers)
        var request = URLRequest(url: url)
        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Make network request
        let (data, response) = try await session.data(for: request)
        
        // parse response
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(response)
        }
        
        let statusCode = response.statusCode
        switch statusCode {
        case (200..<300):
            // proceed to decode data
            return try decoder.decode(T.self, from: data)
        default:
            // TODO: Handle error
            throw APIError.responseError(statusCode: statusCode, data: data)
        }
    }
}

extension APIClient {
    enum APIError: Error {
        case errorCreatingUrlFrom(URLComponents)
        case invalidResponse(URLResponse)
        case responseError(statusCode: Int, data: Data)
    }
}
