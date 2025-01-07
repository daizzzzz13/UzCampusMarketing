import 'package:flutter/material.dart';

class JobListUserScreen extends StatefulWidget {
  const JobListUserScreen({super.key});

  @override
  State<JobListUserScreen> createState() => _JobListUserScreenState();
}

class _JobListUserScreenState extends State<JobListUserScreen> {
  final List<Map<String, String>> jobs = [
    {
      'jobTitle': 'HR Manager',
      'jobDescription': 'Responsible for managing HR tasks and policies.',
      'availability': 'Full-Time',
      'location': 'San Francisco, CA',
    },
    {
      'jobTitle': 'Assistant Professor',
      'jobDescription': 'Teach undergraduate students and conduct research.',
      'availability': 'Part-Time',
      'location': 'New York, NY',
    },
    {
      'jobTitle': 'Software Developer',
      'jobDescription': 'Develop and maintain web applications.',
      'availability': 'Full-Time',
      'location': 'Seattle, WA',
    },
    {
      'jobTitle': 'Marketing Specialist',
      'jobDescription': 'Plan and execute marketing strategies.',
      'availability': 'Part-Time',
      'location': 'Chicago, IL',
    },
    {
      'jobTitle': 'Data Analyst',
      'jobDescription': 'Analyze complex datasets and provide insights.',
      'availability': 'Full-Time',
      'location': 'Austin, TX',
    },
    {
      'jobTitle': 'Project Manager',
      'jobDescription': 'Oversee and manage multiple projects.',
      'availability': 'Part-Time',
      'location': 'Los Angeles, CA',
    },
    {
      'jobTitle': 'Graphic Designer',
      'jobDescription': 'Create visual concepts for branding.',
      'availability': 'Full-Time',
      'location': 'Miami, FL',
    },
    {
      'jobTitle': 'DevOps Engineer',
      'jobDescription': 'Optimize and automate development processes.',
      'availability': 'Full-Time',
      'location': 'Denver, CO',
    },
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredJobs = jobs.where((job) {
      final jobTitle = job['jobTitle']?.toLowerCase() ?? '';
      final jobDescription = job['jobDescription']?.toLowerCase() ?? '';
      return jobTitle.contains(query.toLowerCase()) ||
          jobDescription.contains(query.toLowerCase());
    }).toList();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 550,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search jobs...',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  return _buildJobCard(job: job, context: context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required Map<String, String> job,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: 250,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  radius: 24,
                  child: const Icon(
                    Icons.work,
                    size: 24,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job['jobTitle'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['jobDescription'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Availability: ${job['availability'] ?? ''}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  'Location: ${job['location'] ?? ''}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _viewJobDetails(context, job);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewJobDetails(BuildContext context, Map<String, String> job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(job['jobTitle'] ?? 'Job Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['jobDescription'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                'Availability:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['availability'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                'Location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job['location'] ?? ''),
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
