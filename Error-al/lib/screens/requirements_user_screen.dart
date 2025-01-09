import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class RequirementsUserScreen extends StatefulWidget {
  final int jobId;

  const RequirementsUserScreen({Key? key, required this.jobId})
      : super(key: key);

  @override
  State<RequirementsUserScreen> createState() => _RequirementsUserScreenState();
}

class _RequirementsUserScreenState extends State<RequirementsUserScreen> {
  bool isLoading = true;
  List<String> requirements = [];
  List<XFile?> uploadedFiles = [];
  List<bool> stepCompletion = [];
  int currentStage = 0;

  final ImagePicker _picker = ImagePicker();
  final String bucketName = 'uploads';

  @override
  void initState() {
    super.initState();
    fetchRequirements();
    checkBucketExists();
  }

  Future<void> fetchRequirements() async {
    try {
      final response = await Supabase.instance.client
          .from('jobs')
          .select('requirements')
          .eq('id', widget.jobId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Job not found for ID: ${widget.jobId}');
      }

      setState(() {
        requirements = response['requirements'] != null
            ? List<String>.from(response['requirements'])
            : [];
        uploadedFiles = List<XFile?>.filled(requirements.length, null);
        stepCompletion = List<bool>.filled(requirements.length, false);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching requirements: $error')),
      );
    }
  }

  Future<void> checkBucketExists() async {
    try {
      final response = await Supabase.instance.client.storage.listBuckets();
      final bucketExists = response.any((bucket) => bucket.id == bucketName);

      if (!bucketExists) {
        await Supabase.instance.client.storage.createBucket(bucketName);
        print('Bucket "$bucketName" created successfully.');
      } else {
        print('Bucket "$bucketName" exists.');
      }
    } catch (e) {
      print('Error checking or creating bucket: $e');
    }
  }

  Future<void> pickFile(int index) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        setState(() {
          uploadedFiles[index] = file;
        });

        final fileBytes = await file.readAsBytes();
        final filePath = 'requirements/${file.name}';

        await Supabase.instance.client.storage
            .from(bucketName)
            .uploadBinary(filePath, fileBytes);

        setState(() {
          stepCompletion[index] = true; // Mark the step as complete
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${requirements[index]} uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload ${requirements[index]}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Progress'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requirements.isEmpty
              ? const Center(
                  child: Text(
                    'No requirements found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStep(
                            context,
                            icon: Icons.search,
                            label: 'Screening',
                            isActive: currentStage == 0,
                            isComplete: stepCompletion[0],
                            onTap: () {
                              setState(() {
                                currentStage = 0;
                              });
                            },
                          ),
                          _buildDivider(stepCompletion[0]),
                          _buildStep(
                            context,
                            icon: Icons.edit,
                            label: 'Pre-employment Exam',
                            isActive: currentStage == 1,
                            isComplete: stepCompletion[1],
                            onTap: () {
                              setState(() {
                                currentStage = 1;
                              });
                            },
                          ),
                          _buildDivider(stepCompletion[1]),
                          _buildStep(
                            context,
                            icon: Icons.work,
                            label: 'Hiring Stage',
                            isActive: currentStage == 2,
                            isComplete: stepCompletion[2],
                            onTap: () {
                              setState(() {
                                currentStage = 2;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            final currentRequirement = _getRequirementForStage();
                            final isUploaded = uploadedFiles[currentStage] != null;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(currentRequirement),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upload your $currentRequirement below:'),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed: () => pickFile(currentStage),
                                      icon: const Icon(Icons.upload_file),
                                      label: Text(isUploaded
                                          ? 'Replace File'
                                          : 'Upload File'),
                                    ),
                                    if (isUploaded)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Uploaded: ${uploadedFiles[currentStage]!.name}',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStep(BuildContext context,
      {required IconData icon,
      required String label,
      required bool isActive,
      required bool isComplete,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isComplete
                ? Colors.green
                : isActive
                    ? Colors.blue
                    : Colors.grey[300],
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isComplete
                  ? Colors.green
                  : isActive
                      ? Colors.blue
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.green : Colors.grey[300],
      ),
    );
  }

  String _getRequirementForStage() {
    if (currentStage < requirements.length) {
      return requirements[currentStage];
    }
    return 'Requirement';
  }
}
