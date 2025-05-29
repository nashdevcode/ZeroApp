import SwiftUI
import SwiftData

struct CreateReservationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedService = "Boda"
    @State private var eventDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var guestCount = 75
    @State private var hourlyRate: Double = 200.0
    @State private var showingDateAlert = false
    
    private let serviceTypes = ["Boda", "Empresarial", "Fiesta"]
    
    private var totalPrice: Double {
        let hours = endTime.timeIntervalSince(startTime) / 3600
        return max(hours, 0) * hourlyRate
    }
    
    // Validación de fecha - debe ser hoy o en el futuro
    private var isValidDate: Bool {
        Calendar.current.isDate(eventDate, inSameDayAs: Date()) || eventDate > Date()
    }
    
    // Fecha mínima permitida (hoy)
    private var minimumDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    // Validación adicional para horas si es el mismo día
    private var isValidTime: Bool {
        if Calendar.current.isDate(eventDate, inSameDayAs: Date()) {
            // Si es hoy, la hora de inicio debe ser mayor a la actual
            return startTime > Date() && endTime > startTime
        } else {
            // Si es fecha futura, solo validar que end > start
            return endTime > startTime
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Tipo de Servicio") {
                    Picker("Servicio", selection: $selectedService) {
                        ForEach(serviceTypes, id: \.self) { service in
                            Text(service).tag(service)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Fecha del Evento") {
                    DatePicker(
                        "Fecha",
                        selection: $eventDate,
                        in: minimumDate...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onChange(of: eventDate) { oldValue, newValue in
                        // Si cambia la fecha, ajustar las horas si es necesario
                        if Calendar.current.isDate(newValue, inSameDayAs: Date()) {
                            // Si selecciona hoy, asegurar que las horas sean futuras
                            let now = Date()
                            if startTime <= now {
                                startTime = Calendar.current.date(byAdding: .hour, value: 1, to: now) ?? now
                            }
                            if endTime <= startTime {
                                endTime = Calendar.current.date(byAdding: .hour, value: 2, to: startTime) ?? startTime
                            }
                        }
                    }
                    
                    if !isValidDate {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Solo se pueden hacer reservas para hoy o fechas futuras")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Section("Horario") {
                    DatePicker(
                        "Hora de Inicio",
                        selection: $startTime,
                        displayedComponents: [.hourAndMinute]
                    )
                    .onChange(of: startTime) { oldValue, newValue in
                        // Asegurar que endTime sea mayor que startTime
                        if newValue >= endTime {
                            endTime = Calendar.current.date(byAdding: .hour, value: 1, to: newValue) ?? newValue
                        }
                    }
                    
                    DatePicker(
                        "Hora de Fin",
                        selection: $endTime,
                        displayedComponents: [.hourAndMinute]
                    )
                    
                    // Validación de horarios para el día actual
                    if Calendar.current.isDate(eventDate, inSameDayAs: Date()) && startTime <= Date() {
                        HStack {
                            Image(systemName: "clock.badge.exclamationmark")
                                .foregroundColor(.red)
                            Text("La hora de inicio debe ser posterior a la hora actual")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    if !isValidTime {
                        HStack {
                            Image(systemName: "clock.badge.exclamationmark")
                                .foregroundColor(.red)
                            Text("La hora de fin debe ser posterior a la de inicio")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section("Detalles") {
                    HStack {
                        Text("Invitados")
                        Spacer()
                        TextField("Número", value: $guestCount, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Tarifa por hora")
                        Spacer()
                        TextField("Precio", value: $hourlyRate, format: .currency(code: "PEN"))
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                    }
                }
                
                Section("Resumen") {
                    HStack {
                        Text("Duración")
                        Spacer()
                        Text(String(format: "%.1f horas", max(endTime.timeIntervalSince(startTime) / 3600, 0)))
                    }
                    
                    HStack {
                        Text("Precio Total")
                        Spacer()
                        Text("S/\(Int(totalPrice))")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Nueva Reserva")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if isValidDate && isValidTime {
                            saveReservation()
                        } else {
                            showingDateAlert = true
                        }
                    }
                    .disabled(!isValidDate || !isValidTime)
                }
            }
        }
        .alert(isPresented: $showingDateAlert) {
            Alert(
                title: Text("Error en la reserva"),
                message: Text("Por favor, verifica que la fecha y hora sean válidas."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func saveReservation() {
        // Validación final antes de guardar
        guard isValidDate && isValidTime else {
            showingDateAlert = true
            return
        }
        
        let reservation = Reservation(
            serviceType: selectedService,
            eventDate: eventDate,
            startTime: startTime,
            endTime: endTime,
            guestCount: guestCount,
            totalPrice: totalPrice
        )
        
        modelContext.insert(reservation)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error al guardar la reserva: \(error)")
        }
    }
}

#Preview {
    CreateReservationView()
        .modelContainer(for: Reservation.self, inMemory: true)
}
