//
//  SecondScreenView.swift
//  secuencia_de_pantallas
//
//  Created by Jose Daniel Espinoza Gomez on 13/02/26.
//

import SwiftUI

struct SecondScreenView: View {
    var body: some View {
        VStack {
                    Spacer()
            TabView {
                ProductosView()
                    .tabItem {
                        Label("Productos", systemImage: "house.fill")
                    }
                VentasView()
                    .tabItem {
                        Label("Ventas", systemImage: "cart.fill")
                    }
                ConfigView()
                    .tabItem {
                        Label("Config", systemImage: "gear.fill")
                    }
            }
            .accentColor(.gray)
                }
                .padding()
    }
}
#Preview {
    SecondScreenView()
}
