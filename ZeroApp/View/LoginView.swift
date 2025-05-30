//
//  LoginView.swift
//  ZeroApp
//
//  Created by Victor Martinez on 29/05/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Binding var mostrarRegistro: Bool
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    @Environment(\.modelContext) private var modelContext
    @Query var usuarios: [User]

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 6)
                .overlay(Color.black.opacity(0.3))

            VStack(spacing: 20) {
                Spacer().frame(height: 100)

                Text("Catering de eventos\npara tu ocasión especial")
                    .font(.custom("Didot", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .shadow(radius: 2)

                Spacer()

                TextField("Correo", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                    .keyboardType(.emailAddress)

                SecureField("Contraseña", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)

                Button("Iniciar sesión") {
                    iniciarSesion()
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal, 30)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                HStack {
                    Text("¿No tienes cuenta?")
                        .foregroundColor(.white)
                    Button("Regístrate") {
                        mostrarRegistro = true
                    }
                    .foregroundColor(.blue)
                }

                Spacer().frame(height: 60)
            }
            .padding(.top, 40)
        }
    }

    func iniciarSesion() {
        if let usuario = usuarios.first(where: { $0.email == email && $0.password == password }) {
            print("Bienvenido, \(usuario.nombre)!")
            errorMessage = ""
            isLoggedIn = true
        } else {
            errorMessage = "Correo o contraseña incorrectos"
        }
    }
}

#Preview {
    LoginView(mostrarRegistro: .constant(false), isLoggedIn: .constant(false))
        .modelContainer(for: User.self, inMemory: true)
}
