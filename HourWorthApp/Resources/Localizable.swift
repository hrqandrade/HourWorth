import Foundation

enum Localizable {
    enum Tabs {
        static let home = "Home"
        static let projects = "Projects"
        static let track = "Track"
        static let activity = "Activity"
        static let clients = "Clients"
    }

    enum Common {
        static let cancel = "Cancel"
        static let save = "Save"
        static let finish = "Finish"
        static let active = "Active"
        static let completed = "Completed"
        static let project = "Project"
        static let selectProject = "Select a project"
        static let optionalNote = "Note (optional)"
        static let noActivity = "No activity"
    }

    enum Home {
        static let thisMonth = "THIS MONTH"
        static let receivedContext = "received across active work"
        static let tracked = "Tracked"
        static let pending = "Pending"
        static let projects = "Projects"
        static let activeProjects = "Active projects"
        static let ongoing = "ongoing"
        static let noActiveProjects = "No active projects"
        static let noActiveProjectsMessage = "Create a project to start tracking its real value."
        static let needsAttention = "Needs attention"
        static let nextDeadline = "Next deadline"
        static let stop = "Stop"

        static func greeting(_ period: String) -> String { "Good \(period)" }
        static func projectCount(_ count: Int) -> String { "\(count) ongoing" }
        static func pendingAmount(_ amount: String) -> String { "\(amount) pending" }
        static func hours(_ tracked: String, of estimate: String) -> String { "\(tracked) of \(estimate)" }
    }

    enum Projects {
        static let title = "Projects"
        static let activeFilter = "Active"
        static let completedFilter = "Completed"
        static let emptyTitle = "No projects here"
        static let emptyMessage = "Your projects will appear here."
        static let newProject = "New project"
        static let basicInformation = "Basic information"
        static let projectTitle = "Project title"
        static let client = "Client"
        static let selectClient = "Select a client"
        static let delivery = "Delivery"
        static let pricing = "Pricing"
        static let billing = "Billing"
        static let agreedValue = "Agreed value"
        static let hourlyRate = "Hourly rate"
        static let desiredRate = "Desired hourly rate"
        static let estimatedHours = "Estimated hours"
        static let trackTime = "Track time"
        static let tasks = "Tasks"
        static let noTasks = "No tasks yet"
        static let payments = "Payments"
        static let noPayments = "No payments recorded"
        static let completeProject = "Complete project"
        static let projectNotFound = "Project not found"
        static let progress = "Progress"
        static let received = "Received"
        static let effectiveRate = "Effective rate"
        static let projectValue = "Project value"
        static let targetRate = "Target rate"
        static let projectResult = "Project result"
    }

    enum Tracking {
        static let title = "Track"
        static let timerRunning = "Timer running"
        static let stopTimer = "Stop timer"
        static let ready = "Ready when you are"
        static let readyMessage = "Choose a project and keep the focus on the work."
        static let sessionNote = "Session note (optional)"
        static let startTimer = "Start timer"
        static let addManually = "Add time manually"
        static let recentSessions = "Recent sessions"
        static let manualEntry = "Manual entry"
        static let started = "Started"
        static func duration(_ value: String) -> String { "Duration: \(value)" }
    }

    enum Activity {
        static let title = "Activity"
        static let trackedThisMonth = "tracked this month"
        static let emptyMessage = "Tracked and manual sessions will appear here."
        static let workHistory = "Work history"
    }

    enum Clients {
        static let title = "Clients"
        static let emptyTitle = "No clients"
        static let emptyMessage = "Add a client before creating a project."
        static let newClient = "New client"
        static let clientSection = "Client"
        static let name = "Name"
        static let company = "Company (optional)"
        static let contact = "Contact"
        static let email = "Email (optional)"
        static let phone = "Phone (optional)"
        static let notes = "Notes"
        static func activeProjects(_ count: Int) -> String { "\(count) active" }
    }

    enum Payments {
        static let title = "Record payment"
        static let section = "Payment"
        static let amount = "Amount"
        static let date = "Date"
        static let method = "Method"
        static let status = "Status"
        static let reference = "Reference (optional)"
        static let securityNote = "Use an administrative reference only. Never enter passwords or banking credentials."
    }
}
