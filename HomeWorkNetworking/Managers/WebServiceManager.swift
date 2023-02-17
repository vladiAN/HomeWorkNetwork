//
//  СhucknorrisManager.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 10.02.2023.
//

import UIKit

struct SearchJoke: Codable {
    let result: [DataJoke]
}

struct DataJoke: Codable {
    let id: String
    let value: String
    let categories: [String]
    let created_at: String
}

struct Webservice {
    
    private let categoriesUrl = "https://api.chucknorris.io/jokes/categories"
    private let randomJokeUrl = "https://api.chucknorris.io/jokes/random"
    private let jokeCategoryUrl = "https://api.chucknorris.io/jokes/random?category="
    private let searchJokeURL = "https://api.chucknorris.io/jokes/search?query="
    
    func getJoke(category: String, completion: @escaping (Result<DataJoke, Error>) -> ()) {
        if category != "random" {
            request(fromURL: jokeCategoryUrl + category, completion: completion)
        } else {
            request(fromURL: randomJokeUrl, completion: completion)
        }
    }
    
    func getCategories(completion: @escaping (Result<[String], Error>) -> ()) {
        let url = categoriesUrl
        request(fromURL: url, completion: completion)
    }
    
    func searchJoke(searchRequest: String, completion: @escaping (Result<SearchJoke, Error>) -> ()) {
        let url = searchJokeURL + searchRequest
        
        request(fromURL: url, completion: completion)
    }
    
    
    func request<T: Decodable>(fromURL url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            let error = NSError(domain: "com.example.jokeservice", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from API"])
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

