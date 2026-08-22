import Testing
import Foundation
@testable import HourWorth

struct ProjectMetricsTests {
    @Test func fixedPriceMetricsIncludePartialPayment() {
        let clientID = UUID(), projectID = UUID()
        let project = Project(id: projectID, title: "Website", clientID: clientID, clientName: "Client", agreedValue: 4_000, desiredRate: 100, estimatedHours: 40, payments: [Payment(amount: 1_500)])
        let sessions = [WorkSession(projectID: projectID, projectTitle: project.title, startedAt: .distantPast, endedAt: .distantPast.addingTimeInterval(20 * 3600))]
        let metrics = ProjectMetrics(project: project, sessions: sessions)
        #expect(metrics.trackedHours == 20)
        #expect(metrics.value == 4_000)
        #expect(metrics.received == 1_500)
        #expect(metrics.pending == 2_500)
        #expect(metrics.effectiveRate == 200)
    }

    @Test func hourlyValueUsesTrackedTime() {
        let projectID = UUID(), project = Project(id: projectID, title: "App", clientID: UUID(), clientName: "Client", billingModel: .hourly, hourlyRate: 120, desiredRate: 100, estimatedHours: 10)
        let sessions = [WorkSession(projectID: projectID, projectTitle: project.title, startedAt: .distantPast, endedAt: .distantPast.addingTimeInterval(5 * 3600))]
        #expect(ProjectMetrics(project: project, sessions: sessions).value == 600)
    }

    @Test func strongCompletionRequiresEstimateAndRateTargets() {
        let projectID = UUID(), project = Project(id: projectID, title: "Launch", clientID: UUID(), clientName: "Client", agreedValue: 2_000, desiredRate: 100, estimatedHours: 20)
        let sessions = [WorkSession(projectID: projectID, projectTitle: project.title, startedAt: .distantPast, endedAt: .distantPast.addingTimeInterval(18 * 3600))]
        let metrics = ProjectMetrics(project: project, sessions: sessions)
        #expect(CompletionResult(project: project, metrics: metrics).health == .strong)
    }
}
