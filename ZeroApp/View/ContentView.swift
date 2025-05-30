//
//  ContentView.swift
//  ZeroApp
//
//  Created by kevin arica ramos on 22/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var reservations: [Reservation]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo de imagen con overlay
                Image("fondoReservas")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: 4)
                    .overlay(Color.black.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mis Reservas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Catering para tu ocasión especial")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)
                    
                    if !reservations.isEmpty {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(reservations) { reservation in
                                    NavigationLink(destination: DetailReservationView(reservation: reservation)) {
                                        ReservationCard(reservation: reservation)
                                    }
                                }
                                .onDelete(perform: deleteReservations)
                            }
                            .padding(.top)
                        }
                    } else {
                        Spacer()
                        Text("No hay reservas")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.title3)
                        Spacer()
                    }
                }
                .padding(20) // ⭐️ Padding general para todo el contenido
                
                // Botón flotante
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateReservationView()) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Nueva Reserva")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private func deleteReservations(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(reservations[index])
            }
        }
    }
}

struct ReservationCard: View {
    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(reservation.serviceType)
                    .font(.headline)
                Spacer()
                Text("S/ \(Int(reservation.totalPrice))")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Image(systemName: "calendar")
                Text(reservation.formattedEventDate)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "clock")
                Text(reservation.formattedTimeRange)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "person.2.fill")
                Text("\(reservation.guestCount) invitados")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Reservation.self, inMemory: true)
}
