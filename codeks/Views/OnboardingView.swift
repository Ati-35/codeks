import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var currentPage = 0
    @State private var name = ""
    @State private var cigarettesPerDay = 20
    @State private var pricePerPack = 60.0
    @State private var cigarettesPerPack = 20
    @State private var quitDate = Date()
    @State private var selectedMotivations: Set<String> = []
    
    let motivationOptions = [
        "Sağlığım için", "Ailem için", "Para biriktirmek için",
        "Daha iyi görünmek için", "Örnek olmak için", "Özgür olmak için"
    ]
    
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
            
            VStack(spacing: 0) {
                // Sayfa içeriği
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    namePage.tag(1)
                    smokingInfoPage.tag(2)
                    motivationPage.tag(3)
                    readyPage.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Alt navigasyon
                HStack(spacing: 12) {
                    if currentPage > 0 {
                        Button {
                            withAnimation {
                                currentPage -= 1
                            }
                        } label: {
                            Text("Geri")
                                .font(.headline.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button {
                        if currentPage < 4 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    } label: {
                        Text(currentPage == 4 ? "Başla" : "Devam")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(currentPage == 1 && name.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Sayfa göstergesi
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Sayfalar
    
    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
            
            Text("CODEKS'e Hoş Geldin!")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Sigara bırakma yolculuğunda seninleyiz. Birlikte başaracağız!")
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(24)
    }
    
    private var namePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Adın nedir?")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Seni nasıl çağıralım?")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("Adını yaz", text: $name)
                    .font(.title3)
                    .padding(20)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }
            
            Spacer()
        }
        .padding(24)
    }
    
    private var smokingInfoPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sigara Bilgilerin")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("Tasarruf hesabı için ihtiyacımız var")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Günde kaç sigara içiyordun?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Stepper(value: $cigarettesPerDay, in: 1...100) {
                        Text("\(cigarettesPerDay) adet")
                            .font(.title2.weight(.bold))
                            .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bir paket sigaranın fiyatı?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Stepper(value: $pricePerPack, in: 10...200, step: 5) {
                        Text(String(format: "%.0f TL", pricePerPack))
                            .font(.title2.weight(.bold))
                            .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ne zaman bıraktın?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    DatePicker("", selection: $quitDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(20)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .tint(Color(red: 1.00, green: 0.54, blue: 0.24))
                }
            }
            .padding(24)
        }
    }
    
    private var motivationPage: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Neden Bırakıyorsun?")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Motivasyonlarını seç (birden fazla seçebilirsin)")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                ForEach(motivationOptions, id: \.self) { option in
                    MotivationButton(
                        title: option,
                        isSelected: selectedMotivations.contains(option)
                    ) {
                        if selectedMotivations.contains(option) {
                            selectedMotivations.remove(option)
                        } else {
                            selectedMotivations.insert(option)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(24)
    }
    
    private var readyPage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(Color(red: 0.36, green: 0.84, blue: 0.65))
            
            Text("Hazırsın, \(name)!")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                Text("Bugünden itibaren sigara içilmeyen:")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("\(Calendar.current.dateComponents([.day], from: quitDate, to: Date()).day ?? 0) gün")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
            }
            
            Text("Hadi başlayalım!")
                .font(.title2)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
        }
        .padding(24)
    }
    
    // MARK: - Fonksiyonlar
    
    private func completeOnboarding() {
        // Kullanıcı profilini oluştur ve kaydet
        let profile = UserProfile(
            name: name,
            quitDate: quitDate,
            cigarettesPerDay: cigarettesPerDay,
            pricePerPack: pricePerPack,
            cigarettesPerPack: cigarettesPerPack,
            motivations: Array(selectedMotivations)
        )
        
        userManager.saveUserProfile(profile)
        userManager.completeOnboarding()
    }
}

// MARK: - Yardimci Gorunumler

private struct MotivationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? 
                                    Color(red: 0.36, green: 0.84, blue: 0.65) : 
                                    .white.opacity(0.3))
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .background(isSelected ? 
                       Color(red: 0.36, green: 0.84, blue: 0.65).opacity(0.2) : 
                       Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? 
                           Color(red: 0.36, green: 0.84, blue: 0.65) : 
                           Color.white.opacity(0.14), 
                           lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(UserManager.shared)
}


