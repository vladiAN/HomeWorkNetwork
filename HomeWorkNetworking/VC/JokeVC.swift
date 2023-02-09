//
//  JokeVC.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 02.02.2023.
//

import UIKit

struct Categories: Decodable {
    
    let value: String
}


class JokeVC: UIViewController {
    
    static var shared = JokeVC()
    
    var category: String?
 
    
    @IBOutlet weak var jokeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJoke()
    }
    
    
    @IBAction func getNewJokeTapped(_ sender: Any) {
        fetchJoke()
    }
    
    func fetchJoke() {
        if let category = JokeVC.shared.category {
            print(category)
            
            let randomJokeString = "https://api.chucknorris.io/jokes/random?category=\(category)"
            
            guard let url = URL(string: randomJokeString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else { return }
                
                do {
                    let joke = try JSONDecoder().decode(Categories.self, from: data)
                    print(joke.value)
                    DispatchQueue.main.async {
                        self.jokeLabel.text = joke.value
                    }
                    
                } catch let error {
                    print("error json", error)
                }
            }.resume()
            
        } else { return }
        
    }
    
}
