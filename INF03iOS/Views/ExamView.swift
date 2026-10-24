import SwiftUI

struct ExamView: View {
    @AppStorage("bestScore") private var bestScore = 0
    @AppStorage("completedExams") private var completedExams = 0
    @AppStorage("lastScore") private var lastScore = 0

    @State private var questions = Array(LearningData.questions.shuffled())
    @State private var current = 0
    @State private var selection: Int?
    @State private var score = 0
    @State private var remainingSeconds = 3600
    @State private var started = false
    @State private var finished = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if !started {
                    Text("Egzamin próbny")
                        .font(.largeTitle.bold())
                    Text("Wersja demonstracyjna: \(questions.count) pytań z własnej bazy, limit 60 minut. Docelowy egzamin INF.03 ma 40 pytań.")
                        .foregroundStyle(.secondary)
                    Button("Rozpocznij test") {
                        reset()
                        started = true
                    }
                    .buttonStyle(.glassProminent)
                } else if finished {
                    Text("Twój wynik")
                        .font(.largeTitle.bold())
                    Text("\(score) / \(questions.count)")
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                    let percent = questions.isEmpty ? 0 : Int(Double(score) * 100 / Double(questions.count))
                    Text("\(percent)% poprawnych odpowiedzi")
                        .font(.headline)
                    Text(percent >= 50 ? "Świetnie! Przekroczyłeś próg 50%." : "Jeszcze trochę nauki i będzie lepiej!")
                    Button("Nowy egzamin") {
                        reset()
                        started = true
                    }
                    .buttonStyle(.glassProminent)
                } else if current < questions.count {
                    HStack {
                        Text("Pytanie \(current + 1) / \(questions.count)")
                            .font(.headline)
                        Spacer()
                        Label(
                            String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60),
                            systemImage: "clock"
                        )
                        .monospacedDigit()
                    }
                    ProgressView(value: Double(current + 1), total: Double(questions.count))
                    Text(questions[current].topic)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(questions[current].prompt)
                        .font(.title2.bold())
                    ForEach(questions[current].answers.indices, id: \.self) { index in
                        Button {
                            if selection == nil {
                                selection = index
                                if index == questions[current].correctIndex {
                                    score += 1
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Text(String(UnicodeScalar(65 + index)!))
                                    .fontWeight(.bold)
                                Text(questions[current].answers[index])
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 4)
                                if selection == index {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.glass)
                        .disabled(selection != nil)
                    }
                    if let selection {
                        Label(selection == questions[current].correctIndex ? "Poprawnie!" : "Niepoprawnie",
                              systemImage: selection == questions[current].correctIndex ? "checkmark.circle" : "xmark.circle")
                            .font(.headline)
                        Text(questions[current].explanation)
                            .foregroundStyle(.secondary)
                        Button(current == questions.count - 1 ? "Zakończ egzamin" : "Następne pytanie") {
                            if current == questions.count - 1 {
                                finish()
                            } else {
                                current += 1
                                self.selection = nil
                            }
                        }
                        .buttonStyle(.glassProminent)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Egzamin")
        .onReceive(ticker) { _ in
            guard started && !finished else { return }
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                finish()
            }
        }
    }

    private func reset() {
        questions = LearningData.questions.shuffled()
        current = 0
        score = 0
        selection = nil
        remainingSeconds = 3600
        finished = false
    }

    private func finish() {
        guard !finished else { return }
        finished = true
        lastScore = score
        bestScore = max(bestScore, score)
        completedExams += 1
    }
}
