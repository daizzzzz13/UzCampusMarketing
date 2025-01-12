import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modal/scheduling_modal.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String searchQuery = '';
  String selectedTimeFilter = 'All';
  int currentPage = 1; // Pagination
  final int itemsPerPage = 10; // Adjusted to 10 items per page

  List<Map<String, dynamic>> interviews = [
    {
      'time': '9:00 AM',
      'applicantName': 'Alice Johnson',
      'position': 'Software Engineer',
      'date': '01/15/23'
    },
    {
      'time': '10:30 AM',
      'applicantName': 'Bob Smith',
      'position': 'Product Manager',
      'date': '02/20/23'
    },
    {
      'time': '11:00 AM',
      'applicantName': 'Charlie Brown',
      'position': 'Data Analyst',
      'date': '03/12/23'
    },
    {
      'time': '2:00 PM',
      'applicantName': 'Diana Prince',
      'position': 'UX Designer',
      'date': '04/05/23'
    },
    {
      'time': '3:30 PM',
      'applicantName': 'Ethan Hunt',
      'position': 'Marketing Specialist',
      'date': '05/22/23'
    },
    {
      'time': '9:30 AM',
      'applicantName': 'Fiona Gallagher',
      'position': 'HR Manager',
      'date': '06/15/23'
    },
    {
      'time': '10:00 AM',
      'applicantName': 'George Lucas',
      'position': 'Operations Lead',
      'date': '07/10/23'
    },
    {
      'time': '1:30 PM',
      'applicantName': 'Helen Parr',
      'position': 'Finance Officer',
      'date': '08/25/23'
    },
    {
      'time': '3:00 PM',
      'applicantName': 'Isaac Newton',
      'position': 'Research Scientist',
      'date': '09/18/23'
    },
    {
      'time': '4:30 PM',
      'applicantName': 'Jack Sparrow',
      'position': 'Logistics Coordinator',
      'date': '10/12/23'
    },
    {
      'time': '9:15 AM',
      'applicantName': 'Bruce Wayne',
      'position': 'CEO',
      'date': '01/10/23'
    },
    {
      'time': '11:45 AM',
      'applicantName': 'Clark Kent',
      'position': 'Journalist',
      'date': '01/12/23'
    },
    {
      'time': '3:15 PM',
      'applicantName': 'Diana Prince',
      'position': 'Editor',
      'date': '02/01/23'
    },
    {
      'time': '12:15 PM',
      'applicantName': 'Peter Parker',
      'position': 'Photographer',
      'date': '03/10/23'
    },
    {
      'time': '1:00 PM',
      'applicantName': 'Tony Stark',
      'position': 'Engineer',
      'date': '04/05/23'
    },
    {
      'time': '10:45 AM',
      'applicantName': 'Clark Banner',
      'position': 'Architect',
      'date': '11/12/23'
    },
    {
      'time': '2:30 PM',
      'applicantName': 'Natasha Romanoff',
      'position': 'Spy',
      'date': '12/20/23'
    },
    {
      'time': '4:15 PM',
      'applicantName': 'Steve Rogers',
      'position': 'Pilot',
      'date': '01/02/24'
    },
    {
      'time': '11:30 AM',
      'applicantName': 'Wanda Maximoff',
      'position': 'Mystic',
      'date': '02/14/24'
    },
    {
      'time': '3:45 PM',
      'applicantName': 'Vision',
      'position': 'AI Specialist',
      'date': '03/25/24'
    },
  ];

  List<Map<String, dynamic>> get filteredInterviews {
    List<Map<String, dynamic>> filtered = interviews;

    // Apply time filter
    if (selectedTimeFilter != 'All') {
      filtered = filtered.where((interview) {
        return selectedTimeFilter == 'AM'
            ? interview['time'].toString().contains('AM')
            : interview['time'].toString().contains('PM');
      }).toList();
    }

    // Apply search query filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((interview) {
        final date = interview['date'];
        final formattedDate = DateFormat('MM/dd/yy').parse(date);
        final monthName = DateFormat.MMMM().format(formattedDate).toLowerCase();
        return interview['applicantName']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            interview['position']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            date.contains(searchQuery) ||
            monthName.contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Sort by time in ascending order
    filtered.sort((a, b) {
      return _convertTo24HourTime(a['time'])
          .compareTo(_convertTo24HourTime(b['time']));
    });

    return filtered;
  }

  List<Map<String, dynamic>> get paginatedInterviews {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (filteredInterviews.isEmpty) {
      return [];
    }

    return filteredInterviews.sublist(
      startIndex,
      endIndex > filteredInterviews.length
          ? filteredInterviews.length
          : endIndex,
    );
  }

  int _convertTo24HourTime(String time) {
    final timeParts = time.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hours = int.parse(hourMinute[0]);
    final int minutes = int.parse(hourMinute[1]);

    if (timeParts[1] == 'PM' && hours != 12) {
      hours += 12;
    } else if (timeParts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    return hours * 100 + minutes;
  }

  void _openAddScheduleModal() {
    showDialog(
      context: context,
      builder: (context) => SchedulingModal(
        onSave: (newSchedule) {
          setState(() {
            interviews.add(newSchedule);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Management'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200, minHeight: 800),
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
                        'Interviews',
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
                                        currentPage = 1; // Reset to page 1
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search schedules...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 0,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _openAddScheduleModal,
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add New Schedule',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF358873),
                              minimumSize: const Size(160, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            const Color(0xFF358873),
                          ),
                          columnSpacing: 180,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 150,
                                child: PopupMenuButton<String>(
                                  initialValue: selectedTimeFilter,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedTimeFilter = value;
                                      currentPage = 1;
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'All',
                                      child: Text('All'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'AM',
                                      child: Text('AM'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'PM',
                                      child: Text('PM'),
                                    ),
                                  ],
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const DataColumn(
                              label: Text(
                                'Applicant Name',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const DataColumn(
                              label: Text(
                                'Applied Position',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const DataColumn(
                              label: Text(
                                'Scheduled Date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: paginatedInterviews.map((interview) {
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  return states.contains(MaterialState.selected)
                                      ? Colors.grey[300]
                                      : Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Text(interview['time'])),
                                DataCell(Text(interview['applicantName'])),
                                DataCell(Text(interview['position'])),
                                DataCell(Text(interview['date'])),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
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
                              'Page $currentPage of ${(filteredInterviews.length / itemsPerPage).ceil()}'),
                          IconButton(
                            onPressed: currentPage <
                                    (filteredInterviews.length / itemsPerPage)
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
