//Roberto Uriel Alcázar Hernández
//Jhiovani Alexander Bautista Coutiño
//Henry Rodrigo Gordillo Villatoro
//Edgar Adrián Vázquez González

import Foundation

class PostService {
    static let shared = PostService()
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"
    private let encoder = JSONEncoder()
    
    private init() {}
    
    // GET
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        print(" fetchPosts iniciado")
        
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "URL inválida", code: -1)))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sin datos", code: -1)))
                }
                return
            }
            
            do {
                // 🔥 FIX SWIFT 6
                let posts = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } catch {
                print(" Error decoding:", error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // POST
    func createPost(title: String, body: String, userId: Int, completion: @escaping (Result<Post, Error>) -> Void) {
        
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "URL inválida", code: -1)))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newPost = CreatePostRequest(title: title, body: body, userId: userId)
        
        do {
            request.httpBody = try encoder.encode(newPost)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sin datos", code: -1)))
                }
                return
            }
            
            do {
                // 🔥 FIX SWIFT 6
                let post = try JSONDecoder().decode(Post.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(post))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // PUT
    func updatePost(id: Int, title: String, body: String, completion: @escaping (Result<Post, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "URL inválida", code: -1)))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let update = UpdatePostRequest(title: title, body: body)
        
        do {
            request.httpBody = try encoder.encode(update)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Sin datos", code: -1)))
                }
                return
            }
            
            do {
                // 🔥 FIX SWIFT 6
                let post = try JSONDecoder().decode(Post.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(post))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // DELETE
    func deletePost(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "URL inválida", code: -1)))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
}
