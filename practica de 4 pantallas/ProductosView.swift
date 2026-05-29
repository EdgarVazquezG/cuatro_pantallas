//
//  ProductosView.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 13/02/26.
//

import SwiftUI

struct ProductosView: View {
    @State private var searchText = ""
    @State private var showPostsView = false
    
    let products = [
        Product(id: 1, name: "Sillon", price: 12000, quantity: 5, imageName: "flower"),
        Product(id: 2, name: "Comedor", price: 10000, quantity: 3, imageName: "flower"),
        Product(id: 3, name: "Cama", price: 8900, quantity: 4, imageName: "flower"),
        Product(id: 4, name: "Colchon", price: 900, quantity: 4, imageName: "flower")
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                String(product.id).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField(" ", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Productos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPostsView = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Posts")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(red: 0, green: 0.1, blue: 0.3), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showPostsView) {
            PostListView()
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("Precio: $\(product.price)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Cantidad: \(product.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Total: $\(product.price * product.quantity)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Image(systemName: product.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct Product: Identifiable {
    let id: Int
    let name: String
    let price: Int
    let quantity: Int
    let imageName: String
}

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        Text("Detalle de \(product.name)")
            .font(.largeTitle)
    }
}
#Preview {
    ProductosView()
}

