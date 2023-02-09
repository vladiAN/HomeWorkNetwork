//
//  RandomJokeVC.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 02.02.2023.
//

import Foundation
import UIKit

struct Jokes: Decodable {
    
    let value: String
    
}

class RandomJokeVC: UIViewController {
    
    @IBOutlet weak var jokeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJoke()
    }
    
    func fetchJoke() {
        let randomJokeString = "https://api.chucknorris.io/jokes/random"
        
        guard let url = URL(string: randomJokeString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let joke = try JSONDecoder().decode(Jokes.self, from: data)
                print(joke.value)
                DispatchQueue.main.async {
                    self.jokeText.text = joke.value
                }
                
            } catch let error {
                print("error json", error)
            }
        }.resume()
    }
}
