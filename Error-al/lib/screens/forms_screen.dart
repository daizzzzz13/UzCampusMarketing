import 'package:flutter/material.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final List<Map<String, String>> forms = [
    {
      'formTitle': 'Curriculum Vitae',
      'formDescription': 'Highlight your skills and work experience.',
    },
    {
      'formTitle': 'Comprehensive CV',
      'formDescription': 'Detailed CV for academic and research positions.',
    },
    {
      'formTitle': 'Personal Data Sheet',
      'formDescription':
          'Government-format personal information and employment record.',
    },
    {
      'formTitle': 'Training Certificate',
      'formDescription':
          'Official documentation for completed training programs.',
    },
    {
      'formTitle': 'Performance Evaluation',
      'formDescription': 'Assessment for employee performance and feedback.',
    },
    {
      'formTitle': 'Leave Application',
      'formDescription': 'Request and document employee leave of absence.',
    },
    {
      'formTitle': 'Work Assignment Form',
      'formDescription': 'Details of assigned work tasks and responsibilities.',
    },
    {
      'formTitle': 'Expense Reimbursement Form',
      'formDescription': 'Submit for reimbursement of job-related expenses.',
    },
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredForms = forms.where((form) {
      final formTitle = form['formTitle']?.toLowerCase() ?? '';
      final formDescription = form['formDescription']?.toLowerCase() ?? '';
      return formTitle.contains(query.toLowerCase()) ||
          formDescription.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 350,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search forms...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 16, // Horizontal spacing between cards
                    runSpacing: 16, // Vertical spacing between cards
                    children: filteredForms
                        .map((form) => _buildFormCard(
                              form: form,
                              context: context,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({
    required Map<String, String> form,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 300, // Consistent width with other card layouts
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                radius: 32,
                child: const Icon(
                  Icons.description,
                  size: 32,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                form['formTitle'] ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                form['formDescription'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    _viewFormDetails(context, form);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "View",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewFormDetails(BuildContext context, Map<String, String> form) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(form['formTitle'] ?? 'Form Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(form['formDescription'] ?? ''),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
