import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taqsi/shared/colors.dart';
import 'package:taqsi/theme/theme_not.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController reportController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  /// 📝 حفظ تقرير في Firestore
  Future<void> saveReport() async {
    if (reportController.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection("REPORTS").add({
      "type": "report",
      "text": reportController.text.trim(),
      "timestamp": DateTime.now(),
    });
    reportController.clear();
    Navigator.pop(context);
  }

  /// 📝 حفظ ملاحظة (Feedback) في Firestore
  Future<void> saveFeedback() async {
    if (feedbackController.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection("FEEDBACKS").add({
      "type": "feedback",
      "text": feedbackController.text.trim(),
      "timestamp": DateTime.now(),
    });
    feedbackController.clear();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    // 🎨 ضبط شكل الـ StatusBar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundcolor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: "font2", fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          /// 🌙 الوضع الليلي
          _buildSettingTile(
            context,
            title: "Dark Mode",
            trailing: CupertinoSwitch(
              activeColor: Colors.blueAccent,
              value: themeNotifier.isDark,
              onChanged: (value) => themeNotifier.toggleTheme(),
            ),
          ),

          /// 🚨 إرسال تقرير
          _buildSettingTile(
            context,
            title: "Report",
            icon: Icons.report_gmailerrorred,
            onTap: () => _openBottomSheet(
              context,
              title: "Write your report",
              controller: reportController,
              onSend: saveReport,
            ),
          ),

          /// 💬 إرسال ملاحظات
          _buildSettingTile(
            context,
            title: "Feedback",
            icon: Icons.feedback_outlined,
            onTap: () => _openBottomSheet(
              context,
              title: "Write your feedback",
              controller: feedbackController,
              onSend: saveFeedback,
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 Widget Tile للإعدادات
  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    IconData? icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontFamily: "font1", fontSize: 18)),
            trailing ??
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).iconTheme.color,
                ),
          ],
        ),
      ),
    );
  }

  /// 📌 BottomSheet لإرسال نص (Report / Feedback)
  void _openBottomSheet(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required VoidCallback onSend,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: "font1", fontSize: 16)),
              const SizedBox(height: 10),

              /// 🖊️ حقل الكتابة
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintStyle: const TextStyle(fontFamily: "font2", fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ الأزرار
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancel", style: TextStyle(fontFamily: "font1")),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onSend,
                    child: const Text("Send", style: TextStyle(fontFamily: "font1")),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
