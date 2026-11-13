import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/profile_details_model.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/global_colors.dart';
import '../../../widgets/text_style.dart';

class EditBioPage extends ConsumerStatefulWidget {
  final ProfileModel user;
  const EditBioPage({super.key, required this.user});

  @override
  ConsumerState<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends ConsumerState<EditBioPage> {
  late TextEditingController _jobTitleController;
  late TextEditingController _shortBioController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.user.jobTitle);
    _shortBioController = TextEditingController(text: widget.user.shortBio);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _shortBioController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bio', style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Job Title', _jobTitleController, Icons.work_outline),
            const SizedBox(height: 16),
            _buildTextField('Short Bio', _shortBioController, Icons.description_outlined, maxLines: 2),
            const SizedBox(height: 16),
            _buildTextField('Full Bio', _bioController, Icons.info_outline, maxLines: 5),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileState.isLoading ? null : _saveBio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: profileState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Bio', style: appTextStyle(font: 'lexend', color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: appTextStyle(font: 'lexend', fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, color: AppColors.primaryColor) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _saveBio() async {
    final bool status = await ref.read(profileProvider.notifier).updateBio(
      jobTitle: _jobTitleController.text.trim(),
      shortBio: _shortBioController.text.trim(),
      bio: _bioController.text.trim(),
    );
    if(status){
      Navigator.pop(context);
    }
  }
}
