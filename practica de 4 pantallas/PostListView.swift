//
//  PostListView.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 26/03/26.
//

import SwiftUI

struct PostListView: View {
    @State private var posts: [Post] = []
    @State private var showCreateSheet = false
    @State private var selectedPost: Post? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    let service = PostService.shared
    let storage = LocalPostStorage()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // ERROR
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // LOADING
                if isLoading && posts.isEmpty {
                    ProgressView("Cargando posts...")
                } else {
                    List {
                        ForEach(posts) { post in
                            Button {
                                selectedPost = post
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(post.title).bold()
                                    Text(post.body)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                            }
                        }
                        .onDelete(perform: deletePost)
                    }
                }
            }
            .navigationTitle("Posts")
            
            // BOTÓN CREAR
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("＋") {
                        showCreateSheet = true
                    }
                }
            }
            
            // CARGA INICIAL
            .onAppear {
                let savedPosts = storage.load()
                
                if !savedPosts.isEmpty {
                    posts = savedPosts
                } else {
                    fetchPosts()
                }
            }
            
            // ✅ CREAR
            .sheet(isPresented: $showCreateSheet) {
                PostFormView(
                    post: nil,
                    service: service
                ) { newPost in
                    
                    posts.insert(newPost, at: 0)
                    storage.save(posts: posts)
                }
            }
            
            // ✅ EDITAR + ELIMINAR DESDE FORM
            .sheet(item: $selectedPost) { post in
                PostFormView(
                    post: post,
                    service: service,
                    
                    // 🔥 ACTUALIZAR
                    onSaved: { updatedPost in
                        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
                            posts[index] = updatedPost
                            storage.save(posts: posts)
                        }
                    },
                    
                    // 🔥 ELIMINAR DESDE FORMULARIO
                    onDelete: { deletedPost in
                        posts.removeAll { $0.id == deletedPost.id }
                        storage.save(posts: posts)
                    }
                )
            }
        }
    }
    
    // FETCH API
    private func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        service.fetchPosts { result in
            switch result {
            case .success(let fetchedPosts):
                posts = fetchedPosts
                storage.save(posts: fetchedPosts)
                isLoading = false
                
            case .failure(let error):
                errorMessage = "Error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // ELIMINAR DESDE LISTA
    private func deletePost(at offsets: IndexSet) {
        offsets.forEach { index in
            let postToDelete = posts[index]
            
            // 🔥 eliminar local SIEMPRE
            posts.remove(at: index)
            storage.save(posts: posts)
            
            // 🔥 intentar API (opcional)
            service.deletePost(id: postToDelete.id) { _ in }
        }
    }
}
