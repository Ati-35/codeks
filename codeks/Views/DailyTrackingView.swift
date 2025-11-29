import SwiftUI

struct DailyTrackingView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var todayRecord: DailyRecord?
    @State private var didSmoke: Bool = false
    @State private var selectedMood: DailyRecord.MoodLevel = .neutral
    @State private var cravingCount: Int = 0
    @State private var notes: String = ""
    @State private var showCravingSheet = false
    
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
                    smokingStatusCard
                    moodTrackerCard
                    cravingCard
                    notesCard
                    saveButton
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            loadTodayRecord()
        }
        .sheet(isPresented: $showCravingSheet) {
            CravingLogSheet(onSave: { record in
                userManager.saveCravingRecord(record)
                cravingCount += 1
            })
        }
    }
    
    // MARK: - Bilesenler
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Günlük Takip")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            
            Text(Date(), style: .date)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var smokingStatusCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bugün sigara içtin mi?")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                StatusButton(
                    title: "Hayır",
                    icon: "checkmark.circle.fill",
                    color: Color(red: 0.36, green: 0.84, blue: 0.65),
                    isSelected: !didSmoke
                ) {
                    didSmoke = false
                }
                
                StatusButton(
                    title: "Evet",
                    icon: "xmark.circle.fill",
                    color: Color(red: 0.95, green: 0.36, blue: 0.42),
                    isSelected: didSmoke
                ) {
                    didSmoke = true
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
    
    private var moodTrackerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ruh halini nasıl?")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                ForEach(DailyRecord.MoodLevel.allCases, id: \.self) { mood in
                    MoodButton(mood: mood, isSelected: selectedMood == mood) {
                        selectedMood = mood
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
    
    private var cravingCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Kraving sayısı")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(cravingCount)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color(red: 1.00, green: 0.54, blue: 0.24))
            }
            
            Button {
                showCravingSheet = true
            } label: {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.headline)
                    Text("Kraving Kaydet")
                        .font(.headline.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
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
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notlar (opsiyonel)")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(12)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
        .padding(20)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var saveButton: some View {
        Button {
            saveTodayRecord()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                Text("Kaydet")
                    .font(.headline.weight(.semibold))
            }
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
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Fonksiyonlar
    
    private func loadTodayRecord() {
        if let record = userManager.getTodayRecord() {
            todayRecord = record
            didSmoke = record.didSmoke
            selectedMood = record.mood
            cravingCount = record.cravingCount
            notes = record.notes ?? ""
        }
    }
    
    private func saveTodayRecord() {
        let record = DailyRecord(
            date: Date(),
            didSmoke: didSmoke,
            mood: selectedMood,
            cravingCount: cravingCount,
            notes: notes.isEmpty ? nil : notes
        )
        
        userManager.saveDailyRecord(record)
    }
}

// MARK: - Yardimci Gorunumler

private struct StatusButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(isSelected ? color : .white.opacity(0.5))
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(isSelected ? color.opacity(0.2) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? color : Color.white.opacity(0.14), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct MoodButton: View {
    let mood: DailyRecord.MoodLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.title2)
                Text(mood.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? mood.color.opacity(0.3) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? mood.color : Color.white.opacity(0.14), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Kraving Kayit Sheet

private struct CravingLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var intensity: Double = 5
    @State private var trigger: String = ""
    @State private var copingStrategy: String = ""
    
    let onSave: (CravingRecord) -> Void
    
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
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Şiddet Seviyesi: \(Int(intensity))/10")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Slider(value: $intensity, in: 1...10, step: 1)
                                .tint(Color(red: 1.00, green: 0.54, blue: 0.24))
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tetikleyici (opsiyonel)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Örn: stres, kahve, arkadaşlar", text: $trigger)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Başa Çıkma Yöntemi (opsiyonel)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Örn: nefes egzersizi, yürüyüş", text: $copingStrategy)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        Button {
                            let record = CravingRecord(
                                date: Date(),
                                intensity: Int(intensity),
                                trigger: trigger.isEmpty ? nil : trigger,
                                copingStrategy: copingStrategy.isEmpty ? nil : copingStrategy,
                                wasSuccessful: true
                            )
                            onSave(record)
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
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Kraving Kaydet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    DailyTrackingView()
        .environmentObject(UserManager.shared)
}


