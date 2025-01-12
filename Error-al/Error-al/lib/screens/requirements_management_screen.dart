import 'package:flutter/material.dart';
import 'requirements_stepper_screen.dart';

class RequirementsManagementScreen extends StatelessWidget {
  const RequirementsManagementScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> jobs = const [
    {'id': 1, 'job_title': 'Software Developer', 'availability': 'Part-Time', 'campus': 'UZ Ipil'},
    {'id': 2, 'job_title': 'HR Manager', 'availability': 'Full-Time', 'campus': 'Main Campus'},
    {'id': 3, 'job_title': 'Data Analyst', 'availability': 'Contract', 'campus': 'City Campus'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requirements Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.work, color: Colors.white),
              ),
              title: Text(job['job_title']),
              subtitle: Text(
                  'Availability: ${job['availability']}\nCampus: ${job['campus']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequirementsStepperScreen(
                        jobId: job['id'],
                        jobTitle: job['job_title'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('View'),
              ),
            ),
          );
        },
      ),
    );
  }
}
