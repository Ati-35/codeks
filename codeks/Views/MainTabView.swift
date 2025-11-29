import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Ana Sayfa
            HomeView(onLogout: handleLogout)
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
                .tag(0)
            
            // Günlük Takip
            DailyTrackingView()
                .tabItem {
                    Label("Takip", systemImage: "calendar")
                }
                .tag(1)
            
            // İstatistikler
            StatisticsView()
                .tabItem {
                    Label("İstatistikler", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            // Profil
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(Color(red: 1.00, green: 0.54, blue: 0.24))
    }
    
    private func handleLogout() {
        // Çıkış işlemi - onboarding'e dön
        userManager.hasCompletedOnboarding = false
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserManager.shared)
}


