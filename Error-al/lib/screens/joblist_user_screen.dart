import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'requirements_user_screen.dart';

class JobListUserScreen extends StatefulWidget {
  const JobListUserScreen({super.key});

  @override
  State<JobListUserScreen> createState() => _JobListUserScreenState();
}

class _JobListUserScreenState extends State<JobListUserScreen> {
  List<Map<String, dynamic>> jobs = [];
  String query = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
    subscribeToJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final response = await Supabase.instance.client
          .from('jobs')
          .select(
              'id, job_title, job_description, department, availability, campus')
          .order('created_at', ascending: false);

      if (response is List) {
        setState(() {
          jobs = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching jobs: $error')),
      );
    }
  }

  void subscribeToJobs() {
    Supabase.instance.client
        .from('jobs')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .listen((event) {
          setState(() {
            jobs = List<Map<String, dynamic>>.from(event);
          });
        });
  }

  Future<void> applyForJob(int jobId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final response =
          await Supabase.instance.client.from('applications').insert({
        'job_id': jobId,
        'user_id': userId,
        'status': 'Pending',
        'applied_at': DateTime.now().toIso8601String(),
      }).select();

      if (response is List && response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
      } else {
        throw Exception('Unexpected response: $response');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying for the job: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = jobs.where((job) {
      final jobTitle = job['job_title']?.toLowerCase() ?? '';
      final jobDescription = job['job_description']?.toLowerCase() ?? '';
      return jobTitle.contains(query.toLowerCase()) ||
          jobDescription.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search jobs...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  return _buildJobCard(job: job, context: context);
                },
              ),
            ),
    );
  }

  Widget _buildJobCard({
    required Map<String, dynamic> job,
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
                  job['job_title'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['job_description'] ?? '',
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
                  'Campus: ${job['campus'] ?? ''}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => applyForJob(job['id']),
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
                        "Apply",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
