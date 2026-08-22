import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }.tabItem { Label(Localizable.Tabs.home, systemImage: "house.fill") }
            NavigationStack { ProjectsView() }.tabItem { Label(Localizable.Tabs.projects, systemImage: "briefcase.fill") }
            NavigationStack { TrackView() }.tabItem { Label(Localizable.Tabs.track, systemImage: "timer") }
            NavigationStack { ActivityView() }.tabItem { Label(Localizable.Tabs.activity, systemImage: "calendar") }
            NavigationStack { ClientsView() }.tabItem { Label(Localizable.Tabs.clients, systemImage: "person.2.fill") }
        }
    }
}
