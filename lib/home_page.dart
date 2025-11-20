import 'package:flutter/material.dart';
import 'game_page.dart';
import 'challenge_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("24 Game"),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          // MAIN CONTENT
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  /// TITLE
                  Text(
                    "Welcome to 24 Game",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Use all 4 numbers with + - × ÷ to make 24.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  /// ↓↓↓ ลดช่องว่างก่อนถึง GIF
                  const SizedBox(height: 8),

                  /// CAT GIF — ลดช่องว่างบนและล่างให้กระชับที่สุด
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Image.asset(
                      "assets/catdance.gif",
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// ↓↓↓ ลดช่องว่างก่อนถึงปุ่ม
                  const SizedBox(height: 10),

                  /// PLAY CARD
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: colorScheme.primary,
                      ),
                      title: const Text(
                        "Play 24 Game",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: const Text("Start a new puzzle"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GamePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CHALLENGE MODE
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.timer_rounded,
                        size: 32,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        "Challenge Mode",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: const Text("Solve as many as possible in 240s"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChallengePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Good luck and have fun!",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          /// HOW TO PLAY (BOTTOM RIGHT)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: "howto",
              backgroundColor: colorScheme.secondaryContainer,
              child: const Icon(Icons.help_outline_rounded, size: 28),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("How to Play 24"),
                    content: const Text(
                      "- You get 4 numbers.\n"
                      "- Use all 4 numbers exactly once.\n"
                      "- Use +, -, ×, ÷ and parentheses.\n"
                      "- Result must equal 24.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
