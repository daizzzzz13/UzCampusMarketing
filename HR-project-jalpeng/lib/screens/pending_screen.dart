import 'package:flutter/material.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 5;

  final List<Map<String, String>> applications = [
    {
      'id': '1',
      'name': 'John Doe',
      'position': 'Software Engineer',
      'status': 'Pending'
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'position': 'Product Manager',
      'status': 'Pending'
    },
    {
      'id': '3',
      'name': 'Alice Johnson',
      'position': 'Data Analyst',
      'status': 'Pending'
    },
    {
      'id': '4',
      'name': 'Bob Brown',
      'position': 'UX Designer',
      'status': 'Pending'
    },
    {
      'id': '5',
      'name': 'Charlie Wilson',
      'position': 'Project Manager',
      'status': 'Pending'
    },
    {
      'id': '6',
      'name': 'Emily Davis',
      'position': 'HR Manager',
      'status': 'Pending'
    },
    {
      'id': '7',
      'name': 'Michael Scott',
      'position': 'Sales Manager',
      'status': 'Pending'
    },
    {
      'id': '8',
      'name': 'Sarah Connor',
      'position': 'Marketing Specialist',
      'status': 'Pending'
    },
    {
      'id': '9',
      'name': 'Tony Stark',
      'position': 'Mechanical Engineer',
      'status': 'Pending'
    },
    {
      'id': '10',
      'name': 'Bruce Wayne',
      'position': 'Business Analyst',
      'status': 'Pending'
    },
  ];

  List<Map<String, String>> get filteredApplications {
    List<Map<String, String>> filteredList = applications;

    if (searchQuery.isNotEmpty) {
      filteredList = applications.where((application) {
        return application['name']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            application['position']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }).toList();
    }

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    return filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );
  }

  void approveApplication(int index) {
    setState(() {
      applications[index]['status'] = 'Approved';
    });
  }

  void rejectApplication(int index) {
    setState(() {
      applications[index]['status'] = 'Rejected';
    });
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
                // Header Section
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
                              child: Icon(Icons.search,
                                  color: Colors.grey[400], size: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Section
                Container(
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
                                'POSITION',
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
                            return DataRow(
                              cells: [
                                DataCell(Text(application['id']!)),
                                DataCell(Text(application['name']!)),
                                DataCell(Text(application['position']!)),
                                DataCell(
                                  Text(
                                    application['status']!,
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
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: application['status'] ==
                                                'Pending'
                                            ? () => approveApplication(index)
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          minimumSize: const Size(90, 36),
                                        ),
                                        child: const Text('Approve'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed:
                                            application['status'] == 'Pending'
                                                ? () => rejectApplication(index)
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          minimumSize: const Size(90, 36),
                                        ),
                                        child: const Text('Reject'),
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
                ),
                // Pagination Controls
                Padding(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
