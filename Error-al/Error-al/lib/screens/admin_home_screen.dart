import 'package:flutter/material.dart';
import 'home_section.dart';
import 'job_listings_screen.dart';
import 'forms_screen.dart';
import 'job_list_screen.dart';
import '../modal/profile_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  bool isSidebarOpen = true;
  bool isNotificationVisible = false;
  bool isDropdownOpen = false;
  String selectedMenu = 'Home';

  final GlobalKey dropdownKey = GlobalKey();
  final Duration transitionDuration = const Duration(milliseconds: 300);

  String userName = 'Admin User';
  String userEmail = 'admin@example.com';
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('given_name, sur_name, email, profile_picture_url')
          .eq('id', userId)
          .single();

      if (response != null) {
        setState(() {
          userName = '${response['given_name']} ${response['sur_name']}';
          userEmail = response['email'] ?? 'No email';
          profilePictureUrl = response['profile_picture_url'] ??
              'assets/profile_placeholder.png';
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $error')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $error')),
      );
    }
  }

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 250 : 0,
            child: Container(
              color: Colors.white,
              child: isSidebarOpen
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 24),
                            onPressed: () {
                              setState(() => isSidebarOpen = false);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.dashboard, size: 20),
                                title: const Text(
                                  'Home',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Home';
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.work, size: 20),
                                title: const Text(
                                  'Jobs',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Jobs';
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.list, size: 20),
                                title: const Text(
                                  'List',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'List';
                                  });
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.description, size: 20),
                                title: const Text(
                                  'Forms',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Forms';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 120),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: profilePictureUrl != null
                                    ? NetworkImage(profilePictureUrl!)
                                    : const AssetImage(
                                            'assets/profile_placeholder.png')
                                        as ImageProvider,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (!isSidebarOpen)
                                IconButton(
                                  icon: const Icon(Icons.menu, size: 24),
                                  onPressed: () {
                                    setState(() => isSidebarOpen = true);
                                  },
                                ),
                              const SizedBox(width: 8),
                              Text(
                                selectedMenu == 'Home'
                                    ? 'Dashboard'
                                    : selectedMenu == 'Jobs'
                                        ? 'Jobs Listings'
                                        : selectedMenu == 'List'
                                            ? 'Job List'
                                            : 'Forms Management',
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
                                  setState(() {
                                    isNotificationVisible =
                                        !isNotificationVisible;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                key: dropdownKey,
                                onTap: _toggleDropdown,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Admin',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      isDropdownOpen
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_right,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: selectedMenu == 'Home'
                              ? const HomeSection()
                              : selectedMenu == 'Jobs'
                                  ? const JobListingsContent()
                                  : selectedMenu == 'List'
                                      ? const JobListScreen()
                                      : const FormsScreen(),
                        ),
                      ),
                    ],
                  ),
                  if (isDropdownOpen)
                    Positioned(
                      top: 60,
                      right: 20,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: const Text('Profile'),
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProfileModal(
                                        onProfileUpdated: _fetchProfile,
                                      );
                                    },
                                  );
                                  _fetchProfile();
                                  setState(() {
                                    isDropdownOpen = false;
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text('Logout'),
                                onTap: () async {
                                  setState(() {
                                    isDropdownOpen = false;
                                  });
                                  await _logout();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
