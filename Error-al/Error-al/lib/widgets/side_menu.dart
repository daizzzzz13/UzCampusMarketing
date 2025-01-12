import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  // Changed to StatefulWidget
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isRecruitmentExpanded = false; // Track expansion state

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: true,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Employees'),
            onTap: () {},
          ),
          Theme(
            // Wrap ExpansionTile with Theme to customize its colors
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Remove the divider
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.work),
              title: const Text('Recruitment'),
              trailing: Icon(
                isRecruitmentExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  isRecruitmentExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 50.0),
                  title: const Text('Jobs'),
                  onTap: () {
                    Navigator.pushNamed(context, '/jobs');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 50.0),
                  title: const Text('Forms'),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 50.0),
                  title: const Text('Calendar'),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 50.0),
                  title: const Text('Lists'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/image.png'),
            ),
            title: Text(
              'Al-adzrhy S. Jalman',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              'al-adzrhy.jalman@gmail.com',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
