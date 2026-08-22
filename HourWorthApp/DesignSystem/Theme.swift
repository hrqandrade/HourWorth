import SwiftUI

enum HWTheme {
    static let purple = Color(red: 109/255, green: 74/255, blue: 1)
    static let deep = Color(red: 48/255, green: 32/255, blue: 102/255)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let secondary = Color(uiColor: .secondaryLabel)
    static let success = Color(red: 22/255, green: 131/255, blue: 95/255)
    static let warning = Color(red: 184/255, green: 107/255, blue: 0)
}

struct HWCard<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { content }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.primary.opacity(0.05)))
    }
}

struct StatusBadge: View {
    let text: String; var color: Color = HWTheme.purple
    var body: some View { Text(text).font(.caption.weight(.semibold)).padding(.horizontal, 10).padding(.vertical, 6).foregroundStyle(color).background(color.opacity(0.12)).clipShape(.capsule).accessibilityLabel("Status: \(text)") }
}

extension Double {
    var money: String { formatted(.currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0...2))) }
    var hoursLabel: String { "\(formatted(.number.precision(.fractionLength(0...1))))h" }
}

extension TimeInterval { var durationLabel: String { (self / 3600).hoursLabel } }

struct EmptyState: View {
    let icon: String, title: String, message: String
    var body: some View { VStack(spacing: 10) { Image(systemName: icon).font(.system(size: 32)).foregroundStyle(HWTheme.purple); Text(title).font(.headline); Text(message).font(.subheadline).foregroundStyle(HWTheme.secondary).multilineTextAlignment(.center) }.frame(maxWidth: .infinity).padding(32) }
}
