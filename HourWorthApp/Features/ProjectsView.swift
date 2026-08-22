import SwiftUI

struct ProjectsView: View {
    @Environment(AppRepository.self) private var repository; @State private var search = ""; @State private var showCompleted = false; @State private var showingNew = false
    private var filtered: [Project] { repository.projects.filter { ($0.status == .completed) == showCompleted && (search.isEmpty || $0.title.localizedCaseInsensitiveContains(search) || $0.clientName.localizedCaseInsensitiveContains(search)) } }
    var body: some View { List { Picker("Status", selection: $showCompleted) { Text("Active").tag(false); Text("Completed").tag(true) }.pickerStyle(.segmented).listRowBackground(Color.clear); if filtered.isEmpty { EmptyState(icon: "briefcase", title: "No projects here", message: "Your projects will appear here.").listRowBackground(Color.clear) } else { ForEach(filtered) { project in NavigationLink(value: project) { ProjectRow(project: project) } } } }.listStyle(.insetGrouped).navigationTitle("Projects").searchable(text: $search).toolbar { Button { showingNew = true } label: { Image(systemName: "plus") }.accessibilityLabel("New project") }.sheet(isPresented: $showingNew) { ProjectFormView() }.navigationDestination(for: Project.self) { ProjectDetailView(projectID: $0.id) } }
}

struct ProjectRow: View {
    @Environment(AppRepository.self) private var repository; let project: Project
    var body: some View { let metrics = ProjectMetrics(project: project, sessions: repository.sessions); VStack(alignment: .leading, spacing: 10) { HStack { VStack(alignment: .leading, spacing: 3) { Text(project.title).font(.headline); Text(project.clientName).font(.subheadline).foregroundStyle(HWTheme.secondary) }; Spacer(); StatusBadge(text: project.status.rawValue, color: project.status == .completed ? HWTheme.success : HWTheme.purple) }; ProgressView(value: metrics.progress).tint(HWTheme.purple); HStack { Label(metrics.trackedHours.hoursLabel + " of " + project.estimatedHours.hoursLabel, systemImage: "clock"); Spacer(); Text(metrics.pending.money + " pending") }.font(.caption).foregroundStyle(HWTheme.secondary) }.padding(.vertical, 6) }
}

