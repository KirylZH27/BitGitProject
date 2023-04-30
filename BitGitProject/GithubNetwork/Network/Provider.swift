//
//  Provider.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 26.04.23.
//

import Foundation
import Moya
import Moya_ObjectMapper

class Provider {
    private let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func getRepositories(completion: @escaping ( Result<[RepositoriesModel], Error>) -> Void) {
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
    
    private func getGitHubModels(success: (([GitHubModel]) -> Void)?, failure: ((Error)-> Void)?)
    {
        provider.request(.GitHub){ result in
            switch result {
                case .success(let responce):
                    guard let result = try?
                            responce.mapArray(GitHubModel.self) else {
                        let error = NSError(domain: "Cant parse GitHub", code: 404)
                        failure?(error)
                        return
                    }
                    success?(result)
                case .failure(let error):
                    failure?(error)
            }
        }
    }
    
    private func getBitBucketModels(success: ((BitBucketModel) -> Void)?, failure: ((Error)-> Void)?)
    {
        provider.request(.BitBucket){ result in
            switch result {
                case .success(let responce):
                    guard let result = try?
                            responce.mapObject(BitBucketModel.self) else {
                        let error = NSError(domain: "Cant parse BitBucket", code: 404)
                        failure?(error)
                        return
                    }
                    success?(result)
                case .failure(let error):
                    failure?(error)
            }
        }
    }
}
