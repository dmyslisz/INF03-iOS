import SwiftUI
import SQLite3

struct SQLView: View {
    @State private var query = "SELECT * FROM uczniowie;"
    @State private var output = "Wykonaj zapytanie SELECT, aby zobaczyć dane."
    @State private var rows: [[String]] = []
    @State private var columns: [String] = []
    @State private var database = TrainingDatabase()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Trener SQL")
                    .font(.largeTitle.bold())
                Text("Lokalna baza SQLite z przykładową tabelą uczniowie. Tylko zapytania SELECT/WITH, bez zmian w bazie.")
                    .foregroundStyle(.secondary)
                Text("Kolumny: id, imie, klasa, punkty")
                    .font(.caption.monospaced())
                TextEditor(text: $query)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 130)
                    .padding(10)
                    .glassEffect(in: .rect(cornerRadius: 18))
                    .accessibilityLabel("Zapytanie SQL")
                Button("Wykonaj zapytanie", systemImage: "play.fill") {
                    do {
                        let result = try database.execute(query)
                        columns = result.columns
                        rows = result.rows
                        output = "Znaleziono \(rows.count) wierszy (maksymalnie 100)."
                    } catch {
                        columns = []
                        rows = []
                        output = error.localizedDescription
                    }
                }
                .buttonStyle(.glassProminent)
                Text(output)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !columns.isEmpty {
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 15) {
                                ForEach(columns.indices, id: \.self) { i in
                                    Text(columns[i])
                                        .bold()
                                        .frame(minWidth: 100, alignment: .leading)
                                }
                            }
                            Divider()
                            ForEach(rows.indices, id: \.self) { row in
                                HStack(spacing: 15) {
                                    ForEach(rows[row].indices, id: \.self) { column in
                                        Text(rows[row][column])
                                            .frame(minWidth: 100, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .font(.subheadline.monospaced())
                        .padding()
                    }
                    .glassEffect(in: .rect(cornerRadius: 18))
                }
                Text("Przykłady")
                    .font(.headline)
                ForEach([
                    "SELECT * FROM uczniowie;",
                    "SELECT imie, punkty FROM uczniowie WHERE punkty >= 80;",
                    "SELECT klasa, COUNT(*) AS liczba FROM uczniowie GROUP BY klasa;"
                ], id: \.self) { example in
                    Button(example) { query = example }
                        .font(.footnote.monospaced())
                        .buttonStyle(.glass)
                }
            }
            .padding()
        }
        .navigationTitle("SQL")
    }
}

struct TrainingResult {
    let columns: [String]
    let rows: [[String]]
}

struct TrainingDatabase {
    private var db: OpaquePointer?

    init() {
        if sqlite3_open(":memory:", &db) == SQLITE_OK {
            let setup = """
            CREATE TABLE uczniowie (id INTEGER PRIMARY KEY, imie TEXT, klasa TEXT, punkty INTEGER);
            INSERT INTO uczniowie VALUES (1,'Anna','2TP',92);
            INSERT INTO uczniowie VALUES (2,'Bartek','2TP',72);
            INSERT INTO uczniowie VALUES (3,'Celina','2TI',86);
            INSERT INTO uczniowie VALUES (4,'Damian','2TI',64);
            INSERT INTO uczniowie VALUES (5,'Ewa','2TP',98);
            """
            sqlite3_exec(db, setup, nil, nil, nil)
            sqlite3_exec(db, "PRAGMA query_only = ON;", nil, nil, nil)
        }
    }

    func execute(_ sql: String) throws -> TrainingResult {
        guard let db else {
            throw NSError(domain: "SQL", code: 1, userInfo: [NSLocalizedDescriptionKey: "Nie można otworzyć bazy."])
        }
        let trimmed = sql.trimmingCharacters(in: .whitespacesAndNewlines)
        let upper = trimmed.uppercased()
        guard upper.hasPrefix("SELECT ") || upper.hasPrefix("WITH ") else {
            throw NSError(domain: "SQL", code: 2, userInfo: [NSLocalizedDescriptionKey: "Dostępne są tylko zapytania SELECT i WITH."])
        }
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, trimmed, -1, &statement, nil) == SQLITE_OK, let statement else {
            throw NSError(domain: "SQL", code: 3, userInfo: [NSLocalizedDescriptionKey: String(cString: sqlite3_errmsg(db))])
        }
        defer { sqlite3_finalize(statement) }
        guard sqlite3_stmt_readonly(statement) != 0 else {
            throw NSError(domain: "SQL", code: 4, userInfo: [NSLocalizedDescriptionKey: "Zapytanie modyfikujące dane jest niedozwolone."])
        }
        let count = Int(sqlite3_column_count(statement))
        let names = (0..<count).map { String(cString: sqlite3_column_name(statement, Int32($0))) }
        var result: [[String]] = []
        while result.count < 100 {
            let status = sqlite3_step(statement)
            if status == SQLITE_DONE { break }
            guard status == SQLITE_ROW else {
                throw NSError(domain: "SQL", code: 5, userInfo: [NSLocalizedDescriptionKey: String(cString: sqlite3_errmsg(db))])
            }
            result.append((0..<count).map { index in
                guard let pointer = sqlite3_column_text(statement, Int32(index)) else { return "NULL" }
                return String(cString: pointer)
            })
        }
        return TrainingResult(columns: names, rows: result)
    }
}
