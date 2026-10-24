import SwiftUI

struct FlashcardsView: View {
    @State private var index = 0
    @State private var showingBack = false

    private var cards: [Flashcard] { LearningData.flashcards }

    var body: some View {
        VStack(spacing: 24) {
            Text("Fiszka \(index + 1) z \(cards.count)")
                .foregroundStyle(.secondary)
            Spacer()
            Button {
                withAnimation(.smooth) { showingBack.toggle() }
            } label: {
                VStack(spacing: 16) {
                    Image(systemName: "rectangle.on.rectangle.angled")
                        .font(.largeTitle)
                    Text(showingBack ? cards[index].back : cards[index].front)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text("Dotknij, aby \(showingBack ? "zobaczyć pytanie" : "odkryć odpowiedź")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 260)
                .padding()
                .glassEffect(in: .rect(cornerRadius: 28))
            }
            .buttonStyle(.plain)
            Spacer()
            HStack {
                Button("Poprzednia", systemImage: "chevron.left") { move(-1) }
                    .disabled(index == 0)
                Spacer()
                Button("Następna", systemImage: "chevron.right") { move(1) }
                    .disabled(index == cards.count - 1)
            }
            .buttonStyle(.glass)
        }
        .padding()
        .navigationTitle("Fiszki")
    }

    private func move(_ offset: Int) {
        index += offset
        showingBack = false
    }
}
