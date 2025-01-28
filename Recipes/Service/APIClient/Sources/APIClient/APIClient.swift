//
//  APIClient.swift
//
//  Created by Peter Wu on 1/21/25.
//

import Foundation

public final class APIClient: Sendable {
    private let baseComponents: URLComponents
    private let scheme: String
    private let host: String
    private let session: URLSession
    
    private let decoder = JSONDecoder()
        
    public init(
        session: URLSession = .shared,
        scheme: String = "https",
        host: String
    ) {
        self.scheme = scheme
        self.host = host
        self.session = session
        self.baseComponents = {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            return components
        }()
    }
    
    public func fetch<T: Sendable & Decodable>(path: String, headers: [String: String]? = nil, queries: [String: String]? = nil) async throws -> T {
        // TODO: separate concerns on components / request / response parsing
        // Adds query items and path to url component
        var component = baseComponents
        if let queries {
            component.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        }
        
        // Creates url from components
        guard var url = component.url else {
            throw APIError.errorCreatingUrlFrom(component)
        }
        
        url.append(path: path)
        
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
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error as DecodingError {
                throw APIError
                    .errorDecoding(
                        data: data,
                        description: error.localizedDescription,
                        error: error
                    )
            } catch {
                throw error
            }
        default:
            // TODO: Handle error
            throw APIError.responseError(statusCode: statusCode, data: data)
        }
    }
}

extension APIClient {
    public enum APIError: Error {
        case errorCreatingUrlFrom(URLComponents)
        case invalidResponse(URLResponse)
        case responseError(statusCode: Int, data: Data)
        case errorDecoding(data: Data, description: String, error: Error)
    }
}
