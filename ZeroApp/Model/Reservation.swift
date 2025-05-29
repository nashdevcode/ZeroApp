import Foundation
import SwiftData

@Model
class Reservation {
    var id: UUID
    var serviceType: String // "Boda", "Empresarial", "Fiesta"
    var eventDate: Date // Fecha del evento (día, mes, año)
    var startTime: Date // Hora de inicio
    var endTime: Date // Hora de fin
    var guestCount: Int // Número de invitados
    var totalPrice: Double // Precio total
    var isConfirmed: Bool // Estado de confirmación
    var createdAt: Date // Fecha de creación de la reserva
    
    // Propiedades computadas para facilitar el uso
    var eventDateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: eventDate)
    }
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var durationInHours: Double {
        duration / 3600
    }
    
    var formattedEventDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: eventDate)
    }
    
    var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
    
    init(serviceType: String, eventDate: Date, startTime: Date, endTime: Date, guestCount: Int, totalPrice: Double) {
        // Validación: no permitir fechas pasadas
        let today = Calendar.current.startOfDay(for: Date())
        let eventDay = Calendar.current.startOfDay(for: eventDate)
        
        guard eventDay >= today else {
            fatalError("No se pueden crear reservas para fechas pasadas")
        }
        
        // Validación: hora de fin debe ser mayor que hora de inicio
        guard endTime > startTime else {
            fatalError("La hora de fin debe ser posterior a la hora de inicio")
        }
        
        // Validación adicional: si es hoy, las horas deben ser futuras
        if Calendar.current.isDate(eventDate, inSameDayAs: Date()) {
            guard startTime > Date() else {
                fatalError("Para reservas de hoy, la hora debe ser futura")
            }
        }
        
        self.id = UUID()
        self.serviceType = serviceType
        self.eventDate = eventDate
        self.startTime = startTime
        self.endTime = endTime
        self.guestCount = guestCount
        self.totalPrice = totalPrice
        self.isConfirmed = false
        self.createdAt = Date()
    }
}
