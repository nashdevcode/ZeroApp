//
//  RegisterView.swift
//  ZeroApp
//
//  Created by Victor Martinez on 29/05/25.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @Binding var mostrarRegistro: Bool

    @State private var nombre = ""
    @State private var email = ""
    @State private var password = ""
    @State private var mensaje = ""

    @Environment(\.modelContext) private var modelContext

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

                Text("Crea tu cuenta")
                    .font(.custom("Didot", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .shadow(radius: 2)

                Spacer()

                TextField("Nombre", text: $nombre)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)

                TextField("Correo", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                    .keyboardType(.emailAddress)

                SecureField("Contraseña", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)

                Button("Registrarse") {
                    registrarUsuario()
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
                .padding(.horizontal, 30)

                if !mensaje.isEmpty {
                    Text(mensaje)
                        .foregroundColor(.yellow)
                        .padding(.horizontal)
                }

                HStack {
                    Text("¿Ya tienes cuenta?")
                        .foregroundColor(.white)
                    Button("Inicia sesión") {
                        mostrarRegistro = false
                    }
                    .foregroundColor(.blue)
                }

                Spacer().frame(height: 60)
            }
            .padding(.top, 40)
        }
    }

    func registrarUsuario() {
        guard !nombre.isEmpty, !email.isEmpty, !password.isEmpty else {
            mensaje = "Por favor, completa todos los campos."
            return
        }

        let nuevoUsuario = User(nombre: nombre, email: email, password: password)
        modelContext.insert(nuevoUsuario)
        mensaje = "Usuario registrado con éxito 🎉"
        print("Usuario guardado: \(nuevoUsuario.nombre)")

        // Limpiar los campos
        nombre = ""
        email = ""
        password = ""
    }
}

#Preview {
    RegisterView(mostrarRegistro: .constant(true))
        .modelContainer(for: User.self, inMemory: true)
}
