import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key, required this.onLanguageSelected});

  final Function(String) onLanguageSelected;

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिन्दी'},
    {'code': 'ta', 'label': 'தமிழ்'},
    {'code': 'te', 'label': 'తెలుগు'},
    {'code': 'ml', 'label': 'മലയാളം'},
  ];
  Future<void> _setLanguage(BuildContext context, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', code);
    onLanguageSelected(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: ListView(
        children:
            languages
                .map(
                  (lang) => ListTile(
                    title: Text(lang['label']!),
                    onTap: () => _setLanguage(context, lang['code']!),
                  ),
                )
                .toList(),
      ),
    );
  }
}

