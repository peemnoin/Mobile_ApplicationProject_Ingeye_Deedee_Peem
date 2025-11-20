import 'dart:async';
import 'package:flutter/material.dart';
import 'db.dart';
import 'game_page.dart'; 

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final TextEditingController exprController = TextEditingController();

  int timeLeft = 240;
  Timer? timer;

  int score = 0;
  int bestScore = 0;

  late List<int> nums;
  String expr = "";

  bool isTimeUpShown = false; // <--- prevents double dialog

  @override
  void initState() {
    super.initState();
    nums = generatePuzzle();
    loadBestScore();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Load best score from DB
  Future<void> loadBestScore() async {
    bestScore = await ScoreDatabase.instance.getChallengeBestScore();
    setState(() {});
  }

  /// Countdown timer
  void startTimer() {
    isTimeUpShown = false;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        if (!isTimeUpShown) {
          isTimeUpShown = true;
          t.cancel();
          showTimeUpDialog();
        }
        return;
      }

      setState(() => timeLeft--);
    });
  }

  /// Show "Time's Up" dialog immediately
  void showTimeUpDialog() async {
    bool isRecord = score > bestScore;

    if (isRecord) {
      await ScoreDatabase.instance.saveChallengeBestScore(score);
      bestScore = score;
    }

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 50)); // ensure UI stable

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Time's Up!"),
        content: Text(
          "Your Score: $score\n"
          "Best Score: $bestScore\n"
          "${isRecord ? "NEW RECORD!" : ""}",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            child: const Text("Back to Home"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Try Again"),
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
          ),
        ],
      ),
    );
  }

  /// Reset game for replay
  void resetGame() {
    timer?.cancel();

    setState(() {
      score = 0;
      timeLeft = 240;
      nums = generatePuzzle();
      exprController.clear();
      expr = "";
    });

    startTimer();
  }

  /// Validate and check user answer
  void checkChallenge() {
    if (!usesAll4Once(expr, nums)) {
      showSnack("Use all 4 numbers exactly once.");
      return;
    }

    final tokens = tokenize(expr);
    final rpn = infixToRPN(tokens);

    if (rpn == null) {
      showSnack("Invalid expression.");
      return;
    }

    final result = evalRPN(rpn);
    if (result == null) {
      showSnack("Error in calculation.");
      return;
    }

    if ((result - 24).abs() < eps) {
      score++;
      showSnack("Correct! +1 point");
      nextPuzzle();
    } else {
      showSnack("Not 24. Try again!");
    }
  }

  /// Move to next puzzle
  void nextPuzzle() {
    setState(() {
      nums = generatePuzzle();
      exprController.clear();
      expr = "";
    });
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mins = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final secs = (timeLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge Mode"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TIMER
            Text(
              "$mins:$secs",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Text(
              "Score: $score     Best: $bestScore",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 25),

            // NUMBERS
            Text(
              "Numbers: ${nums.join(", ")}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 10),

            // EXPRESSION
            TextField(
              readOnly: true,
              controller: exprController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Expression",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: () {
                    if (exprController.text.isNotEmpty) {
                      exprController.text =
                          exprController.text.substring(0, exprController.text.length - 1);
                      expr = exprController.text;
                      setState(() {});
                    }
                  },
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 15),

            // NUMBER BUTTONS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: nums
                  .map(
                    (n) => FilledButton(
                      onPressed: () {
                        exprController.text += n.toString();
                        expr = exprController.text;
                        setState(() {});
                      },
                      child: Text(
                        n.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            // OPERATORS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: ['+', '-', '*', '/', '(', ')']
                  .map(
                    (op) => OutlinedButton(
                      onPressed: () {
                        exprController.text += op;
                        expr = exprController.text;
                        setState(() {});
                      },
                      child: Text(op, style: const TextStyle(fontSize: 20)),
                    ),
                  )
                  .toList(),
            ),

            const Spacer(),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: checkChallenge,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text("Submit", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
