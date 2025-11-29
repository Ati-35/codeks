//
//  ContentView.swift
//  codeks
//
//  Created by Atilla on 25.11.2025.
//

import SwiftUI

// Ortak tasarim degerleri: ayni padding, radius, shadow kullanilsin diye.
private enum Design {
    // Spacing seti: 4, 8, 12, 16, 24 (siklikla kullanilan degerler).
    static let insetSmall: CGFloat = 8
    static let insetMedium: CGFloat = 12
    static let insetLarge: CGFloat = 16
    static let insetXL: CGFloat = 24

    // Kenar bosluklari: ekran sag/sol/top/bottom.
    static let screenHInset: CGFloat = 24
    static let screenTop: CGFloat = 56
    static let screenBottom: CGFloat = 32

    // Kartlar ve butonlar icin radius seti.
    static let radiusCard: CGFloat = 20
    static let radiusButton: CGFloat = 16
    static let radiusField: CGFloat = 14

    // Gölge ayari (kartlar ve buyuk butonlar icin).
    static let shadowColor: Color = Color.black.opacity(0.35)
    static let shadowRadius: CGFloat = 22
    static let shadowY: CGFloat = 16

    // Opacity seti.
    static let textPrimaryOpacity: Double = 0.9
    static let textSecondaryOpacity: Double = 0.75
    static let textTertiaryOpacity: Double = 0.65
    static let strokeOpacity: Double = 0.14
    static let fillOpacity: Double = 0.08

    // Arka plan halkalari icin ortak boyutlar/offsetler.
    static let haloOrange = (size: CGSize(width: 250, height: 250), offset: CGSize(width: 130, height: -240), opacity: 0.26)
    static let haloBlue = (size: CGSize(width: 250, height: 250), offset: CGSize(width: -150, height: -140), opacity: 0.21)
    static let haloGreen = (size: CGSize(width: 230, height: 230), offset: CGSize(width: -120, height: 260), opacity: 0.20)
}

struct ContentView: View {
    @State private var isLoggedIn = false // Kullanici giris yapti mi? Evet ise ana sayfa acilir.
    @State private var email = "" // Kullanicinin yazdigi e-posta burada saklanir.
    @State private var password = "" // Kullanicinin yazdigi sifre burada saklanir.
    @State private var staySignedIn = true // Kisi isterse oturum acik kalsin diye bu degiskeni kullaniriz.

    var body: some View {
        // Giris yapilmissa ana sayfa, yapilmamissa giris ekrani gorunur.
        if isLoggedIn {
            HomeView {
                isLoggedIn = false // Cikis isterse geri giris ekranina don.
            }
        } else {
        // ZStack: En arkada arka plan, onun ustunde diger her sey duruyor.
        ZStack {
            background // Renkli, yumusak arka plan.
            VStack(spacing: Design.insetXL) { // Dikey yigin: ustte baslik, ortada form, altta alt bilgi.
                header // Karsilama metinleri.
                formCard // Giris formu karti.
                Spacer() // Bosluk: form ile alt bilgi arasini acar.
                footer // Kayit ve bilgilendirme metni.
            }
            .padding(.horizontal, Design.screenHInset) // Sag ve sol bosluk.
            .padding(.top, Design.screenTop) // Ust bosluk.
            .padding(.bottom, Design.screenBottom) // Alt bosluk.
        }
        }
    }
}

#Preview {
    ContentView() // Xcode icinde on izleme icin.
}

private extension ContentView {
    var background: some View {
        // Bu kisim: ekrani yumusak renklerle boyar ve parlak halkalar ekler.
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.10, blue: 0.24),
                    Color(red: 0.03, green: 0.05, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() // Renkler tum ekrana tasar.

            Circle()
                .fill(Color(red: 1.00, green: 0.54, blue: 0.24).opacity(Design.haloOrange.opacity))
                .frame(width: Design.haloOrange.size.width, height: Design.haloOrange.size.height)
                .blur(radius: 90)
                .offset(x: Design.haloOrange.offset.width, y: Design.haloOrange.offset.height) // Turuncu parlama, sag ust.

            Circle()
                .fill(Color(red: 0.35, green: 0.60, blue: 1.00).opacity(Design.haloBlue.opacity))
                .frame(width: Design.haloBlue.size.width, height: Design.haloBlue.size.height)
                .blur(radius: 90)
                .offset(x: Design.haloBlue.offset.width, y: Design.haloBlue.offset.height) // Mavi parlama, sol ust.

            Circle()
                .fill(Color(red: 0.32, green: 0.86, blue: 0.65).opacity(Design.haloGreen.opacity))
                .frame(width: Design.haloGreen.size.width, height: Design.haloGreen.size.height)
                .blur(radius: 90)
                .offset(x: Design.haloGreen.offset.width, y: Design.haloGreen.offset.height) // Yesil parlama, sol alt.
        }
    }

    var header: some View {
        // Kullaniciyi karsilayan baslik ve kisa aciklama.
        VStack(alignment: .leading, spacing: Design.insetMedium) {
            Text("Sigara birakma yolculuguna hazir misin?")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.8)
                .lineLimit(2)

            Text("Aliskanliklarini takip et, hedef koy ve motivasyonunu yuksek tut. Baslayalim.")
                .font(.body)
                .foregroundColor(Color.white.opacity(Design.textSecondaryOpacity))
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var formCard: some View {
        // Cam efektli kart: giris alanlari, butonlar, sosyal giris.
        VStack(alignment: .leading, spacing: Design.insetLarge) {
            VStack(alignment: .leading, spacing: Design.insetSmall/2) {
                Text("Giris yap")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Text("Hesabina baglan ve ilerlemeni kaydet.")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(Design.textSecondaryOpacity))
            }

            // E-posta kutusu.
            InputField(
                label: "E-posta",
                placeholder: "sen@example.com",
                systemImage: "envelope.fill",
                text: $email
            )

            // Sifre kutusu (nokta nokta gizlenir).
            InputField(
                label: "Sifre",
                placeholder: "••••••••",
                systemImage: "lock.fill",
                text: $password,
                isSecure: true
            )

            // Oturum acik kalsin secenegi.
            Toggle(isOn: $staySignedIn) {
                Text("Oturum acik kalsin")
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
            }
            .toggleStyle(SwitchToggleStyle(tint: Color(red: 1.00, green: 0.54, blue: 0.24)))

            // Ana devam butonu.
            Button {
                isLoggedIn = true // Bu ornekte dogrudan ana sayfaya geceriz.
            } label: {
                HStack {
                    Text("Devam et")
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.headline.weight(.semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, Design.insetLarge)
                .padding(.vertical, Design.insetMedium)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 1.00, green: 0.54, blue: 0.24),
                            Color(red: 0.98, green: 0.31, blue: 0.29)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: Design.radiusButton, style: .continuous))
                .shadow(color: Design.shadowColor, radius: Design.shadowRadius, x: 0, y: Design.shadowY)
            }
            .buttonStyle(.plain)

            // "veya" bolumu: diger secenekler.
            HStack {
                Divider().background(Color.white.opacity(0.4))
                Text("veya")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.7))
                Divider().background(Color.white.opacity(0.4))
            }

            // Sosyal giris butonlari.
            HStack(spacing: 12) {
                SocialButton(title: "Apple", systemImage: "apple.logo")
                SocialButton(title: "Google", systemImage: "globe")
            }

            // Sifre unuttum baglantisi.
            Button {
                // TODO: Forgot password flow.
            } label: {
                Text("Sifreni mi unuttun?")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(Color.white.opacity(0.8))
                    .underline()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .buttonStyle(.plain)
        }
        .padding(Design.insetXL)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Design.radiusCard, style: .continuous)) // Cam efekti.
        .overlay(
            RoundedRectangle(cornerRadius: Design.radiusCard, style: .continuous)
                .strokeBorder(Color.white.opacity(Design.strokeOpacity), lineWidth: 1) // Ince beyaz cizgi.
        )
        .shadow(color: Design.shadowColor, radius: Design.shadowRadius, x: 0, y: Design.shadowY) // Kartin arkasina golge.
    }

    var footer: some View {
        // Eger hesabi yoksa kaydol cagrisi.
        HStack(spacing: 6) {
            Text("Hesabin yok mu?")
                .foregroundColor(Color.white.opacity(0.75))
            Button {
                // TODO: Sign up flow.
            } label: {
                Text("Kaydol")
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                    .underline()
            }
            .buttonStyle(.plain)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// Ortak text alanlari icin kucuk bir parca.
private struct InputField: View {
    let label: String // Kullaniciya gosterdigimiz baslik.
    let placeholder: String // Icine gri renkle yazilan ipucu metni.
    let systemImage: String // Sol taraftaki SF Symbol ikonu.
    @Binding var text: String // Disaridaki degiskenle bagli veri.
    var isSecure: Bool = false // True ise yazilan karakterler gizlenir.

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundColor(Color.white.opacity(Design.textTertiaryOpacity))
                .kerning(0.6)

            HStack(spacing: Design.insetMedium) {
                Image(systemName: systemImage)
                    .foregroundColor(Color.white.opacity(Design.textSecondaryOpacity))
                    .frame(width: 18, height: 18) // Ikon icin sabit alan.

                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text) // Sifre alaninda nokta nokta yazar.
                    } else {
                        TextField(placeholder, text: $text) // Normal text kutusu.
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                    }
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal, Design.insetLarge - 2)
            .padding(.vertical, Design.insetMedium)
            .background(Color.white.opacity(Design.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: Design.radiusField, style: .continuous)
                    .stroke(Color.white.opacity(Design.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Design.radiusField, style: .continuous))
        }
    }
}

// Apple ve Google butonlarini ayni tarzda gosteren parca.
private struct SocialButton: View {
    let title: String // Buton uzerindeki yazi.
    let systemImage: String // Soldaki ikon adi.

    var body: some View {
        Button {
            // TODO: Social sign in action.
        } label: {
            HStack(spacing: Design.insetMedium) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Design.insetMedium)
            .background(Color.white.opacity(Design.fillOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: Design.radiusField, style: .continuous)
                    .stroke(Color.white.opacity(Design.strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Design.radiusField, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
