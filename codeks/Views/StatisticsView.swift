import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var userManager: UserManager
    
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
                    headerSection
                    
                    if let profile = userManager.userProfile {
                        mainStatsCard(profile: profile)
                        weeklyChart
                        moodTrendCard
                        cravingAnalysisCard
                        achievementsProgress
                    } else {
                        emptyStateView
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
    }
    
    // MARK: - Bilesenler
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("İstatistikler")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            
            Text("İlerlemen ve analizlerin")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func mainStatsCard(profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            // Ana Istatistikler
            HStack(spacing: 12) {
                StatBox(
                    title: "Sigara İçilmeyen",
                    value: "\(profile.daysSinceQuit)",
                    unit: "gün",
                    icon: "calendar.badge.clock",
                    color: Color(red: 0.99, green: 0.52, blue: 0.28)
                )
                
                StatBox(
                    title: "Tasarruf",
                    value: String(format: "%.0f", profile.moneySaved),
                    unit: "TL",
                    icon: "turkishlirasign.circle.fill",
                    color: Color(red: 0.36, green: 0.84, blue: 0.65)
                )
            }
            
            HStack(spacing: 12) {
                StatBox(
                    title: "İçilmeyen Sigara",
                    value: "\(profile.cigarettesAvoided)",
                    unit: "adet",
                    icon: "nosign",
                    color: Color(red: 0.95, green: 0.36, blue: 0.42)
                )
                
                StatBox(
                    title: "Sağlık Skoru",
                    value: "\(profile.healthScore)",
                    unit: "/100",
                    icon: "heart.fill",
                    color: Color(red: 0.38, green: 0.73, blue: 1.00)
                )
            }
        }
    }
    
    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Haftalık Performans")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            let weeklyRecords = userManager.getWeeklyRecords()
            
            if !weeklyRecords.isEmpty {
                Chart {
                    ForEach(weeklyRecords.suffix(7)) { record in
                        BarMark(
                            x: .value("Gün", record.date, unit: .day),
                            y: .value("Durum", record.didSmoke ? 0 : 1)
                        )
                        .foregroundStyle(record.didSmoke ? 
                            Color(red: 0.95, green: 0.36, blue: 0.42) : 
                            Color(red: 0.36, green: 0.84, blue: 0.65)
                        )
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [0, 1]) { value in
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                Text(intValue == 1 ? "Başarılı" : "Başarısız")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.caption)
                            }
                        }
                    }
                }
            } else {
                Text("Henüz veri yok")
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, minHeight: 200)
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
    
    private var moodTrendCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ruh Hali Trendi")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            let weeklyRecords = userManager.getWeeklyRecords()
            
            if !weeklyRecords.isEmpty {
                HStack(spacing: 8) {
                    ForEach(weeklyRecords.suffix(7)) { record in
                        VStack(spacing: 4) {
                            Text(record.mood.emoji)
                                .font(.title3)
                            
                            Text(record.date, format: .dateTime.weekday(.narrow))
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(record.mood.color.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
            } else {
                Text("Henüz ruh hali kaydı yok")
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
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
    
    private var cravingAnalysisCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kraving Analizi")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            let recentCravings = userManager.cravingRecords.prefix(7)
            
            if !recentCravings.isEmpty {
                VStack(spacing: 12) {
                    HStack {
                        Text("Toplam:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("\(recentCravings.count)")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Ortalama Şiddet:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        let avgIntensity = recentCravings.reduce(0) { $0 + $1.intensity } / recentCravings.count
                        Text("\(avgIntensity)/10")
                            .font(.headline.weight(.bold))
                            .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
                    }
                    
                    HStack {
                        Text("Başarı Oranı:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        let successRate = Double(recentCravings.filter { $0.wasSuccessful }.count) / Double(recentCravings.count) * 100
                        Text(String(format: "%.0f%%", successRate))
                            .font(.headline.weight(.bold))
                            .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
                    }
                }
            } else {
                Text("Henüz kraving kaydı yok")
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
    
    private var achievementsProgress: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Başarılar")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            let unlockedCount = userManager.achievements.filter { $0.isUnlocked }.count
            let totalCount = userManager.achievements.count
            
            VStack(spacing: 12) {
                HStack {
                    Text("Kazanılan Rozetler")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text("\(unlockedCount)/\(totalCount)")
                        .font(.headline.weight(.bold))
                        .foregroundColor(Color(red: 1.00, green: 0.74, blue: 0.38))
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.00, green: 0.74, blue: 0.38),
                                        Color(red: 0.96, green: 0.54, blue: 0.24)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (Double(unlockedCount) / Double(max(totalCount, 1))), height: 8)
                    }
                }
                .frame(height: 8)
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
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("Henüz veri yok")
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
            
            Text("Günlük takiplerini yapmaya başlayınca istatistiklerin burada görünecek")
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

private struct StatBox: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3.weight(.bold))
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(color.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    StatisticsView()
        .environmentObject(UserManager.shared)
}


