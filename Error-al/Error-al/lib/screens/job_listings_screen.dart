import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dashboard/screens/new_job_description_form.dart';

class JobListingsContent extends StatefulWidget {
  const JobListingsContent({super.key});

  @override
  State<JobListingsContent> createState() => _JobListingsContentState();
}

class _JobListingsContentState extends State<JobListingsContent> {
  String searchQuery = '';
  List<Map<String, dynamic>> jobs = [];

  // Fetch jobs from Supabase database
  Future<void> fetchJobs() async {
    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('jobs')
          .select('id, job_title, job_description, department, created_at')
          .order('created_at', ascending: false);

      setState(() {
        jobs = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  // Filter jobs based on search query
  List<Map<String, dynamic>> get filteredJobs {
    if (searchQuery.isEmpty) return jobs;
    return jobs.where((job) {
      return (job['job_title'] ?? '')
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchJobs(); // Fetch jobs when the screen initializes
  }

  Future<void> deleteJob(int jobId) async {
    try {
      await Supabase.instance.client.from('jobs').delete().eq('id', jobId);
      setState(() {
        jobs.removeWhere((job) => job['id'] == jobId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job deleted successfully')),
      );
    } catch (error) {
      print('Error deleting job: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 800;

        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Search bar
                    Container(
                      width: isWideScreen ? 400 : 250,
                      height: 45,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              style: const TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Search jobs...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.search,
                                color: Colors.grey[500], size: 24),
                          ),
                        ],
                      ),
                    ),
                    // Add new job button
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const NewJobDescriptionForm(),
                        ).then((_) => fetchJobs());
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Add Job',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Data Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        const Color(0xFF358873),
                      ),
                      dataRowMinHeight: 60,
                      dataRowMaxHeight: 70,
                      horizontalMargin: 16,
                      columnSpacing: isWideScreen ? 40 : 24,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Vacant Positions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Department',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date Posted',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: filteredJobs.map((job) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(job['job_title'] ?? '',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            DataCell(
                              Text(job['department'] ?? '',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            DataCell(
                              Text(job['created_at'] ?? '',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            DataCell(
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'Edit') {
                                    print('Edit ${job['job_title']}');
                                  } else if (value == 'Delete') {
                                    deleteJob(job['id']);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'Edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Delete',
                                    child: ListTile(
                                      leading:
                                          Icon(Icons.delete, color: Colors.red),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
