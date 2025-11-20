# 📱 24 Game – Flutter Project

A simple and fun **24 Puzzle Game** built using Flutter.  
Players receive 4 numbers and must combine them using +, −, ×, ÷ to make **24**.  
Includes both **Play Mode** and **Challenge Mode** with countdown timer.

---

## 🚀 Features

### 🎮 Play Mode
- Generates 4 random numbers
- Must use **all 4 numbers exactly once**
- Supports `+`, `-`, `*`, `/` and parentheses
- Expression parser uses **RPN (Reverse Polish Notation)**
- Saves total score locally using SQLite
- Includes “Reveal Answer” to show a valid solution

### ⏱️ Challenge Mode
- Countdown timer (configurable)
- Solve as many puzzles as possible before time runs out
- Saves **Best Score**
- Handles timer cancellation & prevents duplicated dialogs

### 🐈 Cat GIF (Home Screen)
- Animated intro with cat GIF  
- Stored in `assets/catdance.gif`

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
│ ├── game_page.dart # Main classic mode 24 game
│ ├── home_page.dart # Home page UI with cat GIF
│ ├── main.dart # App entry point
│ └── scores_page.dart # (Optional) Score listing page
│
├── pubspec.yaml # Dependencies + assets
└── README.md # Project documentation



---

## 📦 Dependencies

```yaml
dependencies:
  sqflite: ^2.4.2
  path: ^1.8.3

flutter:
  assets:
    - assets/catdance.gif
```

▶️ Running the App
1. Install dependencies
flutter pub get

2. Run the application
flutter run

🧠 Logic Overview (How the 24 Solver Works)

Generates all permutations of the 4 numbers

Tests every operator combination

Tests all 5 valid parenthesis groupings

Uses:

tokenizer

infix → RPN converter

RPN evaluator

Ensures every puzzle is solvable

🗄️ Database Structure (SQLite)
Table: scores — classic mode history
Column	Type	Description
id	INTEGER	Primary key
player	TEXT	Player name
score	INTEGER	Score value
createdAt	TEXT	Timestamp
Table: challenge_best — stored best score
Column	Type	Description
id	INTEGER	Always = 1
best	INTEGER	Best score
🧪 Future Improvements

Dark mode

Sound effects

Animated success effects

Online leaderboard

Share result to social media

❤️ Credits

Developed by วีรากร โนอินทร์
Flutter 24 Game Project (ICT Mahidol)


---


