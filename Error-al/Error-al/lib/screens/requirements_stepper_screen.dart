import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequirementsStepperScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;

  const RequirementsStepperScreen({
    Key? key,
    required this.jobId,
    required this.jobTitle,
  }) : super(key: key);

  @override
  State<RequirementsStepperScreen> createState() =>
      _RequirementsStepperScreenState();
}

class _RequirementsStepperScreenState
    extends State<RequirementsStepperScreen> {
  bool isLoading = true;
  List<String> requirements = [];
  List<XFile?> uploadedFiles = [];
  int currentStep = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchRequirements();
  }

  Future<void> fetchRequirements() async {
    // Simulated API response for testing
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      requirements = ['Resume', 'Certificate', 'Portfolio'];
      uploadedFiles = List<XFile?>.filled(requirements.length, null);
      isLoading = false;
    });
  }

  Future<void> pickImage(int index) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        setState(() {
          uploadedFiles[index] = file;
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
      appBar: AppBar(title: Text(widget.jobTitle)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requirements.isEmpty
              ? const Center(
                  child: Text(
                    'No requirements found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Stepper(
                  currentStep: currentStep,
                  onStepTapped: (step) {
                    setState(() {
                      currentStep = step;
                    });
                  },
                  onStepContinue: () {
                    if (currentStep < requirements.length - 1) {
                      setState(() {
                        currentStep++;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep--;
                      });
                    }
                  },
                  steps: List.generate(requirements.length, (index) {
                    final isUploaded = uploadedFiles[index] != null;

                    return Step(
                      title: Text(requirements[index]),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upload the required document below.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () => pickImage(index),
                            icon: const Icon(Icons.upload_file),
                            label: Text(
                              isUploaded ? 'Replace File' : 'Upload File',
                            ),
                          ),
                          if (isUploaded)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Uploaded: ${uploadedFiles[index]!.name}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                      isActive: currentStep == index,
                      state: isUploaded
                          ? StepState.complete
                          : StepState.indexed,
                    );
                  }),
                ),
    );
  }
}
