import Foundation

struct Question: Identifiable, Hashable {
    let id: Int
    let topic: String
    let prompt: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}

struct Flashcard: Identifiable {
    let id: Int
    let front: String
    let back: String
}

enum LearningData {
    // Original example questions written for this open educational prototype.
    // No proprietary Android app data is included.
    static let questions: [Question] = [
        Question(id: 1, topic: "HTML", prompt: "Który znacznik HTML tworzy hiperłącze?",
                 answers: ["<link>", "<a>", "<href>", "<url>"], correctIndex: 1,
                 explanation: "Znacznik <a> z atrybutem href określa odnośnik."),
        Question(id: 2, topic: "HTML", prompt: "Który atrybut obrazu opisuje jego treść dla czytników ekranu?",
                 answers: ["src", "title", "alt", "width"], correctIndex: 2,
                 explanation: "Atrybut alt zawiera tekst alternatywny obrazu."),
        Question(id: 3, topic: "HTML", prompt: "Który znacznik służy do utworzenia formularza?",
                 answers: ["<form>", "<input>", "<fieldset>", "<section>"], correctIndex: 0,
                 explanation: "<form> grupuje kontrolki formularza i umożliwia wysłanie danych."),
        Question(id: 4, topic: "CSS", prompt: "Która właściwość CSS zmienia kolor tekstu?",
                 answers: ["background", "font-style", "color", "fill"], correctIndex: 2,
                 explanation: "Właściwość color ustala kolor tekstu."),
        Question(id: 5, topic: "CSS", prompt: "Co oznacza selektor CSS .menu?",
                 answers: ["Identyfikator menu", "Klasę menu", "Znacznik menu", "Atrybut menu"], correctIndex: 1,
                 explanation: "Kropka w selektorze CSS oznacza klasę."),
        Question(id: 6, topic: "CSS", prompt: "Która deklaracja ustawia element jako kontener Flexbox?",
                 answers: ["display: flex", "position: flex", "layout: flex", "flex: on"], correctIndex: 0,
                 explanation: "Flexbox włącza się poprzez display: flex."),
        Question(id: 7, topic: "SQL", prompt: "Która instrukcja SQL odczytuje wiersze z tabeli?",
                 answers: ["INSERT", "UPDATE", "SELECT", "DROP"], correctIndex: 2,
                 explanation: "SELECT służy do pobierania danych z relacyjnej bazy."),
        Question(id: 8, topic: "SQL", prompt: "Do czego służy warunek WHERE w zapytaniu SELECT?",
                 answers: ["Sortowania", "Filtrowania wierszy", "Tworzenia tabel", "Nadawania uprawnień"], correctIndex: 1,
                 explanation: "WHERE ogranicza wynik do rekordów spełniających warunek."),
        Question(id: 9, topic: "SQL", prompt: "Która klauzula SQL sortuje wynik zapytania?",
                 answers: ["GROUP BY", "ORDER BY", "HAVING", "LIMIT"], correctIndex: 1,
                 explanation: "ORDER BY określa kolejność wyświetlania wierszy."),
        Question(id: 10, topic: "SQL", prompt: "Która funkcja agregująca liczy wiersze?",
                 answers: ["SUM()", "AVG()", "COUNT()", "LENGTH()"], correctIndex: 2,
                 explanation: "COUNT(*) zlicza wiersze uwzględnione w wyniku."),
        Question(id: 11, topic: "JavaScript", prompt: "Które słowo kluczowe deklaruje zmienną, której nie można przypisać ponownie?",
                 answers: ["var", "const", "static", "fixed"], correctIndex: 1,
                 explanation: "const uniemożliwia ponowne przypisanie identyfikatora."),
        Question(id: 12, topic: "JavaScript", prompt: "Co zwraca typeof 42 w JavaScript?",
                 answers: ["integer", "number", "float", "string"], correctIndex: 1,
                 explanation: "W JavaScript liczby tego typu mają typ number."),
        Question(id: 13, topic: "PHP", prompt: "Która funkcja PHP rozpoczyna sesję?",
                 answers: ["start_session()", "session_open()", "session_start()", "new_session()"], correctIndex: 2,
                 explanation: "session_start() rozpoczyna lub wznawia sesję PHP."),
        Question(id: 14, topic: "PHP", prompt: "Jaki znak rozpoczyna nazwę zmiennej w PHP?",
                 answers: ["#", "$", "@", "%"], correctIndex: 1,
                 explanation: "Nazwy zmiennych PHP są poprzedzone znakiem dolara."),
        Question(id: 15, topic: "Sieci", prompt: "Jaki kod HTTP najczęściej oznacza brak wskazanego zasobu?",
                 answers: ["200", "301", "404", "500"], correctIndex: 2,
                 explanation: "HTTP 404 oznacza Not Found."),
        Question(id: 16, topic: "Sieci", prompt: "Który protokół szyfruje ruch przeglądarki za pomocą TLS?",
                 answers: ["HTTP", "FTP", "HTTPS", "SMTP"], correctIndex: 2,
                 explanation: "HTTPS to HTTP transmitowany przez zabezpieczone połączenie TLS.")
    ]

    static let flashcards: [Flashcard] = [
        Flashcard(id: 1, front: "SELECT", back: "Pobiera dane z tabeli bazy danych."),
        Flashcard(id: 2, front: "WHERE", back: "Ogranicza wiersze na podstawie warunku."),
        Flashcard(id: 3, front: "ORDER BY", back: "Sortuje wynik zapytania SQL."),
        Flashcard(id: 4, front: "PRIMARY KEY", back: "Klucz główny jednoznacznie identyfikuje rekord."),
        Flashcard(id: 5, front: "FOREIGN KEY", back: "Klucz obcy wskazuje rekord z innej tabeli."),
        Flashcard(id: 6, front: "HTML alt", back: "Tekst alternatywny dla obrazka."),
        Flashcard(id: 7, front: "CSS display: flex", back: "Włącza układ Flexbox."),
        Flashcard(id: 8, front: "CSS #id", back: "Wybiera element o wskazanym identyfikatorze."),
        Flashcard(id: 9, front: "JavaScript const", back: "Deklaruje wiązanie bez możliwości ponownego przypisania."),
        Flashcard(id: 10, front: "PHP session_start()", back: "Rozpoczyna albo wznawia sesję."),
        Flashcard(id: 11, front: "HTTP 404", back: "Żądany zasób nie został znaleziony."),
        Flashcard(id: 12, front: "COUNT(*)", back: "Zlicza liczbę wierszy.")
    ]

    static var topics: [String] {
        Array(Set(questions.map(\.topic))).sorted()
    }
}
