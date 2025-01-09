import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key, required this.onProfileUpdated});

  final VoidCallback onProfileUpdated;

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isEditingPersonalInfo = false;
  bool isEditingDepartmentRole = false;
  bool isEditingNote = false;

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
          .select()
          .eq('id', userId)
          .single();

      if (response != null) {
        setState(() {
          firstNameController.text = response['given_name'] ?? '';
          lastNameController.text = response['sur_name'] ?? '';
          dobController.text = response['date_of_birth'] ?? '';
          emailController.text = response['email'] ?? '';
          phoneController.text = response['phone'] ?? '';
          departmentController.text = response['department'] ?? '';
          roleController.text = response['role'] ?? '';
          noteController.text = response['note'] ?? '';
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $error')),
      );
    }
  }

  Future<void> _updateProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final Map<String, dynamic> updates = {
        'given_name': firstNameController.text.trim(),
        'sur_name': lastNameController.text.trim(),
        'date_of_birth': dobController.text.trim().isEmpty
            ? null
            : dobController.text.trim(), // Send null if empty
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'department': departmentController.text.trim(),
        'role': roleController.text.trim(),
        'note': noteController.text.trim(),
      };

      await Supabase.instance.client
          .from('profiles')
          .update(updates)
          .eq('id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      widget.onProfileUpdated();

      setState(() {
        isEditingPersonalInfo = false;
        isEditingDepartmentRole = false;
        isEditingNote = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/profile_placeholder.png'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${firstNameController.text} ${lastNameController.text}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'Personal Information',
                        isEditing: isEditingPersonalInfo,
                        onEditToggle: () {
                          if (isEditingPersonalInfo) {
                            _updateProfile();
                          }
                          setState(() {
                            isEditingPersonalInfo = !isEditingPersonalInfo;
                          });
                        },
                        content: Column(
                          children: [
                            _buildEditableRow('First Name', firstNameController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Last Name', lastNameController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Date of Birth', dobController,
                                isEditingPersonalInfo,
                                isDate: true),
                            _buildEditableRow('Email Address', emailController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Phone Number', phoneController,
                                isEditingPersonalInfo),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Department and Role',
                        isEditing: isEditingDepartmentRole,
                        onEditToggle: () {
                          if (isEditingDepartmentRole) {
                            _updateProfile();
                          }
                          setState(() {
                            isEditingDepartmentRole = !isEditingDepartmentRole;
                          });
                        },
                        content: Column(
                          children: [
                            _buildEditableRow('Department',
                                departmentController, isEditingDepartmentRole),
                            _buildEditableRow('Role', roleController,
                                isEditingDepartmentRole),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
    bool isEditable, {
    bool isDate = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                ? isDate
                    ? GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            controller.text =
                                pickedDate.toIso8601String().split('T')[0];
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: 'YYYY-MM-DD',
                            ),
                          ),
                        ),
                      )
                    : TextField(
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
}
