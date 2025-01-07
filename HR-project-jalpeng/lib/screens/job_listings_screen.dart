import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dashboard/screens/new_job_description_form.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
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

  void showActionsMenu(BuildContext context, Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context); // Close the menu
                // Implement edit logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the menu
                deleteJob(job['id']);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to AdminHomeScreen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1600),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Job Listings',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 500,
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
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
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 0,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Icon(Icons.search,
                                      color: Colors.grey[400], size: 24),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 45,
                            width: 160,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Show the New Job Description form as a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const NewJobDescriptionForm(),
                                ).then((_) => fetchJobs()); // Refresh jobs list
                              },
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text(
                                'Add New Job',
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF358873),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Data Table
                Container(
                  margin: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.grey[200],
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          const Color(0xFF358873),
                        ),
                        dataRowHeight: 50,
                        horizontalMargin: 50,
                        columnSpacing: 280,
                        columns: [
                          const DataColumn(
                            label: Text(
                              'Vacant Positions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Department',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Date Posted',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                        rows: filteredJobs.map((job) {
                          return DataRow(
                            cells: [
                              DataCell(Text(job['job_title'] ?? '')),
                              DataCell(Text(job['department'] ?? '')),
                              DataCell(Text(job['created_at'] ?? '')),
                              DataCell(
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      // Edit logic here
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
                                        leading: Icon(Icons.delete, color: Colors.red),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
