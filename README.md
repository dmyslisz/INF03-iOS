# INF03-iOS

Natywna aplikacja edukacyjna dla iPhone'a (iOS 26), napisana w **SwiftUI** z systemowym **Liquid Glass**.

## Aktualna wersja demonstracyjna

- Ekran startowy i natywne zakładki
- 16 autorskich pytań przykładowych z tematów INF.03
- Demonstracyjny egzamin z limitem 60 minut, wynikiem i wyjaśnieniami
- 12 fiszek
- Lokalny trener SQL wykorzystujący SQLite i bazę przykładową
- Lokalne statystyki, bez konta i bez internetu

**Ważne:** To prototyp, nie oficjalna aplikacja CKE. Nie zawiera pytań skopiowanych z aplikacji Studio Liczb. Egzamin demonstracyjny ma 16, a nie 40 pytań. SQLite może różnić się od MySQL używanego w szkole.

## Jak zbudować IPA bez Maca

Po każdym pushu na gałąź `main` uruchamia się [GitHub Actions](https://github.com/dmyslisz/INF03-iOS/actions).

1. Otwórz **Actions → Build iOS IPA**.
2. Wybierz najnowsze uruchomienie.
3. Jeśli kompilacja się powiedzie, w sekcji **Artifacts** pobierz **INF03iOS-unsigned**.
4. Rozpakuj ZIP — znajdziesz `INF03iOS-unsigned.ipa`.
5. To pakiet **niepodpisany**; przed instalacją na iPhonie trzeba go podpisać (np. Sideloadly na Windows). Darmowy podpis zwykle wygasa po 7 dniach.

Pliki projektu: `project.yml` (XcodeGen), `INF03iOS/` (SwiftUI) i `.github/workflows/ios.yml` (CI).

## Materiały zewnętrzne

Zestawy pytań innych autorów należy dołączać wyłącznie z odpowiednimi uprawnieniami. Projekt nie dystrybuuje ich treści.
