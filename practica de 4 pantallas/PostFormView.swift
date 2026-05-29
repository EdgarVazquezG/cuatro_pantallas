//
//  PostFormView.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 26/03/26.
//
import SwiftUI

struct PostFormView: View {
    @Environment(\.dismiss) var dismiss
    let post: Post?
    let service: PostService
    let onSaved: (Post) -> Void
    let onDelete: ((Post) -> Void)? // 🔥 NUEVO
    
    @State private var title: String
    @State private var bodyText: String
    
    @State private var showingSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    
    @State private var showDeleteConfirm = false // 🔥 confirmar eliminación
    
    init(
        post: Post?,
        service: PostService,
        onSaved: @escaping (Post) -> Void,
        onDelete: ((Post) -> Void)? = nil
    ) {
        self.post = post
        self.service = service
        self.onSaved = onSaved
        self.onDelete = onDelete
        
        if let post = post {
            _title = State(initialValue: post.title)
            _bodyText = State(initialValue: post.body)
        } else {
            _title = State(initialValue: "")
            _bodyText = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Detalles") {
                    TextField("Título", text: $title)
                    TextField("Contenido", text: $bodyText, axis: .vertical)
                }
                
                Section {
                    
                    // BOTÓN CREAR / ACTUALIZAR
                    Button {
                        save()
                    } label: {
                        HStack {
                            Image(systemName: post == nil ? "plus.circle.fill" : "pencil.circle.fill")
                            Text(post == nil ? "Crear Post" : "Actualizar")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty || bodyText.isEmpty)
                    
                    // 🔥 BOTÓN ELIMINAR (SOLO SI ES EDICIÓN)
                    if let post = post {
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Eliminar Post")
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(post == nil ? "Nuevo Post" : "Editar Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            
            // 🔥 CONFIRMACIÓN DE BORRADO
            .alert("¿Eliminar post?", isPresented: $showDeleteConfirm) {
                Button("Eliminar", role: .destructive) {
                    deletePost()
                }
                Button("Cancelar", role: .cancel) { }
            }
            
            // ALERTA ÉXITO
            .alert("Éxito", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
            
            // ALERTA ERROR
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - SAVE
    private func save() {
        if let post = post {
            service.updatePost(id: post.id, title: title, body: bodyText) { result in
                switch result {
                case .success:
                    let updatedPost = Post(
                        id: post.id,
                        title: title,
                        body: bodyText,
                        userId: post.userId
                    )
                    
                    onSaved(updatedPost)
                    alertMessage = "Post actualizado correctamente"
                    showingSuccessAlert = true
                    
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
            
        } else {
            service.createPost(title: title, body: bodyText, userId: 1) { result in
                switch result {
                case .success(let newPost):
                    
                    // 🔥 ID local único
                    let localPost = Post(
                        id: Int.random(in: 1000...9999),
                        title: title,
                        body: bodyText,
                        userId: 1
                    )
                    
                    onSaved(localPost)
                    alertMessage = "Post creado correctamente"
                    showingSuccessAlert = true
                    
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
    
    // MARK: - DELETE
    private func deletePost() {
        guard let post = post else { return }
        
        // 🔥 eliminar local inmediatamente
        onDelete?(post)
        
        // 🔥 intentar borrar en API (opcional)
        service.deletePost(id: post.id) { _ in }
        
        dismiss()
    }
}
