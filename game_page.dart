import 'dart:math';
import 'package:flutter/material.dart';
import 'db.dart';

// 24 GAME LOGIC (Solver + Parser)

const double eps = 1e-6;
const List<String> ops = ['+', '-', '*', '/'];
final Random rand = Random();

double? apply(double a, double b, String op) {
  if (op == '+') return a + b;
  if (op == '-') return a - b;
  if (op == '*') return a * b;
  if (op == '/') {
    if (b.abs() < eps) return null;
    return a / b;
  }
  return null;
}

bool has24Solution(List<int> nums) {
  List<List<int>> perms = [];
  permute(nums, 0, perms);

  for (var p in perms) {
    final v = p.map((e) => e.toDouble()).toList();
    if (check24(v)) return true;
  }
  return false;
}

void permute(List<int> arr, int i, List<List<int>> out) {
  if (i == arr.length) {
    out.add(List.from(arr));
    return;
  }
  for (int j = i; j < arr.length; j++) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;

    permute(arr, i + 1, out);

    temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}

bool check24(List<double> v) {
  for (var o1 in ops) {
    for (var o2 in ops) {
      for (var o3 in ops) {
        double? r1, r2, r3;

        r1 = apply(v[0], v[1], o1);
        if (r1 != null) {
          r2 = apply(r1, v[2], o2);
          if (r2 != null) {
            r3 = apply(r2, v[3], o3);
            if (r3 != null && (r3 - 24).abs() < eps) return true;
          }
        }

        r1 = apply(v[1], v[2], o2);
        if (r1 != null) {
          r2 = apply(v[0], r1, o1);
          if (r2 != null) {
            r3 = apply(r2, v[3], o3);
            if (r3 != null && (r3 - 24).abs() < eps) return true;
          }
        }

        double? left = apply(v[0], v[1], o1);
        double? right = apply(v[2], v[3], o3);
        if (left != null && right != null) {
          r1 = apply(left, right, o2);
          if (r1 != null && (r1 - 24).abs() < eps) return true;
        }

        r1 = apply(v[1], v[2], o2);
        if (r1 != null) {
          r2 = apply(r1, v[3], o3);
          if (r2 != null) {
            r3 = apply(v[0], r2, o1);
            if (r3 != null && (r3 - 24).abs() < eps) return true;
          }
        }

        r1 = apply(v[2], v[3], o3);
        if (r1 != null) {
          r2 = apply(v[1], r1, o2);
          if (r2 != null) {
            r3 = apply(v[0], r2, o1);
            if (r3 != null && (r3 - 24).abs() < eps) return true;
          }
        }
      }
    }
  }
  return false;
}

List<int> generatePuzzle() {
  while (true) {
    final nums = List.generate(4, (_) => rand.nextInt(9) + 1);
    if (has24Solution(nums)) return nums;
  }
}

List<String> tokenize(String s) {
  List<String> tokens = [];
  String num = '';

  for (int i = 0; i < s.length; i++) {
    final c = s[i];
    if ('0123456789'.contains(c)) {
      num += c;
    } else {
      if (num.isNotEmpty) {
        tokens.add(num);
        num = '';
      }
      if ('+-*/()'.contains(c)) tokens.add(c);
    }
  }
  if (num.isNotEmpty) tokens.add(num);

  return tokens;
}

int prec(String op) {
  if (op == '+' || op == '-') return 1;
  if (op == '*' || op == '/') return 2;
  return 0;
}

bool isOp(String s) => ops.contains(s);

List<String>? infixToRPN(List<String> tokens) {
  List<String> out = [];
  List<String> stack = [];

  for (var t in tokens) {
    if (RegExp(r'^\d+$').hasMatch(t)) {
      out.add(t);
    } else if (isOp(t)) {
      while (stack.isNotEmpty &&
          isOp(stack.last) &&
          prec(stack.last) >= prec(t)) {
        out.add(stack.removeLast());
      }
      stack.add(t);
    } else if (t == '(') {
      stack.add(t);
    } else if (t == ')') {
      while (stack.isNotEmpty && stack.last != '(') {
        out.add(stack.removeLast());
      }
      if (stack.isEmpty) return null;
      stack.removeLast();
    }
  }

  while (stack.isNotEmpty) {
    if (stack.last == '(') return null;
    out.add(stack.removeLast());
  }

  return out;
}

double? evalRPN(List<String> rpn) {
  List<double> stack = [];

  for (var t in rpn) {
    if (RegExp(r'^\d+$').hasMatch(t)) {
      stack.add(double.parse(t));
    } else if (isOp(t)) {
      if (stack.length < 2) return null;
      final b = stack.removeLast();
      final a = stack.removeLast();
      final r = apply(a, b, t);
      if (r == null) return null;
      stack.add(r);
    }
  }

  if (stack.length != 1) return null;
  return stack.first;
}

bool usesAll4Once(String expr, List<int> nums) {
  final found = RegExp(r'\d+')
      .allMatches(expr)
      .map((m) => int.parse(m.group(0)!))
      .toList();

  if (found.length != 4) return false;

  final a = List.from(found)..sort();
  final b = List.from(nums)..sort();

  for (int i = 0; i < 4; i++) {
    if (a[i] != b[i]) return false;
  }

  return true;
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController exprController = TextEditingController();

  int score = 0;
  int highestScore = 0;

  late List<int> nums;

  @override
  void initState() {
    super.initState();
    nums = generatePuzzle();
    loadHighestScore();
  }

  Future<void> loadHighestScore() async {
    highestScore = await ScoreDatabase.instance.getTotalScore();
    setState(() {});
  }

  void addText(String s) {
    exprController.text += s;
    setState(() {});
  }

  void check() async {
    final expr = exprController.text;

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
      showSnack("Error in evaluation.");
      return;
    }

    if ((result - 24).abs() < eps) {
      ScoreDatabase.instance.insertScore(
        Score(player: "Player", score: 1, createdAt: DateTime.now()),
      );

      highestScore = await ScoreDatabase.instance.getTotalScore();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Correct!"),
          content: Text("$expr = 24\n\nHighest Score: $highestScore"),
          actions: [
            TextButton(
              child: const Text("Next Puzzle"),
              onPressed: () {
                Navigator.pop(context);
                newPuzzle();
              },
            ),
          ],
        ),
      );
    } else {
      showSnack("Result = ${result.toStringAsFixed(2)} (not 24)");
    }
  }

  void newPuzzle() {
    nums = generatePuzzle();
    exprController.clear();
    setState(() {});
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberButtons = nums
        .map(
          (n) => FilledButton(
            onPressed: () => addText(n.toString()),
            child: Text(
              n.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        )
        .toList();

    final opButtons = ['+', '-', '*', '/']
        .map(
          (op) => OutlinedButton(
            onPressed: () => addText(op),
            child: Text(op, style: const TextStyle(fontSize: 20)),
          ),
        )
        .toList();

    final parenButtons = ['(', ')']
        .map(
          (op) => OutlinedButton(
            onPressed: () => addText(op),
            child: Text(op, style: const TextStyle(fontSize: 20)),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("24 Game - Play"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Highest Score: $highestScore",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            Text("Numbers: ${nums.join(", ")}",
                style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 14),

            TextField(
              readOnly: true,
              controller: exprController,
              decoration: InputDecoration(
                labelText: "Expression",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: () {
                    if (exprController.text.isNotEmpty) {
                      exprController.text = exprController.text
                          .substring(0, exprController.text.length - 1);
                      setState(() {});
                    }
                  },
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            Wrap(spacing: 8, runSpacing: 8, children: numberButtons),
            const SizedBox(height: 12),

            Wrap(spacing: 8, runSpacing: 8, children: opButtons),
            const SizedBox(height: 8),

            Wrap(spacing: 8, runSpacing: 8, children: parenButtons),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: check,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Check", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
