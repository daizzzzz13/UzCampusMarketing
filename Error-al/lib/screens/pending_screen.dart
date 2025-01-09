import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 5;
  List<Map<String, dynamic>> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('applications')
          .select(
              'id, job_id, user_id, status, applied_at, jobs(job_title, requirements), profiles(given_name, sur_name)')
          .order('applied_at', ascending: false);

      setState(() {
        applications = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching applications: $error')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredApplications {
    List<Map<String, dynamic>> filteredList = applications;

    if (searchQuery.isNotEmpty) {
      filteredList = applications.where((application) {
        final fullName =
            '${application['profiles']['given_name']} ${application['profiles']['sur_name']}';
        final jobTitle = application['jobs']['job_title'] ?? '';
        return fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            jobTitle.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  Future<void> approveApplication(int index) async {
  try {
    final applicationId = applications[index]['id'];
    final jobId = applications[index]['job_id'];

    print('Approving application ID: $applicationId for job ID: $jobId');

    // Update application status to "Approved"
    final response = await Supabase.instance.client
        .from('applications')
        .update({'status': 'Approved'})
        .eq('id', applicationId)
        .select();

    if (response.isNotEmpty) {
      final jobResponse = await Supabase.instance.client
          .from('jobs')
          .select('requirements')
          .eq('id', jobId)
          .maybeSingle();

      if (jobResponse != null && jobResponse['requirements'] != null) {
        print('Requirements fetched: ${jobResponse['requirements']}');
      } else {
        print('No requirements found for job ID: $jobId');
      }
    } else {
      throw Exception('Update failed or no rows were affected');
    }
  } catch (error) {
    print('Error approving application: $error');
  }
}


  Future<void> rejectApplication(int index) async {
    try {
      final applicationId = applications[index]['id'];

      final response = await Supabase.instance.client
          .from('applications')
          .update({'status': 'Rejected'})
          .eq('id', applicationId)
          .select();

      if (response.isNotEmpty) {
        setState(() {
          applications[index]['status'] = 'Rejected';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application rejected successfully')),
        );
      } else {
        throw Exception('Update failed or no rows were affected');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting application: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Applications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
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
                      _buildHeader(),
                      _buildDataTable(),
                      _buildPaginationControls(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
            'Pending Applications',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                      hintText: 'Search applications...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.search, color: Colors.grey[400], size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 1000),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.grey[200],
            ),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFF358873),
              ),
              dataRowHeight: 65,
              horizontalMargin: 24,
              columnSpacing: 24,
              columns: const [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'NAME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'JOB TITLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ACTIONS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              rows: filteredApplications.map((application) {
                int index = applications.indexOf(application);
                final fullName =
                    '${application['profiles']['given_name']} ${application['profiles']['sur_name']}';
                final jobTitle = application['jobs']['job_title'] ?? '';
                return DataRow(
                  cells: [
                    DataCell(Text(application['id'].toString())),
                    DataCell(Text(fullName)),
                    DataCell(Text(jobTitle)),
                    DataCell(
                      Text(
                        application['status'],
                        style: TextStyle(
                          color: application['status'] == 'Pending'
                              ? Colors.orange
                              : application['status'] == 'Approved'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Approve') {
                            approveApplication(index);
                          } else if (value == 'Reject') {
                            rejectApplication(index);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'Approve',
                            child: ListTile(
                              leading: Icon(Icons.check, color: Colors.green),
                              title: Text('Approve'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Reject',
                            child: ListTile(
                              leading: Icon(Icons.close, color: Colors.red),
                              title: Text('Reject'),
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
              'Page $currentPage of ${(applications.length / itemsPerPage).ceil()}'),
          IconButton(
            onPressed: currentPage <
                    (applications.length / itemsPerPage).ceil()
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
