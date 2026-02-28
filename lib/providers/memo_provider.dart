import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/memo.dart';
import '../db/database_helper.dart';
import 'package:uuid/uuid.dart';

part 'memo_provider.g.dart';

@riverpod
class MemoList extends _$MemoList {
  @override
  FutureOr<List<Memo>> build() async {
    final memos = await DatabaseHelper.instance.fetchMemos();
    return memos ?? [];
  }

  Future<void> addMemo(String content) async {
    // create memo
    final id = const Uuid().v4();
    final memo = Memo(
      id: id,
      content: content,
      metadata: "Generated Tag (No Ads)",
      createdAt: DateTime.now(),
    );
    
    // Save to DB
    await DatabaseHelper.instance.insertMemo(memo);
    
    // Invalidate state to refresh UI as defined by user CLAUDE.md
    ref.invalidateSelf();
  }
}
