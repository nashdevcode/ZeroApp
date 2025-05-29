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
        NavigationView {
            VStack {
                Text("Catering para tu ocasión especial")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Lista de reservas existentes
                if !reservations.isEmpty {
                    List {
                        ForEach(reservations) { reservation in
                            ReservationRowView(reservation: reservation)
                        }
                        .onDelete(perform: deleteReservations)
                    }
                } else {
                    Text("No hay reservas")
                        .foregroundColor(.gray)
                }
                Spacer()
                
                // Boton para crear nueva reserva
                NavigationLink(destination: CreateReservationView()) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Nueva Reserva")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle(Text("Mis Reservas"))
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

struct ReservationRowView: View {
    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(reservation.serviceType)
                    .font(.headline)
                Spacer()
                Text("S/\(Int(reservation.totalPrice))")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Text(reservation.formattedEventDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(reservation.formattedTimeRange)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(reservation.guestCount) invitados")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
