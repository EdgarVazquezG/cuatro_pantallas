//
//  LocalPostStorage.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 27/03/26.
//
import Foundation

class LocalPostStorage {
    private let key = "local_posts"
    
    // Guardar posts
    func save(posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // Cargar posts
    func load() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }
}
