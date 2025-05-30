//
//  User.swift
//  ZeroApp
//
//  Created by kevin arica ramos on 29/05/25.
//

import Foundation
import SwiftData

@Model
class User {
    var id: UUID
    var nombre: String
    var email: String
    var password: String
    var fechaRegistro: Date

    init(nombre: String, email: String, password: String) {
        self.id = UUID()
        self.nombre = nombre
        self.email = email
        self.password = password
        self.fechaRegistro = Date()
    }
}
