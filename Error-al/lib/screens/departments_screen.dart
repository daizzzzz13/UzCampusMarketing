import 'package:flutter/material.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';
  int currentPage = 1;
  final int itemsPerPage = 5;

  final List<Map<String, dynamic>> departments = [
    {
      'id': '1',
      'name': 'Human Resources',
      'head': 'John Doe',
      'status': 'Active'
    },
    {
      'id': '2',
      'name': 'Engineering',
      'head': 'Jane Smith',
      'status': 'Active'
    },
    {
      'id': '3',
      'name': 'Marketing',
      'head': 'Paul Adams',
      'status': 'Inactive'
    },
    {'id': '4', 'name': 'Finance', 'head': 'Emily Watson', 'status': 'Active'},
    {
      'id': '5',
      'name': 'Operations',
      'head': 'Michael Johnson',
      'status': 'Inactive'
    },
    {'id': '6', 'name': 'Sales', 'head': 'Laura Wilson', 'status': 'Active'},
  ];

  List<Map<String, dynamic>> get filteredDepartments {
    List<Map<String, dynamic>> filteredList = departments;

    if (selectedFilter != 'All') {
      filteredList = filteredList
          .where((department) => department['status'] == selectedFilter)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((department) {
        return department['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            department['head']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filteredList;
  }

  List<Map<String, dynamic>> get paginatedDepartments {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredDepartments.sublist(
      startIndex,
      endIndex > filteredDepartments.length
          ? filteredDepartments.length
          : endIndex,
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
        title: const Text('Departments'),
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
                        'Departments',
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
                            items: [
                              'All',
                              'Active',
                              'Inactive',
                            ].map<DropdownMenuItem<String>>((String value) {
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
                                      hintText: 'Search departments...',
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
                        columns: const [
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NAME',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'HEAD',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'STATUS',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'ACTIONS',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        rows: paginatedDepartments.map((department) {
                          return DataRow(
                            cells: [
                              DataCell(Text(department['id'])),
                              DataCell(Text(department['name'])),
                              DataCell(Text(department['head'])),
                              DataCell(Text(department['status'])),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    // Perform action
                                  },
                                  child: const Text('View Details'),
                                ),
                              ),
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
                          'Page $currentPage of ${(filteredDepartments.length / itemsPerPage).ceil()}'),
                      IconButton(
                        onPressed: currentPage <
                                (filteredDepartments.length / itemsPerPage)
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
