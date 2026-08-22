import SwiftUI

struct ActivityView: View {
    @Environment(AppRepository.self) private var repository; @State private var month = Date()
    private var sessions: [WorkSession] { repository.sessions.filter { Calendar.current.isDate($0.startedAt, equalTo: month, toGranularity: .month) } }
    var body: some View { List { Section { HStack { Button { month = Calendar.current.date(byAdding: .month, value: -1, to: month) ?? month } label: { Image(systemName: "chevron.left") }; Spacer(); Text(month.formatted(.dateTime.month(.wide).year())).font(.headline); Spacer(); Button { month = Calendar.current.date(byAdding: .month, value: 1, to: month) ?? month } label: { Image(systemName: "chevron.right") } } }; Section { HWCard { HStack { VStack(alignment: .leading) { Text(sessions.reduce(0) { $0 + $1.duration }.durationLabel).font(.title.bold()).monospacedDigit(); Text("tracked this month").foregroundStyle(HWTheme.secondary) }; Spacer(); Image(systemName: "chart.bar.fill").font(.largeTitle).foregroundStyle(HWTheme.purple) } }.listRowInsets(EdgeInsets()) }; if sessions.isEmpty { EmptyState(icon: "calendar", title: "No activity", message: "Tracked and manual sessions will appear here.").listRowBackground(Color.clear) } else { Section("Work history") { ForEach(sessions) { session in HStack { VStack(alignment: .leading) { Text(session.projectTitle).font(.headline); Text(session.startedAt.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundStyle(HWTheme.secondary) }; Spacer(); Text(session.duration.durationLabel).monospacedDigit() } } } } }.navigationTitle("Activity") }
}

struct ClientsView: View {
    @Environment(AppRepository.self) private var repository
    @State private var search = ""
    @State private var showingNew = false
    private var clients: [Client] { repository.clients.filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) || $0.company.localizedCaseInsensitiveContains(search) } }
    var body: some View { List { if clients.isEmpty { EmptyState(icon: "person.2", title: "No clients", message: "Add a client before creating a project.").listRowBackground(Color.clear) } else { ForEach(clients) { client in VStack(alignment: .leading, spacing: 7) { HStack { Circle().fill(HWTheme.purple.opacity(0.12)).frame(width: 44, height: 44).overlay(Text(client.name.prefix(1)).font(.headline).foregroundStyle(HWTheme.purple)); VStack(alignment: .leading) { Text(client.name).font(.headline); if !client.company.isEmpty { Text(client.company).foregroundStyle(HWTheme.secondary) } }; Spacer(); let count = repository.projects.filter { $0.clientID == client.id && $0.status == .active }.count; Text("\(count) active").font(.caption).foregroundStyle(HWTheme.secondary) } } } } }.navigationTitle("Clients").searchable(text: $search).toolbar { Button { showingNew = true } label: { Image(systemName: "plus") }.accessibilityLabel("New client") }.sheet(isPresented: $showingNew) { ClientFormView() } }
}

struct ClientFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRepository.self) private var repository
    @State private var name = ""
    @State private var company = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var notes = ""
    var body: some View { NavigationStack { Form { Section("Client") { TextField("Name", text: $name); TextField("Company (optional)", text: $company) }; Section("Contact") { TextField("Email (optional)", text: $email).keyboardType(.emailAddress).textInputAutocapitalization(.never); TextField("Phone (optional)", text: $phone).keyboardType(.phonePad) }; Section("Notes") { TextEditor(text: $notes).frame(minHeight: 90) } }.navigationTitle("New client").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { repository.addClient(Client(name: name, company: company, email: email, phone: phone, notes: notes)); dismiss() }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty) } } } }
}
