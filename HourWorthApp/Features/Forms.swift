import SwiftUI

struct ProjectFormView: View {
    @Environment(\.dismiss) private var dismiss; @Environment(AppRepository.self) private var repository
    @State private var title = ""
    @State private var clientID: UUID?
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 14, to: .now) ?? .now
    @State private var billing = BillingModel.fixed
    @State private var value = 0.0
    @State private var target = 75.0
    @State private var estimate = 20.0
    var body: some View { NavigationStack { Form { Section(AppStrings.Projects.basicInformation) { TextField(AppStrings.Projects.projectTitle, text: $title); Picker(AppStrings.Projects.client, selection: $clientID) { Text(AppStrings.Projects.selectClient).tag(UUID?.none); ForEach(repository.clients) { Text($0.name).tag(Optional($0.id)) } }; DatePicker(AppStrings.Projects.delivery, selection: $dueDate, displayedComponents: .date) }; Section(AppStrings.Projects.pricing) { Picker(AppStrings.Projects.billing, selection: $billing) { ForEach(BillingModel.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented); HStack { Text(billing == .fixed ? AppStrings.Projects.agreedValue : AppStrings.Projects.hourlyRate); Spacer(); TextField("0", value: $value, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }; HStack { Text(AppStrings.Projects.desiredRate); Spacer(); TextField("75", value: $target, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }; HStack { Text(AppStrings.Projects.estimatedHours); Spacer(); TextField("20", value: $estimate, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) } } } .navigationTitle(AppStrings.Projects.newProject).toolbar { ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) { save() }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || clientID == nil || value <= 0 || estimate <= 0) } } } }
    private func save() { guard let client = repository.clients.first(where: { $0.id == clientID }) else { return }; repository.addProject(Project(title: title, clientID: client.id, clientName: client.name, dueDate: dueDate, billingModel: billing, agreedValue: billing == .fixed ? value : 0, hourlyRate: billing == .hourly ? value : 0, desiredRate: target, estimatedHours: estimate)); dismiss() }
}

struct PaymentFormView: View {
    @Environment(\.dismiss) private var dismiss; @Environment(AppRepository.self) private var repository; let projectID: UUID
    @State private var amount = 0.0
    @State private var date = Date()
    @State private var method = "Bank transfer"
    @State private var status = PaymentStatus.paid
    @State private var reference = ""
    var body: some View { NavigationStack { Form { Section(AppStrings.Payments.section) { TextField(AppStrings.Payments.amount, value: $amount, format: .number).keyboardType(.decimalPad); DatePicker(AppStrings.Payments.date, selection: $date, displayedComponents: .date); Picker(AppStrings.Payments.method, selection: $method) { ForEach(["Pix", "Wise", "PayPal", "Bank transfer"], id: \.self, content: Text.init) }; Picker(AppStrings.Payments.status, selection: $status) { ForEach(PaymentStatus.allCases, id: \.self) { Text($0.rawValue) } }; TextField(AppStrings.Payments.reference, text: $reference) }; Section { Label(AppStrings.Payments.securityNote, systemImage: "lock.shield").font(.caption).foregroundStyle(HWTheme.secondary) } }.navigationTitle(AppStrings.Payments.title).toolbar { ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) { repository.addPayment(Payment(amount: amount, date: date, method: method, status: status, reference: reference), to: projectID); dismiss() }.disabled(amount <= 0) } } } }
}
