//
//  ZeroAppApp.swift
//  ZeroApp
//
//  Created by kevin arica ramos on 22/05/25.
//

import SwiftUI
import SwiftData

@main
struct ZeroAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Reservation.self)
    }
}
