//Roberto Uriel Alcázar Hernández
//Jhiovani Alexander Bautista Coutiño
//Henry Rodrigo Gordillo Villatoro
//Edgar Adrián Vázquez González

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
