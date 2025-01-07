import 'package:flutter/material.dart';

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'Al-adzrhy');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Jalman');
  final TextEditingController emailController =
      TextEditingController(text: 'al-adzrhy.jalman@one.uz.edu.ph');
  final TextEditingController phoneController =
      TextEditingController(text: '(+62) 821 2554-5846');
  final TextEditingController countryController =
      TextEditingController(text: 'Philippines');
  final TextEditingController cityController =
      TextEditingController(text: 'Zamboanga City');
  final TextEditingController postalCodeController =
      TextEditingController(text: '7000');
  final TextEditingController dateOfBirthController =
      TextEditingController(text: '09-22-2003');

  bool isEditingPersonalInfo = false;
  bool isEditingAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Overview
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 60, // Larger profile picture
                        backgroundImage:
                            AssetImage('assets/profile_picture.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${firstNameController.text} ${lastNameController.text}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Admin',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cityController.text,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Personal Information
              _buildSection(
                title: 'Personal Information',
                isEditing: isEditingPersonalInfo,
                onEditToggle: () {
                  setState(() {
                    isEditingPersonalInfo = !isEditingPersonalInfo;
                  });
                },
                content: Column(
                  children: [
                    _buildEditableRow(
                      'First Name',
                      firstNameController,
                      isEditingPersonalInfo,
                    ),
                    _buildEditableRow(
                      'Last Name',
                      lastNameController,
                      isEditingPersonalInfo,
                    ),
                    _buildEditableRow(
                      'Date of Birth',
                      dateOfBirthController,
                      isEditingPersonalInfo,
                    ),
                    _buildEditableRow(
                      'Email Address',
                      emailController,
                      isEditingPersonalInfo,
                    ),
                    _buildEditableRow(
                      'Phone Number',
                      phoneController,
                      isEditingPersonalInfo,
                    ),
                    _buildStaticRow('User Role', 'Admin'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Address
              _buildSection(
                title: 'Address',
                isEditing: isEditingAddress,
                onEditToggle: () {
                  setState(() {
                    isEditingAddress = !isEditingAddress;
                  });
                },
                content: Column(
                  children: [
                    _buildEditableRow(
                      'Country',
                      countryController,
                      isEditingAddress,
                    ),
                    _buildEditableRow(
                      'City',
                      cityController,
                      isEditingAddress,
                    ),
                    _buildEditableRow(
                      'Postal Code',
                      postalCodeController,
                      isEditingAddress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isEditing,
    required VoidCallback onEditToggle,
    required Widget content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Smaller padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  onPressed: onEditToggle,
                ),
              ],
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(
    String label,
    TextEditingController controller,
    bool isEditable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Smaller padding
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: isEditable
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Smaller padding
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
