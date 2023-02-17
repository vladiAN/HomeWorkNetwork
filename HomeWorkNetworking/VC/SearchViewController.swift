//
//  ViewController.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 01.02.2023.
//

import Foundation
import UIKit


class SearchViewController: UIViewController {
    
    private var timer: Timer?
    
    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var resultOfSeach = [DataJoke]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        title = "Search joke"
        setupTableView()
        setupSearchBar()
        
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultOfSeach.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let textOfJoke = resultOfSeach[indexPath.row].value
        cell.textLabel?.text = textOfJoke
        
        let categoryJoke = resultOfSeach[indexPath.row].categories
        
        if categoryJoke.isEmpty {
            cell.detailTextLabel?.text = "category: general"
        } else {
            let allCategory = categoryJoke.joined(separator: " , ")
            cell.detailTextLabel?.text = "category: \(allCategory)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DetailJokeVC") as! DetailJokeVC
        
        vc.jokeData = resultOfSeach[indexPath.row]
        vc.generateNewJokeButtonIsHidden = true

        navigationController?.pushViewController(vc, animated: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var checkChar = ""
        
        searchText.forEach { char in
             char == " " ? checkChar.append("_") : checkChar.append(char)
        }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { Timer in
            Webservice().searchJoke(searchRequest: checkChar) { [weak self] result in
                switch result {
                case .success(let resultOfSearch):
                    self?.resultOfSeach = resultOfSearch.result
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                    }
                case .failure(let error):
                    debugPrint("Error \(error.localizedDescription)")
                }
            }
        })
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.resultOfSeach.removeAll()
        self.table.reloadData()
    }
}



