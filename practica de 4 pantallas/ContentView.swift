//Roberto Uriel Alcázar Hernández
//Jhiovani Alexander Bautista Coutiño
//Henry Rodrigo Gordillo Villatoro
//Edgar Adrián Vázquez González

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsename = 0
    @State private var wrongPassword = 0
    @State private var showinLogimScreen = false
    @State private var showingSecondScreen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.brown
                    .ignoresSafeArea()
                Circle()
                    .scale(1.5)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack {
                    Text("Inicio de Sesiòn")
                        .foregroundStyle(.black)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Correo electronico", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.10))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsename))
                        .foregroundColor(.blue)
                        .accentColor(.blue)
                        .tint(Color.gray.opacity(0.07))
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.10))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                        .foregroundColor(.blue)
                        .accentColor(.blue)
                        .tint(Color.gray.opacity(0.07))
                    
                    Button("Iniciar") {
                        showingSecondScreen = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                .navigationDestination(isPresented: $showingSecondScreen) {
                    SecondScreenView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}

