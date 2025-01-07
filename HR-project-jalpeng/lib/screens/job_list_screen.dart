import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Map<String, dynamic>> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final response = await Supabase.instance.client
          .from('jobs')
          .select('job_title, job_description, availability, campus')
          .order('created_at', ascending: false);

      if (response != null) {
        setState(() {
          jobs = List<Map<String, dynamic>>.from(response);
        });
      } else {
        throw Exception('No data received from Supabase.');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching jobs: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 16, // Horizontal spacing
              runSpacing: 16, // Vertical spacing
              children: jobs
                  .map((job) => _buildJobCard(
                        job: job,
                        context: context,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required Map<String, dynamic> job,
    required BuildContext context,
  }) {
    return Container(
      width: 250,
      height: 300, // Ensure all cards have the same height
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
                  Icons.work,
                  size: 32,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                job['job_title'] ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                job['job_description'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Availability: ${job['availability'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Campus: ${job['campus'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    _viewJobDetails(context, job);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  void _viewJobDetails(BuildContext context, Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(job['job_title'] ?? 'Job Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['job_description'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                'Availability:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['availability'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                'Campus:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['campus'] ?? ''),
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
