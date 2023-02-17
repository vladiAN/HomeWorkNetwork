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
            navigationItem.rightBarButtonItem?.image = imageStar
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
        
        if let category = category {
            fetchCategoryJoke()
        } else {
            setUI()
        }
        
    
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
        guard let category = category else { return }
            Webservice().getJoke(category: category) { (result) in
                switch result {
                case .success(let jokes):
                    self.jokeData = jokes
                    DispatchQueue.main.async {
                        self.setUI()
                    }
                case .failure(let error):
                    debugPrint("Error \(error.localizedDescription)")
                }
            }
        }
    
    func setUI() {
        jokeLabel.text = jokeData.value
        categoryLabel.text = fetchCategoriyFromData(data: jokeData)
        dateCreationLabel.text = "Created at: \(jokeData.created_at)"
        
        checkIfJokeIsSaved()
    }
    
    func fetchCategoriyFromData(data: DataJoke) -> String {
        if data.categories.isEmpty {
            return "Category: general"
        } else {
            let textLabel = data.categories.joined(separator: " , ")
            return "Category: \(textLabel)"
        }
    }
}
