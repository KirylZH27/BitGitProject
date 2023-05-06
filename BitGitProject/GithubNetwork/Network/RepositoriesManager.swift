//
//  RepositoriesManager.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 6.05.23.
//

import Foundation

protocol RepositoriesGetter {
    func getRepositories(completion: @escaping ( Result<[RepositoriesModel], Error>) -> Void)
}
final class RepositoriesManager: RepositoriesGetter {
    let moyaGetter: RepositoriesGetter
    
    init(moyaGetter: RepositoriesGetter) {
        self.moyaGetter = moyaGetter
    }
    
    func getRepositories(completion: @escaping (Result<[RepositoriesModel], Error>) -> Void) {
        moyaGetter.getRepositories(completion: completion)
    }
}
