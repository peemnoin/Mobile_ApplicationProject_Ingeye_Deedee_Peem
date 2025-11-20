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

