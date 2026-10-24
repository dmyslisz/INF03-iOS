import SwiftUI

struct StatsView: View {
    @AppStorage("bestScore") private var bestScore = 0
    @AppStorage("completedExams") private var completedExams = 0
    @AppStorage("lastScore") private var lastScore = 0

    var body: some View {
        List {
            Section("Egzaminy") {
                LabeledContent("Ukończone testy", value: "\(completedExams)")
                LabeledContent("Najlepszy wynik", value: "\(bestScore) / \(LearningData.questions.count)")
                LabeledContent("Ostatni wynik", value: "\(lastScore) / \(LearningData.questions.count)")
            }
            Section("Baza ćwiczeń") {
                LabeledContent("Pytania", value: "\(LearningData.questions.count)")
                LabeledContent("Fiszki", value: "\(LearningData.flashcards.count)")
                LabeledContent("Tematy", value: "\(LearningData.topics.count)")
            }
            Section {
                Text("Wyniki egzaminów zapisywane są lokalnie na tym iPhonie. W tej wersji nie ma kont ani synchronizacji.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Postępy")
    }
}
