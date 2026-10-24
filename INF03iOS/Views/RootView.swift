import SwiftUI

struct RootView: View {
    @AppStorage("bestScore") private var bestScore = 0
    @AppStorage("completedExams") private var completedExams = 0

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cześć! 👋")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            Text("Zdaj INF.03")
                                .font(.largeTitle.bold())
                            Text("Twój osobisty trener egzaminacyjny.")
                                .foregroundStyle(.secondary)
                        }

                        NavigationLink {
                            ExamView()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Egzamin próbny").font(.title2.bold())
                                    Text("Sprawdź swoją wiedzę")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                        }
                        .buttonStyle(.glassProminent)

                        HStack(spacing: 12) {
                            metric("Pytań", value: "\(LearningData.questions.count)", icon: "questionmark.circle")
                            metric("Najlepszy wynik", value: "\(bestScore)", icon: "star.fill")
                        }

                        Text("Ucz się po swojemu")
                            .font(.title2.bold())
                        NavigationLink("Przeglądaj tematy", systemImage: "books.vertical") {
                            LearningView()
                        }
                        .buttonStyle(.glass)
                        NavigationLink("Powtórz fiszki", systemImage: "rectangle.on.rectangle") {
                            FlashcardsView()
                        }
                        .buttonStyle(.glass)
                    }
                    .padding()
                }
                .navigationTitle("Start")
            }
            .tabItem { Label("Start", systemImage: "house.fill") }

            NavigationStack { LearningView() }
                .tabItem { Label("Nauka", systemImage: "books.vertical.fill") }

            NavigationStack { ExamView() }
                .tabItem { Label("Egzamin", systemImage: "checkmark.circle.fill") }

            NavigationStack { SQLView() }
                .tabItem { Label("SQL", systemImage: "curlybraces") }

            NavigationStack { StatsView() }
                .tabItem { Label("Postępy", systemImage: "chart.bar.fill") }
        }
        .tint(.indigo)
    }

    private func metric(_ label: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(label, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}
