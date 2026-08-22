import SwiftUI

@main
struct HourWorthApp: App {
    @State private var repository = AppRepository()
    var body: some Scene { WindowGroup { AppShellView().environment(repository).tint(HWTheme.purple) } }
}

