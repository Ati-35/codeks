import SwiftUI

// Ortak tasarim degerleri: ContentView ile ayni hizalama ve stil icin.
private enum HomeDesign {
    static let insetSmall: CGFloat = 8
    static let insetMedium: CGFloat = 12
    static let insetLarge: CGFloat = 16
    static let insetXL: CGFloat = 24

    static let screenHInset: CGFloat = 24
    static let screenTop: CGFloat = 56
    static let screenBottom: CGFloat = 32

    static let radiusCard: CGFloat = 20
    static let radiusButton: CGFloat = 16
    static let radiusField: CGFloat = 14
    static let radiusPill: CGFloat = 12

    static let shadowColor: Color = Color.black.opacity(0.35)
    static let shadowRadius: CGFloat = 22
    static let shadowY: CGFloat = 16

    static let textPrimaryOpacity: Double = 0.9
    static let textSecondaryOpacity: Double = 0.75
    static let textTertiaryOpacity: Double = 0.65
    static let strokeOpacity: Double = 0.14
    static let fillOpacity: Double = 0.08

    static let haloOrange = (size: CGSize(width: 250, height: 250), offset: CGSize(width: 130, height: -240), opacity: 0.26)
    static let haloBlue = (size: CGSize(width: 250, height: 250), offset: CGSize(width: -150, height: -140), opacity: 0.21)
    static let haloGreen = (size: CGSize(width: 230, height: 230), offset: CGSize(width: -120, height: 260), opacity: 0.20)
}

// Ana sayfa: egitim kartlari, kisa videolar, hizli eylemler.
struct HomeView: View {
    var onLogout: () -> Void // Cikis icin gelen buton aksiyonu.
    @State private var showVideoSheet = false // Izle butonuna basinca acilir.
    @State private var showAudioSheet = false // Dinle butonuna basinca acilir.
    @State private var activeAction: QuickAction? // Hizli eylem tiklaninca acilir.
    @State private var activeStat: StatInfo? // Kart tiklaninca acilir.
    @State private var activeClip: Clip? // Kisa video tiklaninca acilir.
    @State private var activeAchievement: Achievement? // Rozet tiklaninca acilir.
    @State private var activeHealthMilestone: HealthMilestone? // Saglik kartina tiklaninca acilir.
    @State private var completedMissions: Set<String> = [] // Tamamlanan gorevler.

    var body: some View {
        ZStack {
            background // Arkadaki renkli tabaka.
            ScrollView {
                VStack(spacing: HomeDesign.insetXL) {
                    topBar // Selamlama ve cikis.
                    heroCard // Gunluk egitim karti.
                    miniReels // Saga kayan kucuk videolar.
                    quickActions // Kullaniciya hizli yardim butonlari.
                    progressRow // Gunluk ilerleme bilgisi.
                    achievementsSection // Basari rozetleri.
                    healthTimelineSection // Saglik iyilesmeleri.
                    dailyMissionsSection // Gunluk gorevler.
                    weeklyProgressSection // Haftalik ilerleme.
                }
                .padding(.horizontal, HomeDesign.screenHInset)
                .padding(.top, HomeDesign.screenTop)
                .padding(.bottom, HomeDesign.screenBottom)
            }
        }
        // Alt tarafta sheet'ler: video, ses, hizli eylem, istatistik, kisa video.
        .sheet(isPresented: $showVideoSheet) {
            VideoSheetView(
                title: "Video yakinda",
                message: "Buraya gercek video koyulacak. Simdilik ornek kart gorunumu var."
            )
        }
        .sheet(isPresented: $showAudioSheet) {
            AudioSheetView(
                title: "Sesli sakinlesme",
                message: "Baslat ile nefes ritmini dinle. Bu sahnede ileride ses calacak."
            )
        }
        .sheet(item: $activeAction) { action in
            InfoSheetView(
                title: action.title,
                message: action.message,
                icon: action.icon
            )
        }
        .sheet(item: $activeStat) { stat in
            InfoSheetView(
                title: stat.title,
                message: stat.detail,
                icon: stat.icon
            )
        }
        .sheet(item: $activeClip) { clip in
            VideoSheetView(
                title: clip.title,
                message: "Sure: \(clip.duration). Bu kisa videonun gorseli su an sahte, ileride oynatici olacak."
            )
        }
        .sheet(item: $activeAchievement) { achievement in
            AchievementSheetView(achievement: achievement)
        }
        .sheet(item: $activeHealthMilestone) { milestone in
            HealthMilestoneSheetView(milestone: milestone)
        }
    }
}

// MARK: - Parcalar
private extension HomeView {
    var background: some View {
        // Yumusak renkli zemin ve isik halkalari.
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

            Circle()
                .fill(Color(red: 0.99, green: 0.52, blue: 0.28).opacity(HomeDesign.haloOrange.opacity))
                .frame(width: HomeDesign.haloOrange.size.width, height: HomeDesign.haloOrange.size.height)
                .blur(radius: 90)
                .offset(x: HomeDesign.haloOrange.offset.width, y: HomeDesign.haloOrange.offset.height) // Turuncu isik, sag ust.

            Circle()
                .fill(Color(red: 0.30, green: 0.76, blue: 0.90).opacity(HomeDesign.haloBlue.opacity))
                .frame(width: HomeDesign.haloBlue.size.width, height: HomeDesign.haloBlue.size.height)
                .blur(radius: 90)
                .offset(x: HomeDesign.haloBlue.offset.width, y: HomeDesign.haloBlue.offset.height) // Mavi isik, sol ust.

            Circle()
                .fill(Color(red: 0.36, green: 0.85, blue: 0.62).opacity(HomeDesign.haloGreen.opacity))
                .frame(width: HomeDesign.haloGreen.size.width, height: HomeDesign.haloGreen.size.height)
                .blur(radius: 90)
                .offset(x: HomeDesign.haloGreen.offset.width, y: HomeDesign.haloGreen.offset.height) // Yesil isik, sol alt.
        }
    }

    var topBar: some View {
        // Merhaba yazisi, tarih ve cikis butonu.
        HStack {
            VStack(alignment: .leading, spacing: HomeDesign.insetSmall - 2) {
                Text("Merhaba, devam ediyoruz!")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                Text("Bugun nefes al, odaklan, minik adimlar.")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
            }
            Spacer()
            Button {
                onLogout() // Cikis yap.
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
                    // Baseline yerine ikonun merkezini hizala.
                    .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cikis")
        }
    }

    var heroCard: some View {
        // Gunluk ana egitim karti.
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.14, green: 0.20, blue: 0.36),
                            Color(red: 0.09, green: 0.12, blue: 0.24)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.00, green: 0.54, blue: 0.24).opacity(0.4),
                            Color(red: 0.38, green: 0.82, blue: 0.64).opacity(0.35),
                            Color(red: 0.36, green: 0.73, blue: 1.00).opacity(0.3),
                            Color(red: 1.00, green: 0.54, blue: 0.24).opacity(0.4)
                        ]),
                        center: .center
                    )
                    .opacity(0.25)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
                )
                .shadow(color: HomeDesign.shadowColor, radius: HomeDesign.shadowRadius, x: 0, y: HomeDesign.shadowY)

            VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 2) {
                Text("Gunluk Egitim")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color.white.opacity(HomeDesign.textPrimaryOpacity))

                // Bu kucuk kutu ileride video afisi olacak (simdilik placeholder).
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous)
                        .fill(Color.white.opacity(HomeDesign.fillOpacity))
                        .frame(width: 120, height: 70)
                        .overlay(
                            VStack(spacing: HomeDesign.insetSmall - 2) {
                                Image(systemName: "film.fill")
                                    .foregroundColor(.white)
                                    .font(.title3.weight(.bold))
                                Text("Video afisi")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(Color.white.opacity(HomeDesign.textPrimaryOpacity))
                            }
                        )
                }

                Text("Stresle basa cikma ve nefes calismasi")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                HStack(spacing: HomeDesign.insetLarge - 4) {
                    labelPill(text: "15 dk")
                    labelPill(text: "Baslangic")
                    labelPill(text: "Video")
                }

                HStack(spacing: HomeDesign.insetLarge - 4) {
                    Button {
                        showVideoSheet = true // Izle: ornek video sayfasini ac.
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.headline.weight(.bold))
                            Text("Izle")
                                .font(.headline.weight(.semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, HomeDesign.insetMedium)
                        .padding(.horizontal, HomeDesign.insetLarge)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.00, green: 0.54, blue: 0.24),
                                    Color(red: 0.98, green: 0.30, blue: 0.28)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
                        .shadow(color: HomeDesign.shadowColor, radius: HomeDesign.shadowRadius, x: 0, y: HomeDesign.shadowY)
                    }
                    .buttonStyle(.plain)

                    Button {
                        showAudioSheet = true // Dinle: ornek ses sayfasini ac.
                    } label: {
                        HStack {
                            Image(systemName: "waveform.and.mic")
                                .font(.headline.weight(.bold))
                            Text("Dinle")
                                .font(.headline.weight(.semibold))
                        }
                        .foregroundColor(Color.white)
                        .padding(.vertical, HomeDesign.insetMedium)
                        .padding(.horizontal, HomeDesign.insetLarge)
                        .background(Color.white.opacity(HomeDesign.fillOpacity + 0.04)) // Biraz daha acik yaparak shadow'u belirginlestir.
                        .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous)
                                .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
                        )
                        .shadow(color: HomeDesign.shadowColor, radius: HomeDesign.shadowRadius, x: 0, y: HomeDesign.shadowY)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(HomeDesign.insetXL)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 270)
    }

    var miniReels: some View {
        // Saga kayan kucuk videolar listesi.
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("Kisa Videolar")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Hepsini gor")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                    // Baseline'i hizalamak icin hafif asagi cekiyoruz.
                    .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] + 2 }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: HomeDesign.insetLarge - 2) {
                    ForEach(sampleClips) { clip in
                        MiniVideoCard(clip: clip) {
                            activeClip = clip // Kisa video tiklaninca sheet ac.
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    var quickActions: some View {
        // Kriz aninda yapilacak hizli adimlar.
        VStack(alignment: .leading, spacing: HomeDesign.insetMedium) {
            Text("Hizli eylemler")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)

            VStack(spacing: HomeDesign.insetLarge - 4) {
                ForEach(quickActionItems) { action in
                    ActionRow(
                        icon: action.icon,
                        title: action.title,
                        subtitle: action.subtitle,
                        accent: action.accent
                    ) {
                        activeAction = action // Hangi eyleme tiklandiysa sheet ac.
                    }
                }
            }
        }
    }

    var progressRow: some View {
        // Gunluk kucuk ilerleme kartlari.
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            Text("Bugun")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)

            HStack(spacing: HomeDesign.insetLarge - 4) {
                ForEach(statItems) { stat in
                    StatCard(
                        title: stat.title,
                        value: stat.value,
                        icon: stat.icon,
                        color: stat.color
                    ) {
                        activeStat = stat // Kart tiklaninca detay sheet ac.
                    }
                }
            }
        }
    }

    func labelPill(text: String) -> some View {
        // Kucuk bilgi kapsulu.
        Text(text)
            .font(.caption.weight(.bold))
            .foregroundColor(Color.white.opacity(HomeDesign.textPrimaryOpacity))
            .padding(.horizontal, HomeDesign.insetLarge - 4)
            .padding(.vertical, HomeDesign.insetSmall)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(Capsule())
    }

    // MARK: - Basari Rozetleri
    var achievementsSection: some View {
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("Basarilarim")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(achievementItems.filter { $0.isUnlocked }.count)/\(achievementItems.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: HomeDesign.insetLarge - 2) {
                    ForEach(achievementItems) { achievement in
                        AchievementCard(achievement: achievement) {
                            activeAchievement = achievement
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: - Saglik Iyilesmeleri Timeline
    var healthTimelineSection: some View {
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            Text("Saglik Iyilesmelerin")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)

            VStack(spacing: HomeDesign.insetMedium) {
                ForEach(healthMilestones) { milestone in
                    HealthTimelineCard(milestone: milestone) {
                        activeHealthMilestone = milestone
                    }
                }
            }
        }
    }

    // MARK: - Gunluk Gorevler
    var dailyMissionsSection: some View {
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack {
                Text("Gunluk Gorevler")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(completedMissions.count)/\(dailyMissions.count)")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, HomeDesign.insetMedium)
                    .padding(.vertical, HomeDesign.insetSmall - 2)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.36, green: 0.84, blue: 0.65).opacity(0.3))
                    )
            }

            VStack(spacing: HomeDesign.insetMedium - 2) {
                ForEach(dailyMissions) { mission in
                    MissionCard(
                        mission: mission,
                        isCompleted: completedMissions.contains(mission.id.uuidString)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if completedMissions.contains(mission.id.uuidString) {
                                completedMissions.remove(mission.id.uuidString)
                            } else {
                                completedMissions.insert(mission.id.uuidString)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Haftalik Ilerleme
    var weeklyProgressSection: some View {
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            Text("Haftalik Ilerleme")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)

            VStack(spacing: HomeDesign.insetMedium) {
                // Haftalik grafik
                HStack(spacing: HomeDesign.insetSmall) {
                    ForEach(weeklyData, id: \.day) { data in
                        WeekDayBar(data: data)
                    }
                }
                .padding(.vertical, HomeDesign.insetMedium)
                .padding(.horizontal, HomeDesign.insetLarge - 4)
                .background(Color.white.opacity(HomeDesign.fillOpacity))
                .overlay(
                    RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))

                // Ozet istatistikleri
                HStack(spacing: HomeDesign.insetMedium) {
                    WeeklySummaryCard(
                        title: "Toplam Tasarruf",
                        value: "595 TL",
                        icon: "turkishlirasign.circle.fill",
                        color: Color(red: 0.36, green: 0.84, blue: 0.65)
                    )
                    WeeklySummaryCard(
                        title: "Dumansiz Gun",
                        value: "7 gun",
                        icon: "calendar.badge.checkmark",
                        color: Color(red: 0.99, green: 0.52, blue: 0.28)
                    )
                }
            }
        }
    }
}

// MARK: - Yardimci gorunumler
private struct MiniVideoCard: View {
    let clip: Clip // Veri modelini tutar.
    var onTap: () -> Void // Tiklayinca ne olsun?

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: HomeDesign.insetSmall) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: clip.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                                .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
                        )

                    HStack(spacing: HomeDesign.insetSmall - 2) {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.caption.weight(.bold))
                        Text(clip.duration)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                    }
                    .padding(HomeDesign.insetSmall)
                }

                Text(clip.title)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 150, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct ActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color
    var onTap: () -> Void = {} // Tiklaninca calisacak kod.

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: HomeDesign.insetLarge - 2) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.20))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.headline.weight(.bold))
                }

                VStack(alignment: .leading, spacing: HomeDesign.insetSmall / 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.white.opacity(HomeDesign.textTertiaryOpacity))
                    .font(.caption.weight(.bold))
            }
            .padding(.horizontal, HomeDesign.insetLarge - 2)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var onTap: () -> Void = {} // Tiklaninca calisan olay.

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: HomeDesign.insetSmall) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.headline.weight(.bold))
                        .frame(width: 32, height: 32)
                        .background(color.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusField, style: .continuous))
                    Spacer()
                }
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
            }
            .padding(HomeDesign.insetLarge - 2)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// Sheet icerisinde metin gosteren basit kart.
private struct InfoSheetView: View {
    let title: String
    let message: String
    let icon: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: HomeDesign.insetLarge - 2) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 6) // Sheet tutacak gibi bir cizgi.

            Image(systemName: icon)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(HomeDesign.fillOpacity))
                .clipShape(Circle())

            Text("Detay: \(title)") // Testin bulabilecegi ve kullaniciya rehber olan yazi.
                .font(.caption.weight(.bold))
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                .multilineTextAlignment(.center)
                .padding(.horizontal, HomeDesign.insetLarge - 4)

            Button("Kapat") {
                dismiss() // Sheet'i kapat.
            }
            .font(.headline.weight(.semibold))
            .padding(.horizontal, HomeDesign.insetXL - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.10, blue: 0.24),
                    Color(red: 0.03, green: 0.05, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// Video icin ornek sheet (gercek video yerine placeholder gorsel).
private struct VideoSheetView: View {
    let title: String
    let message: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: HomeDesign.insetLarge) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 6)

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(HomeDesign.fillOpacity))
                .frame(height: 200)
                .overlay(
                    VStack(spacing: HomeDesign.insetSmall + 2) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        Text("Video gorseli burada")
                            .foregroundColor(Color.white.opacity(HomeDesign.textPrimaryOpacity))
                            .font(.subheadline.weight(.semibold))
                    }
                )

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                .multilineTextAlignment(.center)
                .padding(.horizontal, HomeDesign.insetLarge - 4)

            Button("Kapat") {
                dismiss()
            }
            .font(.headline.weight(.semibold))
            .padding(.horizontal, HomeDesign.insetXL - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            .foregroundColor(.white)
        }
        .padding(.horizontal, HomeDesign.insetXL - 2)
        .padding(.top, HomeDesign.insetMedium)
        .padding(.bottom, HomeDesign.insetXL + 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.09, blue: 0.20),
                    Color(red: 0.04, green: 0.06, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// Ses icin ornek sheet (gercek ses yerine ilerleme cubugu).
private struct AudioSheetView: View {
    let title: String
    let message: String
    @Environment(\.dismiss) private var dismiss
    @State private var progress: Double = 0.35 // Ornek ilerleme.

    var body: some View {
        VStack(spacing: HomeDesign.insetLarge) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 6)

            HStack(spacing: HomeDesign.insetLarge - 4) {
                Image(systemName: "waveform")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: HomeDesign.insetSmall - 2) {
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: HomeDesign.insetSmall) {
                Text("Sakinlesme ilerlemesi")
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                    .font(.caption.weight(.semibold))
                ProgressView(value: progress)
                    .tint(Color(red: 0.36, green: 0.84, blue: 0.65))
            }

            HStack(spacing: HomeDesign.insetLarge - 4) {
                Button("Geri") {
                    progress = max(progress - 0.1, 0) // Ornek geri sar.
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.white.opacity(0.12))
                .foregroundColor(.white)

                Button("Ilerle") {
                    progress = min(progress + 0.1, 1) // Ornek ilerlet.
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.36, green: 0.84, blue: 0.65))
                .foregroundColor(.white)
            }

            Button("Kapat") {
                dismiss()
            }
            .font(.headline.weight(.semibold))
            .padding(.horizontal, HomeDesign.insetXL - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal, HomeDesign.insetXL - 2)
        .padding(.top, HomeDesign.insetMedium)
        .padding(.bottom, HomeDesign.insetXL + 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.09, blue: 0.20),
                    Color(red: 0.04, green: 0.06, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Yeni Bolum Kartlari

// Basari rozeti karti.
private struct AchievementCard: View {
    let achievement: Achievement
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: HomeDesign.insetSmall) {
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.color.opacity(0.25) : Color.white.opacity(0.08))
                        .frame(width: 60, height: 60)

                    // Ilerleme halkasi
                    Circle()
                        .trim(from: 0, to: achievement.progress)
                        .stroke(
                            achievement.isUnlocked ? achievement.color : achievement.color.opacity(0.5),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))

                    Image(systemName: achievement.icon)
                        .font(.title2.weight(.bold))
                        .foregroundColor(achievement.isUnlocked ? .white : Color.white.opacity(0.4))
                }

                Text(achievement.title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(achievement.isUnlocked ? .white : Color.white.opacity(0.5))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
            .padding(.vertical, HomeDesign.insetMedium)
            .padding(.horizontal, HomeDesign.insetSmall)
        }
        .buttonStyle(.plain)
    }
}

// Saglik timeline karti.
private struct HealthTimelineCard: View {
    let milestone: HealthMilestone
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: HomeDesign.insetLarge - 2) {
                // Zaman etiketi
                VStack {
                    Text(milestone.timeLabel)
                        .font(.caption.weight(.bold))
                        .foregroundColor(milestone.isReached ? .white : Color.white.opacity(0.5))
                }
                .frame(width: 50)

                // Timeline cizgisi ve nokta
                VStack(spacing: 0) {
                    Circle()
                        .fill(milestone.isReached ? milestone.color : Color.white.opacity(0.2))
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(milestone.color.opacity(0.5), lineWidth: milestone.isReached ? 3 : 0)
                                .frame(width: 20, height: 20)
                        )
                }

                // Icerik
                VStack(alignment: .leading, spacing: HomeDesign.insetSmall - 4) {
                    HStack {
                        Image(systemName: milestone.icon)
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(milestone.isReached ? milestone.color : Color.white.opacity(0.4))

                        Text(milestone.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(milestone.isReached ? .white : Color.white.opacity(0.5))
                    }

                    Text(milestone.description)
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Durum ikonu
                Image(systemName: milestone.isReached ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(milestone.isReached ? milestone.color : Color.white.opacity(0.3))
                    .font(.headline)
            }
            .padding(HomeDesign.insetLarge - 2)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(milestone.isReached ? milestone.color.opacity(0.3) : Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// Gunluk gorev karti.
private struct MissionCard: View {
    let mission: DailyMission
    let isCompleted: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: HomeDesign.insetMedium) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isCompleted ? mission.color : Color.white.opacity(0.08))
                        .frame(width: 28, height: 28)

                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                    }
                }

                // Icon
                Image(systemName: mission.icon)
                    .font(.headline)
                    .foregroundColor(isCompleted ? mission.color : Color.white.opacity(0.6))
                    .frame(width: 24)

                // Baslik
                Text(mission.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(isCompleted ? Color.white.opacity(0.5) : .white)
                    .strikethrough(isCompleted, color: Color.white.opacity(0.3))

                Spacer()

                // XP
                Text("+\(mission.xp) XP")
                    .font(.caption.weight(.bold))
                    .foregroundColor(isCompleted ? mission.color : Color.white.opacity(0.6))
                    .padding(.horizontal, HomeDesign.insetSmall)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(isCompleted ? mission.color.opacity(0.2) : Color.white.opacity(0.08))
                    )
            }
            .padding(.horizontal, HomeDesign.insetLarge - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous)
                    .stroke(isCompleted ? mission.color.opacity(0.3) : Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// Haftalik gun cubugu.
private struct WeekDayBar: View {
    let data: WeekDayData

    var body: some View {
        VStack(spacing: HomeDesign.insetSmall - 2) {
            // Cubuk
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 28, height: 80)

                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        data.isToday ?
                        LinearGradient(
                            colors: [Color(red: 0.99, green: 0.52, blue: 0.28), Color(red: 0.98, green: 0.31, blue: 0.29)],
                            startPoint: .bottom,
                            endPoint: .top
                        ) :
                        LinearGradient(
                            colors: [Color(red: 0.36, green: 0.84, blue: 0.65), Color(red: 0.35, green: 0.75, blue: 1.00)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 28, height: CGFloat(data.value * 80))
            }

            // Gun etiketi
            Text(data.day)
                .font(.caption2.weight(.semibold))
                .foregroundColor(data.isToday ? .white : Color.white.opacity(0.6))
        }
    }
}

// Haftalik ozet karti.
private struct WeeklySummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: HomeDesign.insetSmall) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.headline)
                Spacer()
            }
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
        }
        .padding(HomeDesign.insetLarge - 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(HomeDesign.fillOpacity))
        .overlay(
            RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
    }
}

// Basari rozeti sheet.
private struct AchievementSheetView: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: HomeDesign.insetLarge) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 6)

            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: achievement.progress)
                    .stroke(achievement.color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                Image(systemName: achievement.icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .white : Color.white.opacity(0.4))
            }

            Text(achievement.title)
                .font(.title2.weight(.bold))
                .foregroundColor(.white)

            Text(achievement.description)
                .font(.body)
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Ilerleme gostergesi
            VStack(spacing: HomeDesign.insetSmall) {
                HStack {
                    Text("Ilerleme")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                    Spacer()
                    Text("\(Int(achievement.progress * 100))%")
                        .font(.caption.weight(.bold))
                        .foregroundColor(achievement.color)
                }
                ProgressView(value: achievement.progress)
                    .tint(achievement.color)
            }
            .padding(.horizontal, HomeDesign.insetXL)

            if achievement.isUnlocked {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(achievement.color)
                    Text("Kazanildi!")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(achievement.color)
                }
                .padding(.vertical, HomeDesign.insetMedium)
                .padding(.horizontal, HomeDesign.insetXL)
                .background(achievement.color.opacity(0.15))
                .clipShape(Capsule())
            }

            Button("Kapat") {
                dismiss()
            }
            .font(.headline.weight(.semibold))
            .padding(.horizontal, HomeDesign.insetXL - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            .foregroundColor(.white)

            Spacer()
        }
        .padding(.top, HomeDesign.insetMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.09, blue: 0.20),
                    Color(red: 0.04, green: 0.06, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// Saglik iyilesmesi sheet.
private struct HealthMilestoneSheetView: View {
    let milestone: HealthMilestone
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: HomeDesign.insetLarge) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 6)

            ZStack {
                Circle()
                    .fill(milestone.color.opacity(0.2))
                    .frame(width: 90, height: 90)

                Image(systemName: milestone.icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(milestone.isReached ? milestone.color : Color.white.opacity(0.4))
            }

            Text(milestone.timeLabel)
                .font(.caption.weight(.bold))
                .foregroundColor(milestone.color)
                .padding(.horizontal, HomeDesign.insetMedium)
                .padding(.vertical, HomeDesign.insetSmall - 2)
                .background(milestone.color.opacity(0.15))
                .clipShape(Capsule())

            Text(milestone.title)
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(milestone.description)
                .font(.body)
                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if milestone.isReached {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(milestone.color)
                    Text("Bu asamaya ulastin!")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.white)
                }
                .padding(.vertical, HomeDesign.insetMedium)
                .padding(.horizontal, HomeDesign.insetXL)
                .background(milestone.color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            } else {
                Text("Biraz daha sabret, yaklasiyorsun!")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.6))
                    .italic()
            }

            Button("Kapat") {
                dismiss()
            }
            .font(.headline.weight(.semibold))
            .padding(.horizontal, HomeDesign.insetXL - 4)
            .padding(.vertical, HomeDesign.insetMedium)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusButton, style: .continuous))
            .foregroundColor(.white)

            Spacer()
        }
        .padding(.top, HomeDesign.insetMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.09, blue: 0.20),
                    Color(red: 0.04, green: 0.06, blue: 0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Model
private struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let message: String
    let icon: String
    let accent: Color
}

private struct StatInfo: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let color: Color
    let detail: String
}

private struct Clip: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let gradient: [Color]
}

// Basari rozeti modeli.
private struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
    let progress: Double // 0-1 arasi
}

// Saglik iyilesmesi modeli.
private struct HealthMilestone: Identifiable {
    let id = UUID()
    let timeLabel: String // "20 dk", "8 saat", "24 saat" gibi
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isReached: Bool
}

// Gunluk gorev modeli.
private struct DailyMission: Identifiable {
    let id = UUID()
    let title: String
    let xp: Int
    let icon: String
    let color: Color
}

// Haftalik veri modeli.
private struct WeekDayData {
    let day: String
    let value: Double // 0-1 arasi
    let isToday: Bool
}

// Hizli eylem listesi.
private let quickActionItems: [QuickAction] = [
    QuickAction(
        title: "Nefes egzersizi baslat",
        subtitle: "2 dakikada rahatla",
        message: "3-4-5 nefes: 3 saniye nefes al, 4 saniye tut, 5 saniye ver. 5 tur yap.",
        icon: "lungs.fill",
        accent: Color(red: 0.36, green: 0.84, blue: 0.65)
    ),
    QuickAction(
        title: "Kraving yardimi",
        subtitle: "Dikkatini degistir",
        message: "1 bardak su ic, 5 dakika yuru, telefonunu birak, derin nefes al.",
        icon: "flame.fill",
        accent: Color(red: 1.00, green: 0.54, blue: 0.24)
    ),
    QuickAction(
        title: "Mini okuma",
        subtitle: "1 dakikalik ipucu",
        message: "Sigara istegi 90 saniye dalga gibi gelir, gecer. Dalganin gecmesini izle.",
        icon: "book.fill",
        accent: Color(red: 0.38, green: 0.73, blue: 1.00)
    )
]

// Istatistik kart listesi.
private let statItems: [StatInfo] = [
    StatInfo(
        title: "Duman yok",
        value: "6 saat",
        icon: "sun.max.fill",
        color: Color(red: 0.99, green: 0.52, blue: 0.28),
        detail: "Bugun hic sigara icmedin. Bu sure boyunca vucudun oksijen topluyor."
    ),
    StatInfo(
        title: "Tasarruf",
        value: "85 TL",
        icon: "banknote.fill",
        color: Color(red: 0.36, green: 0.84, blue: 0.65),
        detail: "Bugun sigara almadin, cebe 85 TL kaldi. 1 haftada daha da artacak."
    ),
    StatInfo(
        title: "Mood",
        value: "Dengeli",
        icon: "face.smiling.fill",
        color: Color(red: 0.38, green: 0.73, blue: 1.00),
        detail: "Ruh halini kaydet, dalgalanma normal. Nefes ve su yardim eder."
    )
]

// Ornek kisa videolar listesi.
private let sampleClips: [Clip] = [
    Clip(
        title: "5 sn nefes ile sakinles",
        duration: "03:20",
        gradient: [
            Color(red: 0.99, green: 0.52, blue: 0.28),
            Color(red: 0.95, green: 0.36, blue: 0.36)
        ]
    ),
    Clip(
        title: "Kraving aninda dikkat dagit",
        duration: "02:10",
        gradient: [
            Color(red: 0.35, green: 0.75, blue: 1.00),
            Color(red: 0.20, green: 0.44, blue: 0.96)
        ]
    ),
    Clip(
        title: "Mini meditasyon",
        duration: "04:05",
        gradient: [
            Color(red: 0.36, green: 0.84, blue: 0.65),
            Color(red: 0.20, green: 0.63, blue: 0.52)
        ]
    ),
    Clip(
        title: "Yeni rutin: su ic ve yuru",
        duration: "01:45",
        gradient: [
            Color(red: 0.80, green: 0.68, blue: 1.00),
            Color(red: 0.47, green: 0.36, blue: 0.84)
        ]
    ),
    Clip(
        title: "Hedefini hatirla",
        duration: "02:40",
        gradient: [
            Color(red: 1.00, green: 0.74, blue: 0.38),
            Color(red: 0.96, green: 0.54, blue: 0.24)
        ]
    )
]

// Basari rozetleri listesi.
private let achievementItems: [Achievement] = [
    Achievement(
        title: "Ilk Adim",
        description: "Uygulamayi ilk kez actin, yolculuk basladi!",
        icon: "star.fill",
        color: Color(red: 1.00, green: 0.74, blue: 0.38),
        isUnlocked: true,
        progress: 1.0
    ),
    Achievement(
        title: "1 Gun Sampiyon",
        description: "24 saat boyunca sigara icmedin. Harika!",
        icon: "trophy.fill",
        color: Color(red: 0.36, green: 0.84, blue: 0.65),
        isUnlocked: true,
        progress: 1.0
    ),
    Achievement(
        title: "Nefes Ustasi",
        description: "5 nefes egzersizi tamamla.",
        icon: "lungs.fill",
        color: Color(red: 0.35, green: 0.75, blue: 1.00),
        isUnlocked: false,
        progress: 0.6
    ),
    Achievement(
        title: "Hafta Kahramani",
        description: "7 gun ust uste dumansiz kal.",
        icon: "flame.fill",
        color: Color(red: 0.99, green: 0.52, blue: 0.28),
        isUnlocked: false,
        progress: 0.85
    ),
    Achievement(
        title: "Tasarruf Krali",
        description: "500 TL tasarruf et.",
        icon: "banknote.fill",
        color: Color(red: 0.80, green: 0.68, blue: 1.00),
        isUnlocked: false,
        progress: 0.42
    )
]

// Saglik iyilesmeleri listesi.
private let healthMilestones: [HealthMilestone] = [
    HealthMilestone(
        timeLabel: "20 dk",
        title: "Kan basinci normallesir",
        description: "Kalp ritmin ve kan basincin normale donmeye basladi.",
        icon: "heart.fill",
        color: Color(red: 0.99, green: 0.52, blue: 0.28),
        isReached: true
    ),
    HealthMilestone(
        timeLabel: "8 saat",
        title: "Oksijen seviyesi artar",
        description: "Kanindaki karbonmonoksit azalir, oksijen artar.",
        icon: "lungs.fill",
        color: Color(red: 0.35, green: 0.75, blue: 1.00),
        isReached: true
    ),
    HealthMilestone(
        timeLabel: "24 saat",
        title: "Kalp krizi riski duser",
        description: "Kalp krizi gecirme riskin azalmaya baslar.",
        icon: "bolt.heart.fill",
        color: Color(red: 0.36, green: 0.84, blue: 0.65),
        isReached: false
    ),
    HealthMilestone(
        timeLabel: "48 saat",
        title: "Tat ve koku duyusu iyilesir",
        description: "Sinir uclari yenilenmeye baslar, tatlar ve kokular netlenir.",
        icon: "nose.fill",
        color: Color(red: 0.80, green: 0.68, blue: 1.00),
        isReached: false
    )
]

// Gunluk gorevler listesi.
private let dailyMissions: [DailyMission] = [
    DailyMission(
        title: "3 bardak su ic",
        xp: 10,
        icon: "drop.fill",
        color: Color(red: 0.35, green: 0.75, blue: 1.00)
    ),
    DailyMission(
        title: "5 dakika nefes egzersizi yap",
        xp: 20,
        icon: "wind",
        color: Color(red: 0.36, green: 0.84, blue: 0.65)
    ),
    DailyMission(
        title: "Kraving gelince yuru",
        xp: 15,
        icon: "figure.walk",
        color: Color(red: 0.99, green: 0.52, blue: 0.28)
    ),
    DailyMission(
        title: "1 motivasyon videosu izle",
        xp: 10,
        icon: "play.circle.fill",
        color: Color(red: 0.80, green: 0.68, blue: 1.00)
    )
]

// Haftalik veri.
private let weeklyData: [WeekDayData] = [
    WeekDayData(day: "Pzt", value: 1.0, isToday: false),
    WeekDayData(day: "Sal", value: 0.85, isToday: false),
    WeekDayData(day: "Car", value: 1.0, isToday: false),
    WeekDayData(day: "Per", value: 0.7, isToday: false),
    WeekDayData(day: "Cum", value: 1.0, isToday: false),
    WeekDayData(day: "Cmt", value: 0.9, isToday: false),
    WeekDayData(day: "Paz", value: 0.5, isToday: true)
]
