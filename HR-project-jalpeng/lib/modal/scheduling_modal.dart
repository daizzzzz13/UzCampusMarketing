import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulingModal extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const SchedulingModal({super.key, required this.onSave});

  @override
  _SchedulingModalState createState() => _SchedulingModalState();
}

class _SchedulingModalState extends State<SchedulingModal> {
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController customTimeController = TextEditingController();

  final List<String> availableTimes = [
    '9:00 AM',
    '12:00 PM',
    '3:00 PM',
    '6:00 PM',
    '9:00 PM',
  ];

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Schedule the interview date.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Applicant Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: positionController,
                    decoration: const InputDecoration(
                      labelText: 'Applied Position',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select a date for the interview:'),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            selectedDate != null
                                ? DateFormat('MMMM d, yyyy')
                                    .format(selectedDate!)
                                : 'Select Date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Schedule at:'),
                      Column(
                        children: availableTimes.map((time) {
                          return RadioListTile<String>(
                            title: Text(time),
                            value: time,
                            groupValue: selectedTime,
                            onChanged: (value) {
                              setState(() {
                                selectedTime = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: customTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Custom Time (e.g., 10:15 AM)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedDate != null &&
                (selectedTime != null ||
                    customTimeController.text.isNotEmpty) &&
                nameController.text.isNotEmpty &&
                positionController.text.isNotEmpty) {
              final newSchedule = {
                'date': DateFormat('MM/dd/yy').format(selectedDate!),
                'time': customTimeController.text.isNotEmpty
                    ? customTimeController.text
                    : selectedTime!,
                'applicantName': nameController.text,
                'position': positionController.text,
              };
              widget.onSave(newSchedule);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please fill in all fields and select date and time.'),
                ),
              );
            }
          },
          child: const Text('Schedule'),
        ),
      ],
    );
  }
}
