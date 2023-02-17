//
//  FavoriteVC.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 08.02.2023.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var tableSavedJoke: UITableView!
    
    var savedJoke = [DataJoke]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorite joke"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedJoke()
    }
    
    private func setupTableView() {
        tableSavedJoke.delegate = self
        tableSavedJoke.dataSource = self
        tableSavedJoke.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func getSavedJoke() {
        let data = UserDefaultManager.shared.get()
        savedJoke = data
        tableSavedJoke.reloadData()
    }
}

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedJoke.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableSavedJoke.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let textOfJoke = savedJoke[indexPath.row].value
        cell.textLabel?.text = textOfJoke

        let categoryJoke = savedJoke[indexPath.row].categories

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
        
        vc.jokeData = savedJoke[indexPath.row]
        vc.generateNewJokeButtonIsHidden = true
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
