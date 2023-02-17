//
//  JokeVC.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 02.02.2023.
//

import UIKit

class DetailJokeVC: UIViewController {
    
    static var shared = DetailJokeVC()
    private var imageStar = UIImage(systemName: "star")
    private var jokeIsSaved = false {
        didSet{
            let imageName = jokeIsSaved ? "star.fill" : "star"
            imageStar = UIImage(systemName: imageName)
        }
    }
    
    var category: String?
    var jokeData = DataJoke(id: "", value: "", categories: [""], created_at: "")
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateCreationLabel: UILabel!
    @IBOutlet weak var generateNewJokeButton: UIButton!
    @IBOutlet weak var jokeLabel: UILabel!
    
    var generateNewJokeButtonIsHidden: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageStar,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(addJokeInFavorite))
        fetchCategoryJoke()
        checkIfJokeIsSaved()
        showGenerateNewJokeButton()
    }
    
    @IBAction func getNewJokeTapped(_ sender: Any) {
        fetchCategoryJoke()
    }
    
    func showGenerateNewJokeButton() {
        if generateNewJokeButtonIsHidden == true {
            generateNewJokeButton.isHidden = true
        } else {
            generateNewJokeButton.isHidden = false
        }
    }
    
    @objc func addJokeInFavorite() {
        if jokeIsSaved {
            UserDefaultManager.shared.deleteDataJoke(data: jokeData)
        } else {
            UserDefaultManager.shared.saveDataJoke(data: jokeData)
        }
        jokeIsSaved.toggle()
        navigationItem.rightBarButtonItem?.image = imageStar
    }
    
    func checkIfJokeIsSaved() {
        let arrayOfSavedJoke = UserDefaultManager.shared.get()
        
        self.jokeIsSaved = false
        arrayOfSavedJoke.forEach { data in
            print("array\(data.id)", "joke \(jokeData.id)")
            if data.id == jokeData.id {
                self.jokeIsSaved = true
            }
        }
        self.navigationItem.rightBarButtonItem?.image = self.imageStar
    }
    
    func fetchCategoryJoke() {
        if let category = DetailJokeVC.shared.category {
            
            Webservice().getJoke(category: category) { (result) in
                switch result {
                case .success(let jokes):
                    self.jokeData = jokes
                    DispatchQueue.main.async {
                        self.jokeLabel.text = jokes.value
                        if category != "random" {
                            self.categoryLabel.text = "Category: \(category)"
                        } else {
                            self.fetchCategoriyFromData(data: self.jokeData)
                        }
                        
                        self.dateCreationLabel.text = jokes.created_at
                    }
                case .failure(let error):
                    debugPrint("Error \(error.localizedDescription)")
                }
            }
        } else {
            jokeLabel.text = jokeData.value
            fetchCategoriyFromData(data: jokeData)
            dateCreationLabel.text = "Created at: \(jokeData.created_at)"
        }
    }
    
    func fetchCategoriyFromData(data: DataJoke) {
        if data.categories.isEmpty {
            categoryLabel.text = "Category: general"
        } else {
            let textLabel = data.categories.joined(separator: " , ")
            categoryLabel.text = "Category: \(textLabel)"
        }
    }
}
