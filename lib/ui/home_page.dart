import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../ui/theme.dart';
import 'add_memo_page.dart';
import 'settings_page.dart';
import '../providers/knotes_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(memoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('T-memo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(LucideIcons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildProBanner(),
          ),
          SliverToBoxAdapter(
            child: _buildFiltersAndCategories(),
          ),
          memosAsync.when(
            data: (memos) {
              if (memos.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("目前沒有筆記。點擊右下角新增！", style: TextStyle(color: Colors.grey))),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final memo = memos[index];
                    return _MemoCard(memo: memo);
                  },
                  childCount: memos.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverToBoxAdapter(child: Text('Error \$e')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMemoPage()));
        },
        icon: const Icon(LucideIcons.plus),
        label: const Text('新增', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.proBannerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.sparkles, color: AppTheme.proBannerIcon, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('T-memo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(color: Color(0xFF6B4CA1), borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: const Text('PRO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('解鎖雲端同步、去廣告與\n無限 AI', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersAndCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('全部', isActive: true),
                _buildActionChip(LucideIcons.pin, '釘選'),
                _buildActionChip(null, '未讀', dotColor: AppTheme.accentTeal),
                _buildActionChip(LucideIcons.archive, '已封存'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDropdownBadge('分類 ▼', LucideIcons.folder),
              const SizedBox(width: 12),
              _buildDropdownBadge('# 標籤 ▼', null),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentTeal : AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionChip(IconData? icon, String label, {Color? dotColor}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16, color: Colors.white54), const SizedBox(width: 6)],
          if (dotColor != null) ...[
            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 6)
          ],
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDropdownBadge(String label, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: AppTheme.accentTeal), const SizedBox(width: 6)],
          Text(label, style: const TextStyle(color: AppTheme.accentTeal)),
        ],
      ),
    );
  }
}

class _MemoCard extends StatelessWidget {
  final dynamic memo;
  const _MemoCard({required this.memo});

  @override
  Widget build(BuildContext context) {
    final title = memo.title.isNotEmpty ? memo.title : memo.url.isNotEmpty ? memo.url : memo.notes;
    final timeStr = "\${DateTime.now().difference(memo.createdAt).inHours} 小時前";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.image, color: Colors.white30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 6),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppTheme.accentTeal, shape: BoxShape.circle),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (memo.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: memo.tags.map<Widget>((t) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                        child: Text('#\$t', style: const TextStyle(fontSize: 10, color: AppTheme.accentTeal)),
                      )
                    ).toList(),
                  ),
                const SizedBox(height: 8),
                Text("來源網域 • \$timeStr", style: const TextStyle(fontSize: 12, color: Colors.white38)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
