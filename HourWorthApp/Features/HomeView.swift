import SwiftUI

struct HomeView: View {
    @Environment(AppRepository.self) private var repository
    private var active: [Project] { repository.projects.filter { $0.status == .active } }
    private var metrics: [ProjectMetrics] { active.map { ProjectMetrics(project: $0, sessions: repository.sessions) } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: HWSpacing.extraLarge) {
                VStack(alignment: .leading, spacing: HWSpacing.extraSmall) { Text("Good \(greeting)").font(.largeTitle.bold()); Text(Date.now.formatted(.dateTime.month(.wide).year())).foregroundStyle(HWTheme.secondary) }
                hero
                if let session = repository.activeSession { ActiveSessionCard(session: session) }
                sectionHeader(AppStrings.Home.activeProjects, detail: AppStrings.Home.projectCount(active.count))
                if active.isEmpty { EmptyState(icon: "briefcase", title: AppStrings.Home.noActiveProjects, message: AppStrings.Home.noActiveProjectsMessage) }
                else { ForEach(active.prefix(3)) { project in NavigationLink(value: project) { ProjectRow(project: project).foregroundStyle(.primary) }.buttonStyle(.plain) } }
                sectionHeader(AppStrings.Home.needsAttention, detail: AppStrings.Home.nextDeadline)
                if let next = active.sorted(by: { $0.dueDate < $1.dueDate }).first { HWCard { Label(next.title, systemImage: "calendar.badge.clock").font(.headline); Text(next.dueDate.formatted(date: .abbreviated, time: .omitted)).foregroundStyle(HWTheme.warning).padding(.top, 4) } }
            }.padding(HWSpacing.screen)
        }.background(HWTheme.background).navigationDestination(for: Project.self) { ProjectDetailView(projectID: $0.id) }
    }
    private var hero: some View {
        let received = metrics.reduce(0) { $0 + $1.received }, pending = metrics.reduce(0) { $0 + $1.pending }, hours = metrics.reduce(0) { $0 + $1.trackedHours }
        return VStack(alignment: .leading, spacing: HWSpacing.card) {
            Text(AppStrings.Home.thisMonth).font(.caption.bold()).foregroundStyle(.white.opacity(0.7))
            Text(received.money).font(.system(size: 40, weight: .bold)).monospacedDigit().foregroundStyle(.white)
            Text(AppStrings.Home.receivedContext).foregroundStyle(.white.opacity(0.75))
            Divider().overlay(.white.opacity(0.2))
            HStack { metric("Tracked", hours.hoursLabel); Spacer(); metric("Pending", pending.money); Spacer(); metric("Projects", "\(active.count)") }
        }.padding(HWSpacing.extraLarge).background(LinearGradient(colors: [HWTheme.purple, HWTheme.deep], startPoint: .topLeading, endPoint: .bottomTrailing)).clipShape(RoundedRectangle(cornerRadius: HWRadius.hero))
    }
    private func metric(_ label: String, _ value: String) -> some View { VStack(alignment: .leading, spacing: 3) { Text(value).font(.headline).monospacedDigit(); Text(label).font(.caption).opacity(0.7) }.foregroundStyle(.white) }
    private func sectionHeader(_ title: String, detail: String) -> some View { HStack { Text(title).font(.title3.bold()); Spacer(); Text(detail).font(.subheadline).foregroundStyle(HWTheme.secondary) } }
    private var greeting: String { let hour = Calendar.current.component(.hour, from: .now); return hour < 12 ? "morning" : hour < 18 ? "afternoon" : "evening" }
}

struct ActiveSessionCard: View {
    @Environment(AppRepository.self) private var repository; let session: WorkSession
    var body: some View { TimelineView(.periodic(from: .now, by: 1)) { context in HWCard { HStack { Image(systemName: "timer").font(.title2).foregroundStyle(HWTheme.purple); VStack(alignment: .leading) { Text(session.projectTitle).font(.headline); Text(context.date.timeIntervalSince(session.startedAt).clock).font(.title3.monospacedDigit()).foregroundStyle(HWTheme.secondary) }; Spacer(); Button(AppStrings.Home.stop) { repository.stop() }.buttonStyle(.borderedProminent) } } } }
}

extension TimeInterval { var clock: String { let seconds = max(0, Int(self)); return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, seconds % 60) } }

