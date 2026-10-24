import SwiftUI

struct LearningView: View {
    @State private var topic: String = "Wszystkie"
    @State private var selectedQuestion: Question?

    private var filtered: [Question] {
        topic == "Wszystkie" ? LearningData.questions :
        LearningData.questions.filter { $0.topic == topic }
    }

    var body: some View {
        List {
            Section("Tematy") {
                Picker("Temat", selection: $topic) {
                    Text("Wszystkie").tag("Wszystkie")
                    ForEach(LearningData.topics, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
            }
            Section("Pytania (\(filtered.count))") {
                ForEach(filtered) { question in
                    Button {
                        selectedQuestion = question
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(question.topic)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tint)
                            Text(question.prompt)
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            Section {
                NavigationLink("Fiszki") {
                    FlashcardsView()
                }
            }
        }
        .navigationTitle("Nauka")
        .sheet(item: $selectedQuestion) { question in
            QuestionDetailView(question: question)
        }
    }
}

struct QuestionDetailView: View {
    let question: Question
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Int?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(question.topic)
                        .foregroundStyle(.secondary)
                    Text(question.prompt)
                        .font(.title2.bold())
                    ForEach(question.answers.indices, id: \.self) { index in
                        Button {
                            selected = index
                        } label: {
                            HStack {
                                Text("\(Character(UnicodeScalar(65 + index)!)). \(question.answers[index])")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if selected == index {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glass)
                        .disabled(selected != nil)
                    }
                    if let selected {
                        Label(
                            selected == question.correctIndex ? "Dobrze!" : "Poprawna odpowiedź: \(question.answers[question.correctIndex])",
                            systemImage: selected == question.correctIndex ? "checkmark.circle" : "info.circle"
                        )
                        .font(.headline)
                        Text(question.explanation)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Pytanie")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                }
            }
        }
    }
}
