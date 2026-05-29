//Roberto Uriel Alcázar Hernández
//Jhiovani Alexander Bautista Coutiño
//Henry Rodrigo Gordillo Villatoro
//Edgar Adrián Vázquez González

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
