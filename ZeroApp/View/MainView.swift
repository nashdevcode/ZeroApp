//
//  MainView.swift
//  ZeroApp
//
//  Created by Victor Martinez on 29/05/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var mostrarRegistro = false
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            ContentView() // Tu pantalla de reservas
        } else {
            if mostrarRegistro {
                RegisterView(mostrarRegistro: $mostrarRegistro)
            } else {
                LoginView(mostrarRegistro: $mostrarRegistro, isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [User.self, Reservation.self], inMemory: true)
}
