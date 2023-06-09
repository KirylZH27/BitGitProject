//
//  Provider.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import Foundation
import Moya
import Moya_ObjectMapper

final class MoyaLoaderProvider: RepositoriesGetter {
    
    enum Error: LocalizedError {
        case invalidParse
        case noInternetConnection
        case timeOut
        case unknownError
        case serverNotAvalable
        
        var errorDescription: String? {
            switch self {
                case .invalidParse:
                    return "Cant parse repositories"
                case .noInternetConnection:
                    return "Check your Internet connetcion"
                case .timeOut:
                    return "Request limit exceeded"
                case .unknownError:
                    return "Something went wrong"
                case .serverNotAvalable:
                    return "Server not avalable"
            }
        }
    }
    
    private let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func getRepositories(completion: @escaping ( Result<[RepositoriesModel], MoyaLoaderProvider.Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var repositoriesArray: [RepositoriesModel] = []
        var dispatchError: Error?
        
        //MARK: - Получение репозиториев из GitHub
        dispatchGroup.enter()
        getGitHubModels { result in
            let repositoriesModels = result.map { $0.convertToRepositoriesModel() }
            repositoriesArray += repositoriesModels
            dispatchGroup.leave()
        } failure: { error in
            dispatchError = error
            dispatchGroup.leave()
        }
        
        //MARK: - Получение репозиториев из BitBucket
        dispatchGroup.enter()
        getBitBucketModels { result in
            repositoriesArray += result.convertToRepositoriesModels()
            dispatchGroup.leave()
        } failure: { error in
            dispatchError = error
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            if let error = dispatchError {
                completion(.failure(error))
                return
            }
            completion(.success(repositoriesArray))
        }
    }
    
    private func getGitHubModels(success: (([GitHubModel]) -> Void)?, failure: ((MoyaLoaderProvider.Error)-> Void)?)
    {
        provider.request(.GitHub){ result in
            switch result {
                case .success(let responce):
                    guard let result = try?
                            responce.mapArray(GitHubModel.self) else {
                        failure?(.invalidParse)
                        return
                    }
                    success?(result)
                case .failure(let error):
                    let customError = self.createCustomError(error: error)
                    failure?(customError)
            }
        }
    }
    
    private func getBitBucketModels(success: ((BitBucketModel) -> Void)?, failure: ((MoyaLoaderProvider.Error)-> Void)?)
    {
        provider.request(.BitBucket){ result in
            switch result {
                case .success(let responce):
                    guard let result = try?
                            responce.mapObject(BitBucketModel.self) else {
                        failure?(.invalidParse)
                        return
                    }
                    success?(result)
                case .failure(let error):
                    let customError = self.createCustomError(error: error)
                    failure?(customError)
            }
        }
    }
    private func createCustomError(error: MoyaError) -> MoyaLoaderProvider.Error {
        switch error.errorCode {
            case 500...510:
                return .serverNotAvalable
            case 401:
                return .noInternetConnection
            case 403:
                return .timeOut
            default:
                return .unknownError
        }
    }
}
