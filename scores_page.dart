
import 'package:flutter/material.dart';
import 'db.dart';

class ScoresPage extends StatelessWidget {
  const ScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High Scores"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Clear all scores?"),
                  content: const Text(
                    "This will delete all saved scores. Are you sure?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Clear"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ScoreDatabase.instance.clearScores();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Scores cleared.")),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Score>>(
        future: ScoreDatabase.instance.getAllScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final scores = snapshot.data!;
          if (scores.isEmpty) {
            return const Center(
              child: Text("No scores yet. Play a game and save your first one!"),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: scores.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final s = scores[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(s.player),
                  subtitle: Text(
                    "Score: ${s.score}  •  "
                    "${s.createdAt.toLocal().toString().substring(0, 16)}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
