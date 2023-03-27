//
//  HomeViewModel.swift
//  CodingProject
//
//  Created by Tung Truong on 23/03/2023.
//

import Foundation
public enum DataError: Error {
    case noData
}
final class HomeViewModel {
    private let apiService: APIServiceProtocol
    var listMovies: [Movie]?
    var imageData: Data?
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchMovieResult(urlString: String) {
        Task {
            do {
                listMovies = try await apiService.fetchApi(url: urlString)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchImage(imageString: String, completion: @escaping(Result<Data,DataError>) -> Void) {
        
        Task {
            do {
                imageData = try await apiService.getImage(imageString: imageString)
                completion(.success(imageData!))
            } catch {
                completion(.failure(.noData))
            }
            
        }
    }
}
