import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String searchQuery = '';
  String selectedSort = 'Alphabetical A-Z';
  String selectedDepartment = 'Department';
  bool isDepartmentExpanded = false;
  int currentPage = 1;
  final int itemsPerPage = 5;

  List<String> departments = [
    'Department',
    'IT',
    'Accounting',
    'Sales',
    'Marketing',
    'Finance',
    'Design'
  ];

  List<Map<String, dynamic>> employees = [
    {
      'id': '1',
      'name': 'Cole Ashbury',
      'position': 'Software Engineer',
      'department': 'IT',
      'phoneNumber': '(728) 521-2584',
      'email': 'cole.ashbury@example.com'
    },
    {
      'id': '2',
      'name': 'Joshua Baker',
      'position': 'Accountant',
      'department': 'Accounting',
      'phoneNumber': '(404) 153-5520',
      'email': 'joshua.baker@example.com'
    },
    {
      'id': '3',
      'name': 'Dylan Baylidge',
      'position': 'Sales Consultant',
      'department': 'Sales',
      'phoneNumber': '(404) 192-5945',
      'email': 'dylan.baylidge@example.com'
    },
    {
      'id': '4',
      'name': 'Lisa Bradford',
      'position': 'Communication Manager',
      'department': 'Marketing',
      'phoneNumber': '(320) 923-4811',
      'email': 'lisa.bradford@example.com'
    },
    {
      'id': '5',
      'name': 'Paul Brent',
      'position': 'Financial Supervisor',
      'department': 'Finance',
      'phoneNumber': '(404) 875-3439',
      'email': 'paul.brent@example.com'
    },
    {
      'id': '6',
      'name': 'Taylor Christensen',
      'position': 'Product Designer',
      'department': 'Design',
      'phoneNumber': '(404) 650-3953',
      'email': 'taylor.christensen@example.com'
    },
    {
      'id': '7',
      'name': 'Melanie Crawford',
      'position': 'Marketing Coordinator',
      'department': 'Marketing',
      'phoneNumber': '(320) 039-8474',
      'email': 'melanie.crawford@example.com'
    },
    {
      'id': '8',
      'name': 'Ethan Hunter',
      'position': 'Project Manager',
      'department': 'IT',
      'phoneNumber': '(629) 124-2154',
      'email': 'ethan.hunter@example.com'
    },
    {
      'id': '9',
      'name': 'Sophia Hill',
      'position': 'HR Specialist',
      'department': 'Finance',
      'phoneNumber': '(742) 653-8954',
      'email': 'sophia.hill@example.com'
    },
    {
      'id': '10',
      'name': 'Ryan Wood',
      'position': 'UX Designer',
      'department': 'Design',
      'phoneNumber': '(540) 321-4567',
      'email': 'ryan.wood@example.com'
    },
    {
      'id': '11',
      'name': 'Emily Green',
      'position': 'Digital Marketer',
      'department': 'Marketing',
      'phoneNumber': '(628) 475-5698',
      'email': 'emily.green@example.com'
    },
    {
      'id': '12',
      'name': 'Jack Black',
      'position': 'Sales Representative',
      'department': 'Sales',
      'phoneNumber': '(820) 329-4852',
      'email': 'jack.black@example.com'
    },
    {
      'id': '13',
      'name': 'Olivia White',
      'position': 'Content Writer',
      'department': 'Marketing',
      'phoneNumber': '(732) 541-1258',
      'email': 'olivia.white@example.com'
    },
    {
      'id': '14',
      'name': 'James Parker',
      'position': 'Data Analyst',
      'department': 'Finance',
      'phoneNumber': '(504) 852-9632',
      'email': 'james.parker@example.com'
    },
    {
      'id': '15',
      'name': 'Grace Turner',
      'position': 'Front-End Developer',
      'department': 'Design',
      'phoneNumber': '(829) 123-4567',
      'email': 'grace.turner@example.com'
    },
  ];

  List<Map<String, dynamic>> get filteredEmployees {
    List<Map<String, dynamic>> employeesList = employees;

    if (selectedDepartment != 'Department') {
      employeesList = employeesList
          .where((employee) => employee['department'] == selectedDepartment)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      employeesList = employeesList.where((employee) {
        return employee['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            employee['department']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }).toList();
    }

    return employeesList;
  }

  List<Map<String, dynamic>> get paginatedEmployees {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredEmployees.sublist(
        startIndex,
        endIndex > filteredEmployees.length
            ? filteredEmployees.length
            : endIndex);
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
                        'Employees',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Row(
                              children: [
                                const Text(
                                  'Sort by:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: selectedSort,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSort = value!;
                                      currentPage =
                                          1; // Reset to the first page
                                    });
                                  },
                                  items: [
                                    'Alphabetical A-Z',
                                    'Alphabetical Z-A'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
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
                                      hintText: 'Search employees...',
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
                        horizontalMargin: 60,
                        columnSpacing: 20,
                        columns: [
                          DataColumn(
                            label: Container(
                              width: 120,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'ID',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 300,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'NAME',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: PopupMenuButton<String>(
                              onSelected: (value) {
                                setState(() {
                                  selectedDepartment = value;
                                  isDepartmentExpanded = false;
                                  currentPage = 1;
                                });
                              },
                              onCanceled: () {
                                setState(() {
                                  isDepartmentExpanded = false;
                                });
                              },
                              itemBuilder: (context) {
                                return departments.map((dept) {
                                  return PopupMenuItem<String>(
                                    value: dept,
                                    child: Text(dept,
                                        style: TextStyle(
                                            color: selectedDepartment == dept
                                                ? Colors.black
                                                : Colors.grey[700])),
                                  );
                                }).toList();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    selectedDepartment,
                                    style: TextStyle(
                                      color: isDepartmentExpanded
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    isDepartmentExpanded
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              onOpened: () {
                                setState(() {
                                  isDepartmentExpanded = true;
                                });
                              },
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 350,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'POSITION',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 350,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'EMAIL',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        rows: paginatedEmployees.map((employee) {
                          return DataRow(
                            cells: [
                              DataCell(Container(
                                width: 80,
                                alignment: Alignment.centerLeft,
                                child: Text(employee['id']),
                              )),
                              DataCell(Container(
                                width: 250,
                                alignment: Alignment.centerLeft,
                                child: Text(employee['name']),
                              )),
                              DataCell(Container(
                                width: 230,
                                alignment: Alignment.centerLeft,
                                child: Text(employee['department']),
                              )),
                              DataCell(Container(
                                width: 230,
                                alignment: Alignment.centerLeft,
                                child: Text(employee['position']),
                              )),
                              DataCell(Container(
                                width: 230,
                                alignment: Alignment.centerLeft,
                                child: Text(employee['email']),
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
                          'Page $currentPage of ${(filteredEmployees.length / itemsPerPage).ceil()}'),
                      IconButton(
                        onPressed: currentPage <
                                (filteredEmployees.length / itemsPerPage).ceil()
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
