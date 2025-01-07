import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'joblist_user_screen.dart';
import 'requirements_user_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool isSidebarOpen = true;

  // Current Screen
  late Widget currentScreen;
  String headerTitle = 'Home'; // Default title

  List<Map<String, dynamic>> jobs = [];
  bool isLoading = true;

  String selectedDepartment = "All";
  String selectedCampus = "All";
  String selectedAvailability = "All";

  @override
  void initState() {
    super.initState();
    currentScreen = _buildHomeContent(); // Default to "Home" content
    fetchJobs();
  }

  Future<void> fetchJobs() async {
  try {
    final response = await Supabase.instance.client
        .from('jobs')
        .select(
            'job_title, job_description, department, campus, availability, requirements, tags')
        .order('created_at', ascending: false); // Use `ascending: false` for descending order

    if (response != null && response is List) {
      setState(() {
        jobs = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    }
  } catch (error) {
    setState(() {
      isLoading = false;
    });
    print('Error fetching jobs: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching jobs: $error')),
    );
  }
}


  List<Map<String, dynamic>> get filteredJobs {
    return jobs.where((job) {
      final matchesDepartment = selectedDepartment == "All" ||
          job['department'] == selectedDepartment;
      final matchesCampus =
          selectedCampus == "All" || job['campus'] == selectedCampus;
      final matchesAvailability =
          selectedAvailability == "All" || job['availability'] == selectedAvailability;
      return matchesDepartment && matchesCampus && matchesAvailability;
    }).toList();
  }

  void _switchScreen(Widget screen, String title) {
    setState(() {
      currentScreen = screen;
      headerTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 200 : 0,
            child: Container(
              color: Colors.white,
              child: isSidebarOpen
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => isSidebarOpen = false),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.dashboard, size: 20),
                          title: const Text('Home', style: TextStyle(fontSize: 14)),
                          onTap: () {
                            _switchScreen(_buildHomeContent(), 'Home');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.work, size: 20),
                          title: const Text('Job List', style: TextStyle(fontSize: 14)),
                          onTap: () {
                            _switchScreen(const JobListUserScreen(), 'Jobs');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.description, size: 20),
                          title: const Text('Requirements', style: TextStyle(fontSize: 14)),
                          onTap: () {
                            _switchScreen(const RequirementsScreen(), 'Requirements');
                          },
                        ),
                        const Spacer(),
                        const Divider(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 120),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage('assets/image.png'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Sudaiz Alhad',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (!isSidebarOpen)
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () =>
                                  setState(() => isSidebarOpen = true),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            headerTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              // Notification action
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'User',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Main Content
                  Expanded(child: currentScreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Filters
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      items: [
                        "All",
                        "Engineering",
                        "HR",
                        "Finance"
                      ].map((dept) {
                        return DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Department',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCampus,
                      items: [
                        "All",
                        "Main Campus",
                        "City Campus"
                      ].map((campus) {
                        return DropdownMenuItem(
                          value: campus,
                          child: Text(campus),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCampus = value!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Campus',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedAvailability,
                      items: [
                        "All",
                        "Full-Time",
                        "Part-Time"
                      ].map((availability) {
                        return DropdownMenuItem(
                          value: availability,
                          child: Text(availability),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAvailability = value!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Availability',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Job Listings
              Expanded(
                child: filteredJobs.isEmpty
                    ? const Center(
                        child: Text(
                          'No jobs available at the moment.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(job['job_title'] ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Department: ${job['department'] ?? ''}'),
                                  Text('Campus: ${job['campus'] ?? ''}'),
                                  Text(
                                      'Availability: ${job['availability'] ?? ''}'),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Handle "View" functionality
                                },
                                child: const Text('View'),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
  }
}
