import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showSettings = false
    @State private var showEditProfile = false
    
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.09, blue: 0.20),
                    Color(red: 0.04, green: 0.06, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if let profile = userManager.userProfile {
                        profileHeader(profile: profile)
                        quickStatsSection(profile: profile)
                        goalsSection
                        achievementsSection
                        settingsSection
                    } else {
                        emptyProfileView
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet()
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheet()
        }
    }
    
    // MARK: - Bilesenler
    
    private func profileHeader(profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.00, green: 0.54, blue: 0.24),
                                Color(red: 0.98, green: 0.30, blue: 0.28)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(String(profile.name.prefix(1)).uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Isim ve bilgiler
            VStack(spacing: 8) {
                Text(profile.name)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Başlangıç: \(profile.quitDate, format: .dateTime.day().month().year())")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Duzenle butonu
            Button {
                showEditProfile = true
            } label: {
                Text("Profili Düzenle")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private func quickStatsSection(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı Bakış")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                QuickStatRow(
                    icon: "calendar.badge.clock",
                    title: "Sigara İçilmeyen Gün",
                    value: "\(profile.daysSinceQuit)",
                    color: Color(red: 0.99, green: 0.52, blue: 0.28)
                )
                
                QuickStatRow(
                    icon: "turkishlirasign.circle.fill",
                    title: "Toplam Tasarruf",
                    value: String(format: "%.0f TL", profile.moneySaved),
                    color: Color(red: 0.36, green: 0.84, blue: 0.65)
                )
                
                QuickStatRow(
                    icon: "nosign",
                    title: "İçilmeyen Sigara",
                    value: "\(profile.cigarettesAvoided)",
                    color: Color(red: 0.95, green: 0.36, blue: 0.42)
                )
                
                QuickStatRow(
                    icon: "heart.fill",
                    title: "Sağlık Skoru",
                    value: "\(profile.healthScore)/100",
                    color: Color(red: 0.38, green: 0.73, blue: 1.00)
                )
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hedeflerim")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(userManager.userGoals.filter { $0.isCompleted }.count)/\(userManager.userGoals.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
            }
            
            if !userManager.userGoals.isEmpty {
                VStack(spacing: 12) {
                    ForEach(userManager.userGoals.prefix(3)) { goal in
                        GoalProgressRow(goal: goal)
                    }
                }
            } else {
                Text("Henüz hedef belirlemedin")
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Rozetler")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                let unlockedCount = userManager.achievements.filter { $0.isUnlocked }.count
                Text("\(unlockedCount)/\(userManager.achievements.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(red: 1.00, green: 0.74, blue: 0.38))
            }
            
            if !userManager.achievements.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(userManager.achievements.prefix(5)) { achievement in
                            AchievementBadgeSmall(achievement: achievement)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var settingsSection: some View {
        VStack(spacing: 12) {
            SettingsButton(
                icon: "gearshape.fill",
                title: "Ayarlar",
                color: Color(red: 0.38, green: 0.73, blue: 1.00)
            ) {
                showSettings = true
            }
            
            SettingsButton(
                icon: "bell.fill",
                title: "Bildirimler",
                color: Color(red: 1.00, green: 0.54, blue: 0.24)
            ) {
                // TODO: Bildirim ayarları
            }
            
            SettingsButton(
                icon: "arrow.clockwise",
                title: "Verileri Yedekle",
                color: Color(red: 0.36, green: 0.84, blue: 0.65)
            ) {
                // TODO: Yedekleme
            }
            
            SettingsButton(
                icon: "questionmark.circle.fill",
                title: "Yardım & Destek",
                color: Color(red: 0.80, green: 0.68, blue: 1.00)
            ) {
                // TODO: Yardım sayfası
            }
        }
    }
    
    private var emptyProfileView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("Profil Bulunamadı")
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
            
            Text("Lütfen önce profil bilgilerinizi tamamlayın")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Yardimci Gorunumler

private struct QuickStatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3.weight(.bold))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
}

private struct GoalProgressRow: View {
    let goal: UserGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(getColor())
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(getColor())
                        .frame(width: geometry.size.width * goal.progress, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func getColor() -> Color {
        switch goal.color {
        case "red": return Color(red: 0.95, green: 0.36, blue: 0.42)
        case "green": return Color(red: 0.36, green: 0.84, blue: 0.65)
        case "blue": return Color(red: 0.38, green: 0.73, blue: 1.00)
        default: return Color.white
        }
    }
}

private struct AchievementBadgeSmall: View {
    let achievement: UserAchievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? 
                          Color(red: 1.00, green: 0.74, blue: 0.38).opacity(0.3) : 
                          Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.isUnlocked ? "star.fill" : "lock.fill")
                    .font(.title3.weight(.bold))
                    .foregroundColor(achievement.isUnlocked ? 
                                    Color(red: 1.00, green: 0.74, blue: 0.38) : 
                                    .white.opacity(0.3))
            }
            
            Text(achievement.achievementId)
                .font(.caption2.weight(.semibold))
                .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

private struct SettingsButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3.weight(.bold))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet'ler

private struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.09, blue: 0.20),
                        Color(red: 0.04, green: 0.06, blue: 0.13)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("Adın", text: $name)
                        .padding(16)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .foregroundColor(.white)
                    
                    Button {
                        if var profile = userManager.userProfile {
                            profile.name = name
                            userManager.saveUserProfile(profile)
                        }
                        dismiss()
                    } label: {
                        Text("Kaydet")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.36, green: 0.84, blue: 0.65),
                                        Color(red: 0.20, green: 0.63, blue: 0.52)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Profili Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .onAppear {
                name = userManager.userProfile?.name ?? ""
            }
        }
    }
}

private struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.09, blue: 0.20),
                        Color(red: 0.04, green: 0.06, blue: 0.13)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Ayarlar sayfası yakında eklenecek")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.vertical, 40)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager.shared)
}


