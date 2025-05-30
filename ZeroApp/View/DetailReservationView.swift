//
//  DetailReservationView.swift
//  ZeroApp
//
//  Created by Victor Martinez on 29/05/25.
//

import SwiftUI
import SwiftData

struct DetailReservationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let reservation: Reservation
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header con tipo de servicio y estado
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(reservation.serviceType)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("Reserva #\(reservation.id.uuidString.prefix(8))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                // Información del evento
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Información del Evento", icon: "calendar")
                    
                    DetailRow(label: "Fecha del Evento", value: reservation.formattedEventDate, icon: "calendar.circle")
                    
                    DetailRow(label: "Horario", value: reservation.formattedTimeRange, icon: "clock.circle")
                    
                    DetailRow(label: "Duración", value: String(format: "%.1f horas", reservation.durationInHours), icon: "timer")
                    
                    DetailRow(label: "Número de Invitados", value: "\(reservation.guestCount) personas", icon: "person.2.circle")
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Información financiera
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Información Financiera", icon: "dollarsign.circle")
                    
                    DetailRow(label: "Tarifa por Hora", value: "S/ \(String(format: "%.2f", reservation.totalPrice / reservation.durationInHours))", icon: "clock.arrow.2.circlepath")
                    
                    DetailRow(label: "Precio Total", value: "S/ \(String(format: "%.2f", reservation.totalPrice))", icon: "creditcard.circle", valueColor: .green, isHighlighted: true)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Información de la reserva
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Detalles de la Reserva", icon: "info.circle")
                    
                    DetailRow(label: "Fecha de Creación", value: formatCreatedDate(), icon: "plus.circle")
                    
                    DetailRow(label: "ID de Reserva", value: reservation.id.uuidString, icon: "number.circle")
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Botones de acción
                VStack(spacing: 12) {
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Eliminar Reserva")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Detalle de Reserva")
        .navigationBarTitleDisplayMode(.inline)
        .alert("¿Eliminar Reserva?", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                deleteReservation()
            }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
        .sheet(isPresented: $showingEditView) {
            // Aquí puedes crear una vista de edición si la necesitas
            Text("Vista de edición (por implementar)")
        }
    }
    
    private func formatCreatedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: reservation.createdAt)
    }
    
    private func deleteReservation() {
        modelContext.delete(reservation)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error al eliminar la reserva: \(error)")
        }
    }
}

// MARK: - Helper Views
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    let icon: String
    var valueColor: Color = .primary
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? .headline : .subheadline)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundColor(valueColor)
        }
    }
}

#Preview {
    // Para el preview, creamos una reserva de ejemplo
    NavigationView {
        DetailReservationView(reservation: Reservation(
            serviceType: "Boda",
            eventDate: Date().addingTimeInterval(86400 * 7), // 7 días en el futuro
            startTime: Date().addingTimeInterval(86400 * 7 + 3600 * 14), // 7 días + 14 horas
            endTime: Date().addingTimeInterval(86400 * 7 + 3600 * 18), // 7 días + 18 horas
            guestCount: 150,
            totalPrice: 1000.0
        ))
    }
    .modelContainer(for: Reservation.self, inMemory: true)
}
