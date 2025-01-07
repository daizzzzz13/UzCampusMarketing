import 'package:flutter/material.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({super.key});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';
  int currentPage = 1;
  final int itemsPerPage = 5;

  final List<Map<String, dynamic>> applicants = [
    {'id': '1', 'name': 'Alberto Cruz', 'stage': 1},
    {'id': '2', 'name': 'Sudaiz Alhad', 'stage': 2},
    {'id': '3', 'name': 'Glenn Andales', 'stage': 3},
    {'id': '4', 'name': 'Yasher Abam', 'stage': 1},
    {'id': '5', 'name': 'Mary-Angelie Mongcupa', 'stage': 3},
    {'id': '6', 'name': 'David Clark', 'stage': 2},
    {'id': '7', 'name': 'Sophia Martinez', 'stage': 3},
  ];

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
        return applicant['name']
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
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

  List<String> get progressiveFilters {
    return ['All', 'Screening', 'Pre-employment Exam', 'Hiring Stage'];
  }

  void showStageModal(BuildContext context, String name, int stage) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200, minHeight: 800),
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
                    buildStep(context, 'Screening', Icons.search, stage >= 1,
                        () => debugPrint('Screening clicked')),
                    buildLine(),
                    buildStep(
                      context,
                      'Pre-employment Exam',
                      Icons.edit,
                      stage >= 2,
                      () => debugPrint('Pre-employment Exam clicked'),
                    ),
                    buildLine(),
                    buildStep(
                      context,
                      'Hiring Stage',
                      Icons.work,
                      stage >= 3,
                      () => debugPrint('Hiring Stage clicked'),
                    ),
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

  void resetIds() {
    for (int i = 0; i < applicants.length; i++) {
      applicants[i]['id'] = (i + 1).toString();
    }
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
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
                            items: progressiveFilters
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 400,
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
                                        currentPage = 1;
                                      });
                                    },
                                    style: const TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'Search applicants...',
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
                        ],
                      ),
                    ],
                  ),
                ),
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
                        headingRowColor:
                            WidgetStateProperty.all(const Color(0xFF358873)),
                        dataRowHeight: 65,
                        horizontalMargin: 30,
                        columnSpacing: 20,
                        columns: [
                          DataColumn(
                            label: Container(
                              width: 80,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'ID',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 250,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'NAME',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 230,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'STAGE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 150,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'ACTIONS',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        rows: paginatedApplicants.map((applicant) {
                          return DataRow(
                            cells: [
                              DataCell(Container(
                                width: 100,
                                alignment: Alignment.centerLeft,
                                child: Text(applicant['id']),
                              )),
                              DataCell(Container(
                                width: 180,
                                alignment: Alignment.centerLeft,
                                child: Text(applicant['name']),
                              )),
                              DataCell(Container(
                                width: 150,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: List.generate(
                                    3,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: index < applicant['stage']
                                            ? Colors.green
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              DataCell(PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'View') {
                                    showStageModal(context, applicant['name'],
                                        applicant['stage']);
                                  } else if (value == 'Proceed' &&
                                      applicant['stage'] == 3) {
                                    setState(() {
                                      applicants.removeWhere((item) =>
                                          item['id'] == applicant['id']);
                                      resetIds();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Completed!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'View',
                                    child: ListTile(
                                      leading: Icon(Icons.remove_red_eye),
                                      title: Text('View'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Proceed',
                                    enabled: applicant['stage'] == 3,
                                    child: const ListTile(
                                      leading: Icon(Icons.check),
                                      title: Text('Proceed'),
                                    ),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  color: Colors.white,
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
                          'Page $currentPage of ${(filteredApplicants.length / itemsPerPage).ceil()}'),
                      IconButton(
                        onPressed: currentPage <
                                (filteredApplicants.length / itemsPerPage)
                                    .ceil()
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
