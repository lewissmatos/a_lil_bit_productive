import 'package:a_lil_bit_productive/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../../../domain/models/models.dart';
import '../../providers/reminder/reminder_notifier_provider.dart';

class NewReminderScreen extends ConsumerStatefulWidget {
  const NewReminderScreen({super.key});

  @override
  NewReminderScreenState createState() => NewReminderScreenState();
}

class NewReminderScreenState extends ConsumerState<NewReminderScreen> {
  final Map<String, dynamic> reminderData = {};

  bool isButtonDisabled = true;
  void onOpenDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: reminderData['date'] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;
    setState(() {
      reminderData['date'] = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        reminderData['date']?.hour ?? selectedDate.hour,
        reminderData['date']?.minute ?? selectedDate.minute,
      );
    });
  }

  void onOpenTimePicker() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: reminderData['date']?.hour != null
          ? TimeOfDay(
              hour: reminderData['date']?.hour,
              minute: reminderData['date']?.minute)
          : TimeOfDay.now(),
    );

    if (selectedTime == null) return;
    final now = DateTime.now();
    setState(() {
      reminderData['date'] = DateTime(
        reminderData['date']?.year ?? now.year,
        reminderData['date']?.month ?? now.month,
        reminderData['date']?.day ?? now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  void saveReminder() async {
    final tags = (reminderData['tags'] != null
        ? (reminderData['tags'] as String)
            .split(',')
            .map((String e) => e.trim())
            .where((String e) => e.isNotEmpty)
            .toList()
        : null);

    final reminder = Reminder(
      title: reminderData['title'],
      description: reminderData['description'],
      date: reminderData['date'] ?? DateTime.now(),
      tags: tags,
      color: reminderData['color'] ??
          ColorHelper.getHexFromColor(Theme.of(context).primaryColor),
    );

    final reminderNotifier = ref.read(reminderNotifierProvider.notifier);

    await reminderNotifier.addReminder(reminder: reminder);

    setState(() {
      reminderData.clear();
      isButtonDisabled = true;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('reminder created successfully!'),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          vertical: 14, // Inner padding for SnackBar content.
          horizontal: 10, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      GoRouter.of(context).go('/base/0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('title *'),
          ),
          TextField(
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  isButtonDisabled = true;
                });
                return;
              }
              setState(() {
                reminderData['title'] = value;
                isButtonDisabled = false;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'example: beber romo 3 veces a la semana',
              hintStyle: const TextStyle(fontSize: 14),
              filled: true,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('description'),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                reminderData['description'] = value;
              });
            },
            minLines: 5,
            maxLines: 15,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'enter description',
              hintStyle: const TextStyle(fontSize: 14),
              filled: true,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('tags'),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                reminderData['tags'] = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'exercise, work, etc.',
              hintStyle: const TextStyle(fontSize: 14),
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: onOpenDatePicker,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  DateFormat('yyyy-MM-dd')
                      .format(reminderData['date'] ?? DateTime.now()),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onOpenTimePicker,
                icon: const Icon(Icons.timer_outlined),
                label: Text(
                  DateFormat('HH:mm')
                      .format(reminderData['date'] ?? DateTime.now()),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          MaterialColorPicker(
            alignment: WrapAlignment.end,
            circleSize: 30,
            shrinkWrap: true,
            allowShades: false,
            colors: const [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.orange
            ],
            onMainColorChange: (color) {
              if (color == null) return;
              final selectedColor = ColorHelper.getHexFromColorSwatch(color);
              setState(() {
                reminderData['color'] = selectedColor;
              });
            },
            selectedColor:
                ColorHelper.getColorFromHex(reminderData['color'] ?? ''),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: isButtonDisabled ? null : saveReminder,
            label: const Text('save reminder'),
            icon: const Icon(Icons.save_outlined),
          ),
        ]),
      ),
    );
  }
}
