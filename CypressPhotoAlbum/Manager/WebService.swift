//
//  WebService.swift
//  CypressPhotoAlbum
//
//  Created by Decagon on 02/11/2022.
//

import Foundation
final class WebService {
    static let shared = WebService()

    func load<T: Codable>(from urlString: String, completion: @escaping ([T]) -> Void) {

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

            guard let data = data, error == nil else {  return }

            guard let result = try? JSONDecoder().decode([T].self, from: data) else { return }
            completion(result)

        }).resume()
    }

}
