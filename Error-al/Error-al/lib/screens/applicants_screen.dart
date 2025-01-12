import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({Key? key}) : super(key: key);

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';
  int currentPage = 1;
  final int itemsPerPage = 5;
  bool isLoading = true;

  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    fetchApprovedApplicants();
  }

  Future<void> fetchApprovedApplicants() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('applications')
          .select(
              'id, profiles(given_name, sur_name), stage, resume_uploaded, exam_completed, hiring_stage_completed')
          .eq('status', 'Approved')
          .order('id', ascending: true);

      setState(() {
        applicants = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching applicants: $error')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredApplicants {
    List<Map<String, dynamic>> filteredList = applicants;

    if (selectedFilter != 'All') {
      filteredList = filteredList.where((applicant) {
        switch (selectedFilter) {
          case 'Screening':
            return applicant['stage'] == 1;
          case 'Pre-employment Exam':
            return applicant['stage'] == 2;
          case 'Hiring Stage':
            return applicant['stage'] == 3;
          default:
            return true;
        }
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((applicant) {
        final fullName =
            '${applicant['profiles']['given_name']} ${applicant['profiles']['sur_name']}';
        return fullName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filteredList;
  }

  List<Map<String, dynamic>> get paginatedApplicants {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredApplicants.sublist(
        startIndex,
        endIndex > filteredApplicants.length
            ? filteredApplicants.length
            : endIndex);
  }

  Widget buildStageIndicator(Map<String, dynamic> applicant) {
    return Row(
      children: [
        buildCircle(applicant['resume_uploaded']),
        const SizedBox(width: 8),
        buildCircle(applicant['exam_completed']),
        const SizedBox(width: 8),
        buildCircle(applicant['hiring_stage_completed']),
      ],
    );
  }

  Widget buildCircle(bool isCompleted) {
    return Icon(
      Icons.circle,
      size: 12,
      color: isCompleted ? Colors.green : Colors.grey[300],
    );
  }

  void showStageModal(BuildContext context, String name, Map<String, dynamic> applicant) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800, minHeight: 300),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$name Progress',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Applicant Progress',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildStep(
                        context,
                        'Screening',
                        Icons.search,
                        applicant['resume_uploaded'],
                        () => debugPrint('Screening clicked')),
                    buildLine(),
                    buildStep(
                        context,
                        'Pre-employment Exam',
                        Icons.edit,
                        applicant['exam_completed'],
                        () => debugPrint('Pre-employment Exam clicked')),
                    buildLine(),
                    buildStep(
                        context,
                        'Hiring Stage',
                        Icons.work,
                        applicant['hiring_stage_completed'],
                        () => debugPrint('Hiring Stage clicked')),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildStep(
    BuildContext context,
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isActive ? Colors.green : Colors.grey[300],
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Applicants'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(36),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Applicants',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                DropdownButton<String>(
                                  value: selectedFilter,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilter = value!;
                                      currentPage = 1;
                                    });
                                  },
                                  items: ['All', 'Screening', 'Pre-employment Exam', 'Hiring Stage']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 400,
                                  height: 45,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                        currentPage = 1;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search applicants...',
                                      border: OutlineInputBorder(
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(const Color(0xFF358873)),
                          columnSpacing: 302,
                          dataRowHeight: 65,
                          columns: const [
                            DataColumn(label: Text('ID', style: TextStyle(color: Colors.white))),
                            DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                            DataColumn(label: Text('Stage', style: TextStyle(color: Colors.white))),
                            DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white))),
                          ],
                          rows: paginatedApplicants.map((applicant) {
                            final fullName =
                                '${applicant['profiles']['given_name']} ${applicant['profiles']['sur_name']}';
                            return DataRow(cells: [
                              DataCell(Text(applicant['id'].toString())),
                              DataCell(Text(fullName)),
                              DataCell(buildStageIndicator(applicant)),
                              DataCell(IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.grey),
                                onPressed: () {
                                  showStageModal(
                                    context,
                                    fullName,
                                    applicant,
                                  );
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: currentPage > 1
                                ? () {
                                    setState(() {
                                      currentPage--;
                                    });
                                  }
                                : null,
                          ),
                          Text('Page $currentPage of ${(filteredApplicants.length / itemsPerPage).ceil()}'),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: currentPage <
                                    (filteredApplicants.length / itemsPerPage).ceil()
                                ? () {
                                    setState(() {
                                      currentPage++;
                                    });
                                  }
                                : null,
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
