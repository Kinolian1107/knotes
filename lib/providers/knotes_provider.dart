import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/memo.dart';
import '../models/category.dart';
import '../db/database_helper.dart';

part 'knotes_provider.g.dart';

@riverpod
class MemoList extends _$MemoList {
  @override
  FutureOr<List<Memo>> build() async {
    final memos = await DatabaseHelper.instance.fetchMemos();
    return memos ?? [];
  }

  Future<void> addMemo(Memo memo) async {
    await DatabaseHelper.instance.insertMemo(memo);
    ref.invalidateSelf();
  }

  Future<void> updateMemo(Memo memo) async {
    await DatabaseHelper.instance.updateMemo(memo);
    ref.invalidateSelf();
  }
}

@riverpod
class CategoryList extends _$CategoryList {
  @override
  FutureOr<List<Category>> build() async {
    final cats = await DatabaseHelper.instance.fetchCategories();
    return cats ?? [];
  }

  Future<void> addCategory(Category category) async {
    await DatabaseHelper.instance.insertCategory(category);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(String id) async {
    await DatabaseHelper.instance.deleteCategory(id);
    ref.invalidateSelf();
  }
}
