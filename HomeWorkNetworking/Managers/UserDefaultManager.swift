//
//  UserDefaultManager.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 16.02.2023.
//

import Foundation

class UserDefaultManager {

    static var shared = UserDefaultManager()

    let defaults = UserDefaults.standard
    
    let key = "SavedJoke"
    
    var savedJoke = [DataJoke]()
    
    func saveDataJoke(data: DataJoke) {
        savedJoke.append(data)
        if let newJokeData = try? JSONEncoder().encode(savedJoke) {
            defaults.set(newJokeData, forKey: key)
        } else {
            print("data not saved")
        }
    }
    
    func deleteDataJoke(data: DataJoke) {
        savedJoke.removeAll(where: { $0.value == data.value })
        let saveJokeData = try! JSONEncoder().encode(savedJoke)
        defaults.set(saveJokeData, forKey: key)
    }
    
    func get() -> [DataJoke] {
        if let data = defaults.data(forKey: key) {
            let decoder = JSONDecoder()
            let resiveJoke = try? decoder.decode([DataJoke].self, from: data)
            return resiveJoke ?? []
        } else { return [] }
        
    }
}
