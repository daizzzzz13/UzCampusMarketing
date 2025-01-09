import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../modal/profile_modal.dart';
import 'joblist_user_screen.dart';
import 'requirements_user_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  bool isSidebarOpen = true;
  bool isNotificationVisible = false;
  bool isDropdownOpen = false;
  String selectedMenu = 'Home';

  final GlobalKey dropdownKey = GlobalKey();
  final Duration transitionDuration = const Duration(milliseconds: 300);

  String userName = 'User';
  String userEmail = 'user@example.com';
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
          profilePictureUrl = response['profile_picture_url'] ?? '';
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
        SnackBar(content: Text('Error logging out: $error')),
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
          // Sidebar
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
                                leading:
                                    const Icon(Icons.description, size: 20),
                                title: const Text(
                                  'Requirements',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Requirements';
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
                              GestureDetector(
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
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: profilePictureUrl != null &&
                                          profilePictureUrl!.isNotEmpty
                                      ? NetworkImage(profilePictureUrl!)
                                      : const AssetImage(
                                              'assets/profile_placeholder.png')
                                          as ImageProvider,
                                ),
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
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Header
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
                                        : 'Requirements Management',
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
                                      'User',
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
                      // Main Content Area
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: selectedMenu == 'Home'
                              ? _buildHomeContent()
                              : selectedMenu == 'Jobs'
                                  ? const JobListUserScreen()
                                  : RequirementsUserScreen(
                                      jobId: 1, // Replace with appropriate argument
                                    ),
                        ),
                      ),
                    ],
                  ),
                  // Dropdown menu
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
                                title: const Text('Settings'),
                                onTap: () {
                                  setState(() {
                                    isDropdownOpen = false;
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text('Logout'),
                                onTap: _logout,
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

  Widget _buildHomeContent() {
    return const Center(
      child: Text(
        'Welcome to the User Dashboard!',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
