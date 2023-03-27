//
//  APIService.swift
//  CodingProject
//
//  Created by Tung Truong on 23/03/2023.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    
    case missingRequiredFields(String)
    
    case invalidParameters(operation: String, parameters: [Any])
    
    case badRequest
    
    case unauthorized
    
    case paymentRequired
    
    case forbidden
    
    case notFound
    
    case requestEntityTooLarge

    case unprocessableEntity
    
    case http(httpResponse: HTTPURLResponse, data: Data)
    
    case invalidResponse(Data)
    
    case deleteOperationFailed(String)
    
    case network(URLError)
    
    case unknown(Error?)

}

protocol APIServiceProtocol {
    func fetchApi(url: String) async throws -> [Movie]
    func getImage(imageString: String) async throws -> Data
}

class APIService {
    static func urlString(keyword: String) -> String {
        return "https://www.omdbapi.com/?s=\(keyword)&apikey=\(APIKey)"
    }
}

extension APIService: APIServiceProtocol {
    func fetchApi(url: String) async throws -> [Movie] {
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        let (data, response) = try await URLSession.shared.data(for: request)
        let fetchedData = try JSONDecoder().decode(MovieResponseModel.self, from: try mapResponse(response: (data,response)))

        return fetchedData.search ?? []
    }

    func getImage(imageString: String) async throws -> Data {
        let imagePath = URL(string: imageString)
        let request = URLRequest(url: imagePath!)
        let (data, _) = try await URLSession.shared.data(for: request)

        return data
    }


    private func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return response.data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 402:
            throw NetworkError.paymentRequired
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 413:
            throw NetworkError.requestEntityTooLarge
        case 422:
            throw NetworkError.unprocessableEntity
        default:
            throw NetworkError.http(httpResponse: httpResponse, data: response.data)
        }
    }
}
