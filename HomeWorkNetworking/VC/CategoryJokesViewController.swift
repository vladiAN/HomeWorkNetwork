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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCategories()
    }
    
    
    func fetchCategories() {
        
        Webservice().getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.categories.append("random")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                debugPrint("Error \(error.localizedDescription)")
            }
        }

    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category
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
        
        DetailJokeVC.shared.category = category
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DetailJokeVC") as! DetailJokeVC
        vc.generateNewJokeButtonIsHidden = false
    }
}

