//
//  UIImageView+Extension.swift
//  BitGitProject
//
//  Created by Кирилл Жогальский on 30.04.23.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        if let imageResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            image = UIImage(data: imageResponse.data)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, let response = response else { return }
                self?.image = UIImage(data: data)
                self?.saveImageInCache(response: response, data: data, imageURL: url.absoluteString)
            }
        }.resume()
    }
    private func saveImageInCache(response: URLResponse, data: Data, imageURL: String) {
        guard let url = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        
    }
}

