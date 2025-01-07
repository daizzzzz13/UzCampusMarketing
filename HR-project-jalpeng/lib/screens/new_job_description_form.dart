import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewJobDescriptionForm extends StatefulWidget {
  const NewJobDescriptionForm({Key? key}) : super(key: key);

  @override
  State<NewJobDescriptionForm> createState() => _NewJobDescriptionFormState();
}

class _NewJobDescriptionFormState extends State<NewJobDescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobPositionController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  String? _department;
  String? _availability;
  String? _campus;

  @override
  void dispose() {
    _jobPositionController.dispose();
    _jobDescriptionController.dispose();
    _sectionController.dispose();
    _requirementsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client.from('jobs').insert({
          'job_title': _jobPositionController.text.trim(),
          'job_description': _jobDescriptionController.text.trim(),
          'department': _department,
          'availability': _availability,
          'section': _sectionController.text.trim(),
          'campus': _campus,
          'requirements': _requirementsController.text.trim(),
          'tags': _tagsController.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
        });

        if (response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job added successfully!')),
          );
          Navigator.pop(context); // Close the dialog
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving job: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500, // Adjust width to make it compact
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Job Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jobPositionController,
                  decoration: const InputDecoration(labelText: 'Job Position'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a job position' : null,
                ),
                TextFormField(
                  controller: _jobDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Department'),
                        items: ['SEICT', 'SAM', 'HR', 'Marketing', 'Finance']
                            .map((dept) => DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _department = value;
                        }),
                        validator: (value) =>
                            value == null ? 'Please select a department' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Availability'),
                        items: ['Full-Time', 'Part-Time', 'Contract']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _availability = value;
                        }),
                        validator: (value) =>
                            value == null ? 'Please select availability' : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sectionController,
                        decoration: const InputDecoration(labelText: 'Section'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a section' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Campus'),
                        items: ['Main Campus', 'City Campus', 'Uz Ipil', 'Uz Pagadian']
                            .map((campus) => DropdownMenuItem(
                                  value: campus,
                                  child: Text(campus),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _campus = value;
                        }),
                        validator: (value) =>
                            value == null ? 'Please select a campus' : null,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _requirementsController,
                  decoration: const InputDecoration(labelText: 'Requirements'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter requirements' : null,
                ),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(labelText: 'Tags'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveJob,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
