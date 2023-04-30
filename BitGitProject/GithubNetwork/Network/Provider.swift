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
    
    func getInfo(success: (([GitHubModel]) -> Void)?, failure: (()-> Void)?)
    {
        provider.request(.GitHub){ result in
            switch result {
                case .success(let responce):
                    guard let result = try?
                            responce.mapArray(GitHubModel.self) else {
                        failure?()
                        return
                    }
                    success?(result)
                case .failure(let _):
                    failure?()
            }
            
        }
    }
    

}
