import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/memo_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(memoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knotes (No Ads)'),
      ),
      body: memosAsync.when(
        data: (memos) {
          if (memos.isEmpty) {
            return const Center(child: Text('No memos. Add one!'));
          }
          return ListView.builder(
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];
              return ListTile(
                title: Text(memo.content),
                subtitle: Text(memo.metadata), // Shows simulated OG/AI tag
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: \$err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMemoDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addMemoDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Memo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter a URL or text...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(memoListProvider.notifier).addMemo(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
