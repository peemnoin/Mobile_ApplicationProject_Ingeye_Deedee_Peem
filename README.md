# 📱 24 Game – Flutter App

A simple Flutter application that lets players solve the classic **24 Puzzle Game**.
You receive 4 numbers and must use `+ - × ÷` and parentheses to make **exactly 24**.

The app includes:
- **Play Mode** — solve single puzzles  
- **Challenge Mode** — solve as many as possible within a time limit  
- **SQLite local database** for saving scores  
- **Animated cat GIF** on the home screen  

---

## 🚀 Features
- Random 4-number generator
- Reverse Polish Notation (RPN) expression parser
- Validates use of all 4 numbers exactly once
- Reveal Answer button
- Challenge Mode with countdown & best score
- Smooth and clean UI

---

## 📂 Project Structure
DRAFT/
│
├── assets/
│ └── catdance.gif
│
├── lib/
│ ├── challenge_page.dart # Challenge Mode
│ ├── db.dart # SQLite database (scores + challenge best)
│ ├── game_page.dart # Classic mode gameplay
│ ├── home_page.dart # Home screen UI (cat GIF)
│ ├── main.dart # App entry point
│ └── scores_page.dart # (Optional) Score listing page
│
├── pubspec.yaml # Dependencies + assets
└── README.md # Project documentation

## ▶️ Run the App

Install dependencies:
```sh
flutter pub get

```

Run the app:
```sh
flutter run

```

## 📁 Assets
Add this inside your pubspec.yaml:
```sh
flutter:
  assets:
```sh

    - assets/catdance.gif

```


