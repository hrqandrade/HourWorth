import Foundation
import Observation

@MainActor
@Observable
final class AppRepository {
    private(set) var clients: [Client] = []
    private(set) var projects: [Project] = []
    private(set) var sessions: [WorkSession] = []
    private let url: URL

    init(fileManager: FileManager = .default) {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        url = base.appending(path: "HourWorth/store.json")
        load()
        if clients.isEmpty && projects.isEmpty { seed() }
    }

    var activeSession: WorkSession? { sessions.first { $0.endedAt == nil } }
    func addClient(_ client: Client) { clients.append(client); save() }
    func addProject(_ project: Project) { projects.append(project); save() }
    func update(_ project: Project) { guard let index = projects.firstIndex(where: { $0.id == project.id }) else { return }; projects[index] = project; save() }
    func addPayment(_ payment: Payment, to id: UUID) { guard let index = projects.firstIndex(where: { $0.id == id }) else { return }; projects[index].payments.append(payment); save() }
    func toggleTask(_ taskID: UUID, projectID: UUID) { guard let pi = projects.firstIndex(where: { $0.id == projectID }), let ti = projects[pi].tasks.firstIndex(where: { $0.id == taskID }) else { return }; projects[pi].tasks[ti].status = projects[pi].tasks[ti].status == .completed ? .todo : .completed; save() }
    func start(project: Project, note: String) { guard activeSession == nil else { return }; sessions.insert(WorkSession(projectID: project.id, projectTitle: project.title, startedAt: .now, note: note), at: 0); save() }
    func stop() { guard let index = sessions.firstIndex(where: { $0.endedAt == nil }) else { return }; sessions[index].endedAt = .now; save() }
    func addManualSession(project: Project, hours: Double, date: Date, note: String) { let end = date.addingTimeInterval(hours * 3600); sessions.insert(WorkSession(projectID: project.id, projectTitle: project.title, startedAt: date, endedAt: end, note: note), at: 0); save() }

    private struct Snapshot: Codable { let clients: [Client]; let projects: [Project]; let sessions: [WorkSession] }
    private func load() { guard let data = try? Data(contentsOf: url), let value = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }; clients = value.clients; projects = value.projects; sessions = value.sessions }
    private func save() { try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true); if let data = try? JSONEncoder().encode(Snapshot(clients: clients, projects: projects, sessions: sessions)) { try? data.write(to: url, options: .atomic) } }
    private func seed() {
        let client = Client(name: "Maya Chen", company: "Northstar Studio", email: "maya@northstar.example")
        let project = Project(title: "Product launch website", clientID: client.id, clientName: client.name, summary: "Design and build the launch experience.", dueDate: Calendar.current.date(byAdding: .day, value: 8, to: .now) ?? .now, agreedValue: 4_800, desiredRate: 90, estimatedHours: 48, priority: .high, tasks: [ProjectTask(title: "Design responsive pages", status: .completed, priority: .high), ProjectTask(title: "Build CMS integration", status: .inProgress, priority: .high), ProjectTask(title: "Final QA", priority: .medium)], payments: [Payment(amount: 2_400, method: "Wise")])
        clients = [client]; projects = [project]
        sessions = [WorkSession(projectID: project.id, projectTitle: project.title, startedAt: Date().addingTimeInterval(-10800), endedAt: Date().addingTimeInterval(-3600), note: "Responsive homepage")]
        save()
    }
}
