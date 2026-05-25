# 🚀 Startup Idea Evaluator

A Flutter mobile app where users submit startup ideas, get a fun AI-generated rating, vote on others' ideas, and compete on a leaderboard.

---

## 📱 Features Implemented

### ✅ Core Features
- **Idea Submission Screen** — Form with Startup Name, Tagline, Description fields. On submit, generates a fake AI rating (0–100) with a fun 1.2s "processing" animation, saves locally, and navigates to listing.
- **Idea Listing Screen** — Displays all ideas with name, tagline, AI rating, vote count, upvote button (one vote per idea, enforced via SharedPreferences), "Read more" expand/collapse, and sort by rating or votes.
- **Leaderboard Screen** — Top 5 ideas with 🥇🥈🥉 medals, gradient cards, and combined vote + rating display.

### ✨ Bonus Features
- **Dark Mode Toggle** — Persistent dark/light mode across sessions via SharedPreferences.
- **Toast Notifications** — On submission ("AI rated it X/100") and on voting ("👍 Upvoted!"), with duplicate vote warning.
- **Share Idea** — Share any idea via native share sheet (share_plus).
- **Animated UI** — Upvote button bounce animation, fade-in on load, animated expand/collapse for descriptions.
- **Polished Design** — Gradient hero card, color-coded AI ratings (green/amber/red), custom typography (Space Grotesk + Plus Jakarta Sans).

---

## 🧑‍💻 Tech Stack

| Layer | Library/Tool |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | Provider |
| Persistence | SharedPreferences |
| Fonts | google_fonts (Space Grotesk, Plus Jakarta Sans) |
| Toast | fluttertoast |
| Sharing | share_plus |
| ID Generation | uuid |

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry point
├── theme.dart                       # Light & dark theme config
├── models/
│   └── startup_idea.dart            # Data model + JSON serialization
├── providers/
│   └── ideas_provider.dart          # State management + persistence
├── screens/
│   ├── submit_idea_screen.dart      # Idea submission (Screen 1)
│   ├── idea_listing_screen.dart     # All ideas list (Screen 2)
│   └── leaderboard_screen.dart      # Top 5 leaderboard (Screen 3)
└── widgets/
    └── idea_card.dart               # Reusable idea card widget
```

---

## 🚀 How to Run Locally

### Prerequisites
- Flutter SDK ≥ 3.0.0 installed ([flutter.dev/docs/get-started](https://flutter.dev/docs/get-started))
- Android Studio or VS Code with Flutter extension
- Android emulator / physical device (or iOS simulator on macOS)

### Steps

```bash
# Clone the repo
git clone <https://github.com/nigamman/pgagi_flutter_task.git>
cd shivansh_flutter_task

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build debug APK (Android)
flutter build apk --debug
# APK will be at: build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📦 Install APK (Android)

1. Download `app-debug.apk` from the Google Drive link: _[https://drive.google.com/file/d/1-F9FOKCkLL_zRTDBcxZZZqk9OksrgxMq/view?usp=drivesdk]_
2. Enable **Install from unknown sources** in Android settings
3. Tap the APK to install

---

## 🤖 How the AI Rating Works

The "AI rating" is a fun deterministic fake — it's seeded by the idea's content length and keywords:
- Base: random 45–84 range seeded by text length
- Bonus points for longer descriptions, using buzzwords like "AI", "blockchain", "disrupt"
- Capped at 100

Same idea always gets the same rating (deterministic seed), but it's designed to feel surprising!
