import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../ui/theme.dart';
import '../models/memo.dart';
import '../providers/knotes_provider.dart';

class AddMemoPage extends ConsumerStatefulWidget {
  const AddMemoPage({super.key});

  @override
  ConsumerState<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends ConsumerState<AddMemoPage> {
  final _urlCtl = TextEditingController();
  final _titleCtl = TextEditingController();
  final _notesCtl = TextEditingController();
  String _selectedCatId = 'cat_general';
  
  void _saveMemo() {
    final memo = Memo(
      id: const Uuid().v4(),
      url: _urlCtl.text,
      title: _titleCtl.text,
      notes: _notesCtl.text,
      categoryId: _selectedCatId,
      createdAt: DateTime.now(),
      tags: ['OpenClaw', 'AI'], // mock tags logic
    );
    ref.read(memoListProvider.notifier).addMemo(memo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快速新增', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(LucideIcons.arrowLeft), onPressed: () => Navigator.pop(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _saveMemo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('儲存'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(LucideIcons.link, '連結'),
            _buildTextField(_urlCtl, 'https://...', icon: LucideIcons.link, suffixIcon: LucideIcons.clipboard),
            const SizedBox(height: 24),
            
            _buildSectionHeader(LucideIcons.type, '標題'),
            _buildTextField(_titleCtl, '自訂標題 (可留空使用 OG 標題)', maxLines: 2),
            const SizedBox(height: 24),
            
            _buildSectionHeader(LucideIcons.edit3, '註解', isOptional: true),
            _buildTextField(_notesCtl, '加入你的想法或備註...', maxLines: 4),
            const SizedBox(height: 24),
            
            _buildSectionHeader(LucideIcons.folder, '分類'),
            Row(
              children: [
                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardNavy,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12)
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.folder, size: 16, color: AppTheme.accentTeal),
                      SizedBox(width: 8),
                      Text('一般 ▼', style: TextStyle(color: AppTheme.accentTeal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.cardNavy,
                    border: Border.all(color: Colors.white24)
                  ),
                  child: const Icon(LucideIcons.plus, size: 16, color: AppTheme.accentTeal),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, {bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.accentTeal),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (isOptional)
             Container(
               margin: const EdgeInsets.only(left: 8),
               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
               decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
               child: const Text('選填', style: TextStyle(fontSize: 10, color: Colors.white54)),
             )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctl, String hint, {IconData? icon, IconData? suffixIcon, int maxLines = 1}) {
    return TextField(
      controller: ctl,
      maxLines: maxLines,
      minLines: maxLines == 1 ? 1 : 2,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: AppTheme.cardNavy,
        prefixIcon: icon != null ? Icon(icon, color: Colors.white38) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppTheme.accentTeal) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        )
      ),
    );
  }
}
