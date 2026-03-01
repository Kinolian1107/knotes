import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../ui/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('一般'),
          ListTile(
            leading: const Icon(LucideIcons.clipboard),
            title: const Text('剪貼簿自動貼上'),
            subtitle: const Text('新增筆記時自動帶入剪貼簿連結'),
            trailing: Switch(value: true, activeColor: AppTheme.accentTeal, onChanged: (v){}),
          ),
          const Divider(color: Colors.white10),
          _buildSectionHeader('外觀'),
          ListTile(
            leading: const Icon(LucideIcons.palette),
            title: const Text('主題'),
            subtitle: const Text('跟隨系統'),
            trailing: const Icon(LucideIcons.chevronRight, color: Colors.white30),
          ),
          ListTile(
            leading: const Icon(LucideIcons.globe),
            title: const Text('語言'),
            subtitle: const Text('系統預設'),
            trailing: const Icon(LucideIcons.chevronRight, color: Colors.white30),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildProBanner(),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('帳號與同步'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.chrome, color: AppTheme.accentTeal),
              label: const Text('Google 登入', style: TextStyle(color: AppTheme.accentTeal)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentTeal),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: const TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.proBannerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.sparkles, color: AppTheme.proBannerIcon, size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('T-memo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text('PRO', style: TextStyle(fontSize: 10, color: AppTheme.proBannerIcon)),
                  ],
                ),
                SizedBox(height: 4),
                Text('解鎖雲端同步、去廣告與\n無限 AI', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: Colors.white54),
        ],
      ),
    );
  }
}
