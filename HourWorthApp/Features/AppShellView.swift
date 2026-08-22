import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }.tabItem { Label(AppStrings.Tabs.home, systemImage: "house.fill") }
            NavigationStack { ProjectsView() }.tabItem { Label(AppStrings.Tabs.projects, systemImage: "briefcase.fill") }
            NavigationStack { TrackView() }.tabItem { Label(AppStrings.Tabs.track, systemImage: "timer") }
            NavigationStack { ActivityView() }.tabItem { Label(AppStrings.Tabs.activity, systemImage: "calendar") }
            NavigationStack { ClientsView() }.tabItem { Label(AppStrings.Tabs.clients, systemImage: "person.2.fill") }
        }
    }
}
