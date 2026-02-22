import 'package:flutter/material.dart';

import '../notifications/notification_helper.dart';

class SetAlarmScreen extends StatefulWidget {
  const SetAlarmScreen({super.key});

  @override
  State<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _labelController = TextEditingController();
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final Set<String> _selectedDays = {};

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      final now = DateTime.now();
      DateTime scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(Duration(days: 1));
      }

      NotificationHelper.scheduleAlarm(scheduled);
    }
  }

  void _saveAlarm() {
    // For now just print values, later you can integrate with alarm logic
    debugPrint("Alarm set for ${_selectedTime.format(context)}");
    debugPrint("Label: ${_labelController.text}");
    debugPrint("Repeat on: $_selectedDays");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alarm saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Alarm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Time picker
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text("Time: ${_selectedTime.format(context)}"),
              trailing: ElevatedButton(
                onPressed: _pickTime,
                child: const Text("Pick Time"),
              ),
            ),

            // Label input
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: "Alarm Label",
                prefixIcon: Icon(Icons.label),
              ),
            ),

            const SizedBox(height: 20),

            // Repeat days
            Wrap(
              spacing: 8,
              children: _days.map((day) {
                final isSelected = _selectedDays.contains(day);
                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            // Save button
            ElevatedButton.icon(
              onPressed: _saveAlarm,
              icon: const Icon(Icons.check),
              label: const Text("Save Alarm"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}