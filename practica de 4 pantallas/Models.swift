//
//  Models.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 26/03/26.
//
import Foundation

// MARK: - Modelos de Posts
struct Post: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

// MARK: - Requests
struct CreatePostRequest: Codable {
    let title: String
    let body: String
    let userId: Int
}

struct UpdatePostRequest: Codable {
    let title: String
    let body: String
}
