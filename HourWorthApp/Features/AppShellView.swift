import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }.tabItem { Label("Home", systemImage: "house.fill") }
            NavigationStack { ProjectsView() }.tabItem { Label("Projects", systemImage: "briefcase.fill") }
            NavigationStack { TrackView() }.tabItem { Label("Track", systemImage: "timer") }
            NavigationStack { ActivityView() }.tabItem { Label("Activity", systemImage: "calendar") }
            NavigationStack { ClientsView() }.tabItem { Label("Clients", systemImage: "person.2.fill") }
        }
    }
}

