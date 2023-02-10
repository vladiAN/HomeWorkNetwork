//
//  ViewController.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 01.02.2023.
//

import Foundation
import UIKit

struct SearchJoke: Decodable {
    var total: Int
    var result: [String: String]
}


class MenuViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuTableView: UITableView!
    
    let searchController = UISearchController()
    
    var filteredData: [String]!
    var totalCellForJoke: Int?
    var searchRequest: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        //fetchJoke()
    }
    
    func fetchJoke() {
        let randomJokeString = "https://api.chucknorris.io/jokes/search?query="
        
        guard let url = URL(string: randomJokeString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let searchJoke = try JSONDecoder().decode(SearchJoke.self, from: data)
                print(searchJoke.total)
                DispatchQueue.main.async {
                    self.totalCellForJoke = searchJoke.total
                }
                
            } catch let error {
                print("error json", error)
            }
        }.resume()
    }
    
    
}


extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        //cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalCellForJoke = totalCellForJoke {
            return totalCellForJoke
        } else {
            return 0
        }
    }

}

extension MenuViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 75
        }
    
}
