import SwiftUI

struct HomeView: View {
    @Environment(AppRepository.self) private var repository
    private var active: [Project] { repository.projects.filter { $0.status == .active } }
    private var metrics: [ProjectMetrics] { active.map { ProjectMetrics(project: $0, sessions: repository.sessions) } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 4) { Text("Good \(greeting)").font(.largeTitle.bold()); Text(Date.now.formatted(.dateTime.month(.wide).year())).foregroundStyle(HWTheme.secondary) }
                hero
                if let session = repository.activeSession { ActiveSessionCard(session: session) }
                sectionHeader("Active projects", detail: "\(active.count) ongoing")
                if active.isEmpty { EmptyState(icon: "briefcase", title: "No active projects", message: "Create a project to start tracking its real value.") }
                else { ForEach(active.prefix(3)) { project in NavigationLink(value: project) { ProjectRow(project: project).foregroundStyle(.primary) }.buttonStyle(.plain) } }
                sectionHeader("Needs attention", detail: "Next deadline")
                if let next = active.sorted(by: { $0.dueDate < $1.dueDate }).first { HWCard { Label(next.title, systemImage: "calendar.badge.clock").font(.headline); Text(next.dueDate.formatted(date: .abbreviated, time: .omitted)).foregroundStyle(HWTheme.warning).padding(.top, 4) } }
            }.padding(20)
        }.background(HWTheme.background).navigationDestination(for: Project.self) { ProjectDetailView(projectID: $0.id) }
    }
    private var hero: some View {
        let received = metrics.reduce(0) { $0 + $1.received }, pending = metrics.reduce(0) { $0 + $1.pending }, hours = metrics.reduce(0) { $0 + $1.trackedHours }
        return VStack(alignment: .leading, spacing: 18) {
            Text("THIS MONTH").font(.caption.bold()).foregroundStyle(.white.opacity(0.7))
            Text(received.money).font(.system(size: 40, weight: .bold)).monospacedDigit().foregroundStyle(.white)
            Text("received across active work").foregroundStyle(.white.opacity(0.75))
            Divider().overlay(.white.opacity(0.2))
            HStack { metric("Tracked", hours.hoursLabel); Spacer(); metric("Pending", pending.money); Spacer(); metric("Projects", "\(active.count)") }
        }.padding(24).background(LinearGradient(colors: [HWTheme.purple, HWTheme.deep], startPoint: .topLeading, endPoint: .bottomTrailing)).clipShape(RoundedRectangle(cornerRadius: 24))
    }
    private func metric(_ label: String, _ value: String) -> some View { VStack(alignment: .leading, spacing: 3) { Text(value).font(.headline).monospacedDigit(); Text(label).font(.caption).opacity(0.7) }.foregroundStyle(.white) }
    private func sectionHeader(_ title: String, detail: String) -> some View { HStack { Text(title).font(.title3.bold()); Spacer(); Text(detail).font(.subheadline).foregroundStyle(HWTheme.secondary) } }
    private var greeting: String { let hour = Calendar.current.component(.hour, from: .now); return hour < 12 ? "morning" : hour < 18 ? "afternoon" : "evening" }
}

struct ActiveSessionCard: View {
    @Environment(AppRepository.self) private var repository; let session: WorkSession
    var body: some View { TimelineView(.periodic(from: .now, by: 1)) { context in HWCard { HStack { Image(systemName: "timer").font(.title2).foregroundStyle(HWTheme.purple); VStack(alignment: .leading) { Text(session.projectTitle).font(.headline); Text(context.date.timeIntervalSince(session.startedAt).clock).font(.title3.monospacedDigit()).foregroundStyle(HWTheme.secondary) }; Spacer(); Button("Stop") { repository.stop() }.buttonStyle(.borderedProminent) } } } }
}

extension TimeInterval { var clock: String { let seconds = max(0, Int(self)); return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, seconds % 60) } }

