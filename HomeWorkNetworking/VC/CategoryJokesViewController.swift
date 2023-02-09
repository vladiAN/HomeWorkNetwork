//
//  CategoryJokesViewController.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 02.02.2023.
//

import Foundation
import UIKit


class CategoryJokesViewController: UIViewController {
    
    private var categories = [String]()
    private var jokeCategories: String?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchData()
    }
    
    
    func fetchData() {
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/categories") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
               let _ = response,
                let data = data
            else { return }
            
            do {
                self.categories = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //print(self.categories)
            } catch {
                print(error)
            }
        }.resume()
    }
    
   
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category
        print(category)
    }
    
}

extension CategoryJokesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
}

extension CategoryJokesViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        jokeCategories = category
        
        JokeVC.shared.category = category
    }
}

