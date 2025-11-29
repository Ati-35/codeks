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
                    weeklyCalendar // Haftalik basari takvimi.
                    healthTimeline // Saglik iyilesme zaman cizelgesi.
                    achievementBadges // Basari rozetleri.
                    motivationCard // Gunluk motivasyon karti.
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

    var weeklyCalendar: some View {
        // Haftalik basari takvimi: son 7 gunun takibi.
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack {
                Text("Haftalik Takvim")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(weeklyDays.filter { $0.isSuccess }.count)/7 gun")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
            }

            HStack(spacing: HomeDesign.insetSmall) {
                ForEach(weeklyDays) { day in
                    VStack(spacing: HomeDesign.insetSmall - 2) {
                        Text(day.dayName)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))

                        ZStack {
                            Circle()
                                .fill(day.isToday ?
                                    Color(red: 1.00, green: 0.54, blue: 0.24).opacity(0.3) :
                                    Color.white.opacity(HomeDesign.fillOpacity))
                                .frame(width: 38, height: 38)

                            if day.isSuccess {
                                Image(systemName: "checkmark")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
                            } else if day.isToday {
                                Circle()
                                    .fill(Color(red: 1.00, green: 0.54, blue: 0.24))
                                    .frame(width: 8, height: 8)
                            } else {
                                Text("\(day.dayNumber)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(Color.white.opacity(HomeDesign.textTertiaryOpacity))
                            }
                        }
                        .overlay(
                            Circle()
                                .stroke(day.isToday ?
                                    Color(red: 1.00, green: 0.54, blue: 0.24) :
                                    Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(HomeDesign.insetLarge)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
    }

    var healthTimeline: some View {
        // Saglik iyilesme zaman cizelgesi.
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack {
                Text("Saglik Iyilesmesi")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(red: 0.95, green: 0.36, blue: 0.42))
                    .font(.subheadline)
            }

            VStack(spacing: 0) {
                ForEach(Array(healthMilestones.enumerated()), id: \.element.id) { index, milestone in
                    HStack(alignment: .top, spacing: HomeDesign.insetLarge - 4) {
                        // Zaman cizgisi noktasi ve cizgi.
                        VStack(spacing: 0) {
                            Circle()
                                .fill(milestone.isAchieved ?
                                    Color(red: 0.36, green: 0.84, blue: 0.65) :
                                    Color.white.opacity(0.3))
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Circle()
                                        .stroke(milestone.isAchieved ?
                                            Color(red: 0.36, green: 0.84, blue: 0.65).opacity(0.5) :
                                            Color.clear, lineWidth: 3)
                                )

                            if index < healthMilestones.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 2)
                                    .frame(height: 50)
                            }
                        }

                        // Milestone bilgisi.
                        VStack(alignment: .leading, spacing: HomeDesign.insetSmall - 2) {
                            HStack {
                                Text(milestone.time)
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(milestone.isAchieved ?
                                        Color(red: 0.36, green: 0.84, blue: 0.65) :
                                        Color.white.opacity(HomeDesign.textSecondaryOpacity))

                                if milestone.isAchieved {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption2)
                                        .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
                                }
                            }

                            Text(milestone.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.white)

                            Text(milestone.description)
                                .font(.caption)
                                .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.bottom, index < healthMilestones.count - 1 ? HomeDesign.insetLarge : 0)

                        Spacer()
                    }
                }
            }
            .padding(HomeDesign.insetLarge)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
    }

    var achievementBadges: some View {
        // Basari rozetleri bolumu.
        VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack {
                Text("Basari Rozetleri")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(badges.filter { $0.isUnlocked }.count)/\(badges.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(red: 1.00, green: 0.74, blue: 0.38))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: HomeDesign.insetMedium) {
                    ForEach(badges) { badge in
                        VStack(spacing: HomeDesign.insetSmall) {
                            ZStack {
                                Circle()
                                    .fill(badge.isUnlocked ?
                                        badge.color.opacity(0.25) :
                                        Color.white.opacity(HomeDesign.fillOpacity))
                                    .frame(width: 60, height: 60)

                                Image(systemName: badge.icon)
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(badge.isUnlocked ?
                                        badge.color : Color.white.opacity(0.3))

                                if !badge.isUnlocked {
                                    Image(systemName: "lock.fill")
                                        .font(.caption2)
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .offset(x: 18, y: 18)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(badge.isUnlocked ?
                                        badge.color.opacity(0.5) :
                                        Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 2)
                            )

                            Text(badge.title)
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(badge.isUnlocked ?
                                    .white : Color.white.opacity(HomeDesign.textTertiaryOpacity))
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
            .padding(HomeDesign.insetLarge)
            .background(Color.white.opacity(HomeDesign.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(HomeDesign.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        }
    }

    var motivationCard: some View {
        // Gunluk motivasyon karti.
        let quote = motivationQuotes.randomElement() ?? motivationQuotes[0]
        return VStack(alignment: .leading, spacing: HomeDesign.insetLarge - 4) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
                Spacer()
                Image(systemName: "sparkles")
                    .font(.headline)
                    .foregroundColor(Color(red: 1.00, green: 0.74, blue: 0.38))
            }

            Text(quote.text)
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Text("— \(quote.author)")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                Spacer()
                Button {
                    // Paylasim islemi.
                } label: {
                    HStack(spacing: HomeDesign.insetSmall - 2) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Paylas")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color.white.opacity(HomeDesign.textSecondaryOpacity))
                    .padding(.horizontal, HomeDesign.insetMedium)
                    .padding(.vertical, HomeDesign.insetSmall)
                    .background(Color.white.opacity(HomeDesign.fillOpacity))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(HomeDesign.insetXL)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.14, green: 0.18, blue: 0.32),
                        Color(red: 0.09, green: 0.12, blue: 0.24)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Dekoratif elementler.
                Circle()
                    .fill(Color(red: 1.00, green: 0.54, blue: 0.24).opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 40)
                    .offset(x: -80, y: -60)

                Circle()
                    .fill(Color(red: 0.36, green: 0.84, blue: 0.65).opacity(0.12))
                    .frame(width: 100, height: 100)
                    .blur(radius: 35)
                    .offset(x: 100, y: 40)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: HomeDesign.radiusCard, style: .continuous))
        .shadow(color: HomeDesign.shadowColor, radius: HomeDesign.shadowRadius, x: 0, y: HomeDesign.shadowY)
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

// MARK: - Haftalik Takvim Modeli
private struct WeekDay: Identifiable {
    let id = UUID()
    let dayName: String
    let dayNumber: Int
    let isSuccess: Bool
    let isToday: Bool
}

// Haftalik gunler verisi (ornek).
private let weeklyDays: [WeekDay] = [
    WeekDay(dayName: "Pzt", dayNumber: 23, isSuccess: true, isToday: false),
    WeekDay(dayName: "Sal", dayNumber: 24, isSuccess: true, isToday: false),
    WeekDay(dayName: "Car", dayNumber: 25, isSuccess: true, isToday: false),
    WeekDay(dayName: "Per", dayNumber: 26, isSuccess: true, isToday: false),
    WeekDay(dayName: "Cum", dayNumber: 27, isSuccess: true, isToday: false),
    WeekDay(dayName: "Cmt", dayNumber: 28, isSuccess: false, isToday: false),
    WeekDay(dayName: "Paz", dayNumber: 29, isSuccess: false, isToday: true)
]

// MARK: - Saglik Iyilesme Modeli
private struct HealthMilestone: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let description: String
    let isAchieved: Bool
}

// Saglik iyilesme kilometre taslari.
private let healthMilestones: [HealthMilestone] = [
    HealthMilestone(
        time: "20 dakika",
        title: "Kalp atisi normallesir",
        description: "Kalp ritmin ve tansiyon dengeye gelmeye basladi.",
        isAchieved: true
    ),
    HealthMilestone(
        time: "8 saat",
        title: "Karbon monoksit dusuyor",
        description: "Kanindaki karbon monoksit seviyesi yarisina indi.",
        isAchieved: true
    ),
    HealthMilestone(
        time: "24 saat",
        title: "Kalp krizi riski azaliyor",
        description: "Kalp krizi riski dusmeye basliyor, damarlar rahatliyor.",
        isAchieved: false
    ),
    HealthMilestone(
        time: "48 saat",
        title: "Tat ve koku duyusu",
        description: "Sinir uclari iyilesiyor, tatlar ve kokular daha belirgin.",
        isAchieved: false
    )
]

// MARK: - Basari Rozeti Modeli
private struct Badge: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

// Basari rozetleri listesi.
private let badges: [Badge] = [
    Badge(
        title: "Ilk Gun",
        icon: "star.fill",
        color: Color(red: 1.00, green: 0.74, blue: 0.38),
        isUnlocked: true
    ),
    Badge(
        title: "3 Gun Seri",
        icon: "flame.fill",
        color: Color(red: 1.00, green: 0.54, blue: 0.24),
        isUnlocked: true
    ),
    Badge(
        title: "1 Hafta",
        icon: "trophy.fill",
        color: Color(red: 0.36, green: 0.84, blue: 0.65),
        isUnlocked: false
    ),
    Badge(
        title: "Nefes Ustasi",
        icon: "lungs.fill",
        color: Color(red: 0.38, green: 0.73, blue: 1.00),
        isUnlocked: true
    ),
    Badge(
        title: "100 TL Tasarruf",
        icon: "banknote.fill",
        color: Color(red: 0.80, green: 0.68, blue: 1.00),
        isUnlocked: false
    ),
    Badge(
        title: "30 Gun Efsane",
        icon: "crown.fill",
        color: Color(red: 0.95, green: 0.36, blue: 0.42),
        isUnlocked: false
    )
]

// MARK: - Motivasyon Sozleri Modeli
private struct MotivationQuote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

// Motivasyon sozleri listesi.
private let motivationQuotes: [MotivationQuote] = [
    MotivationQuote(
        text: "Her gun yeni bir baslangic. Bugunku secimin yarin seni ozgur kilacak.",
        author: "Anonim"
    ),
    MotivationQuote(
        text: "Basari, her gun kucuk adimlar atma cesaretindir.",
        author: "Leo Babauta"
    ),
    MotivationQuote(
        text: "Vucudun sana tesekkur ediyor. Her nefes bir zafer.",
        author: "codeks"
    ),
    MotivationQuote(
        text: "Zor olan dogru olandir. Sen zoru basariyorsun.",
        author: "Theodore Roosevelt"
    ),
    MotivationQuote(
        text: "Bir aliskanligi yenmek icin baska bir aliskanlık olustur: saglik.",
        author: "James Clear"
    )
]
