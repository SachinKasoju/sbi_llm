import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/profile_details_model.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/global_colors.dart';
import '../../../widgets/text_style.dart';

class EditSocialPage extends ConsumerStatefulWidget {
  final ProfileModel user;
  const EditSocialPage({super.key, required this.user});

  @override
  ConsumerState<EditSocialPage> createState() => _EditSocialPageState();
}

class _EditSocialPageState extends ConsumerState<EditSocialPage> {
  late TextEditingController _facebookController;
  late TextEditingController _twitterController;
  late TextEditingController _linkedinController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _facebookController = TextEditingController(text: widget.user.facebook);
    _twitterController = TextEditingController(text: widget.user.twitter);
    _linkedinController = TextEditingController(text: widget.user.linkedin);
    _websiteController = TextEditingController(text: widget.user.website);
  }

  @override
  void dispose() {
    _facebookController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Social Links', style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Facebook', _facebookController, Icons.link),
            const SizedBox(height: 16),
            _buildTextField('Twitter', _twitterController, Icons.link),
            const SizedBox(height: 16),
            _buildTextField('LinkedIn', _linkedinController, Icons.link),
            const SizedBox(height: 16),
            _buildTextField('Website', _websiteController, Icons.web),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileState.isLoading ? null : _saveSocialLinks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: profileState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Links', style: appTextStyle(font: 'lexend', color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: appTextStyle(font: 'lexend', fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'https://...',
          ),
        ),
      ],
    );
  }

  void _saveSocialLinks() async {
    final bool status = await ref.read(profileProvider.notifier).updateSocialLinks(
      facebook: _facebookController.text.trim(),
      twitter: _twitterController.text.trim(),
      linkedin: _linkedinController.text.trim(),
      website: _websiteController.text.trim(),
    );
    if(status){
      Navigator.pop(context);
    }
  }
}
