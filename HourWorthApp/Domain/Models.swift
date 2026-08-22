import Foundation

enum BillingModel: String, CaseIterable, Codable, Identifiable { case fixed = "Fixed price", hourly = "Hourly"; var id: Self { self } }
enum ProjectStatus: String, CaseIterable, Codable { case active = "Active", paused = "Paused", completed = "Completed" }
enum Priority: String, CaseIterable, Codable { case low = "Low", medium = "Medium", high = "High" }
enum TaskStatus: String, CaseIterable, Codable { case todo = "To do", inProgress = "In progress", completed = "Completed" }
enum PaymentStatus: String, CaseIterable, Codable { case expected = "Expected", paid = "Paid", cancelled = "Cancelled" }

struct Client: Identifiable, Codable, Hashable {
    var id = UUID(); var name: String; var company = ""; var email = ""; var phone = ""; var notes = ""
}

struct ProjectTask: Identifiable, Codable, Hashable {
    var id = UUID(); var title: String; var status: TaskStatus = .todo; var priority: Priority = .medium
}

struct Payment: Identifiable, Codable, Hashable {
    var id = UUID(); var amount: Double; var date = Date(); var method = "Bank transfer"; var status: PaymentStatus = .paid; var reference = ""
}

struct WorkSession: Identifiable, Codable, Hashable {
    var id = UUID(); var projectID: UUID; var projectTitle: String; var startedAt: Date; var endedAt: Date?; var note = ""
    var duration: TimeInterval { max(0, (endedAt ?? .now).timeIntervalSince(startedAt)) }
}

struct Project: Identifiable, Codable, Hashable {
    var id = UUID(); var title: String; var clientID: UUID; var clientName: String; var summary = ""
    var startDate = Date(); var dueDate = Calendar.current.date(byAdding: .day, value: 14, to: .now) ?? .now
    var billingModel: BillingModel = .fixed; var agreedValue = 0.0; var hourlyRate = 0.0; var desiredRate = 75.0
    var estimatedHours = 20.0; var priority: Priority = .medium; var status: ProjectStatus = .active
    var tasks: [ProjectTask] = []; var payments: [Payment] = []
}

struct ProjectMetrics: Equatable {
    let trackedHours: Double, value: Double, received: Double, pending: Double, effectiveRate: Double, progress: Double
    init(project: Project, sessions: [WorkSession]) {
        trackedHours = sessions.filter { $0.projectID == project.id }.reduce(0) { $0 + $1.duration } / 3600
        value = project.billingModel == .fixed ? project.agreedValue : trackedHours * project.hourlyRate
        received = project.payments.filter { $0.status == .paid }.reduce(0) { $0 + $1.amount }
        pending = max(0, value - received)
        effectiveRate = trackedHours > 0 ? value / trackedHours : 0
        progress = project.tasks.isEmpty ? min(1, trackedHours / max(project.estimatedHours, 1)) : Double(project.tasks.filter { $0.status == .completed }.count) / Double(project.tasks.count)
    }
}

enum ProjectHealth: String { case strong = "Strong result", healthy = "Healthy", attention = "Needs attention", poor = "Poor result" }

struct CompletionResult {
    let health: ProjectHealth; let message: String
    init(project: Project, metrics: ProjectMetrics) {
        let estimateRatio = metrics.trackedHours / max(project.estimatedHours, 1)
        let rateRatio = metrics.effectiveRate / max(project.desiredRate, 1)
        if estimateRatio <= 1 && rateRatio >= 1 { health = .strong; message = "You stayed within your estimate and met your target rate. Great planning." }
        else if estimateRatio <= 1.15 && rateRatio >= 0.85 { health = .healthy; message = "This project landed close to plan. Keep using these numbers for your next estimate." }
        else if estimateRatio <= 1.5 && rateRatio >= 0.6 { health = .attention; message = "The project drifted from the original plan. Review the time and added scope before pricing similar work." }
        else { health = .poor; message = "The return was well below your target. Use this result to protect your time on the next proposal." }
    }
}

