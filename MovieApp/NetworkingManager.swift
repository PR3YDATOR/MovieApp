//
//  NetworkingManager.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//

import Foundation

class NetworkingManager {

    static let shared = NetworkingManager()

    private let apiKey = "d4a989c8"
    private let baseURL = "https://www.omdbapi.com/"

    func searchForMovie(title: String, completion: @escaping (MovieModel?, Error?) -> Void) {
        guard let url = buildURL(for: title) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 1, userInfo: nil))
                return
            }

            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(MovieModel.self, from: data)
                completion(movie, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }

    private func buildURL(for title: String) -> URL? {
        let urlString = "\(baseURL)?t=\(title)&plot=full&apikey=\(apiKey)"
        return URL(string: urlString)
    }
}
