import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/profile_details_model.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/global_colors.dart';
import '../../../widgets/text_style.dart';

class EditGeneralPage extends ConsumerStatefulWidget {
  final ProfileModel user;
  const EditGeneralPage({super.key, required this.user});

  @override
  ConsumerState<EditGeneralPage> createState() => _EditGeneralPageState();
}

class _EditGeneralPageState extends ConsumerState<EditGeneralPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _ageController = TextEditingController(text: widget.user.age.toString());
    _selectedGender = widget.user.gender.isEmpty ? 'male' : widget.user.gender.toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit General Info', style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Phone', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField('Age', _ageController, Icons.cake_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Text('Gender', style: appTextStyle(font: 'lexend', fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildGenderRadio('Male'),
                _buildGenderRadio('Female'),
                _buildGenderRadio('Other'),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileState.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: profileState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Changes', style: appTextStyle(font: 'lexend', color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: appTextStyle(font: 'lexend', fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRadio(String gender) {
    return Row(
      children: [
        Radio<String>(
          value: gender.toLowerCase(),
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
          activeColor: AppColors.primaryColor,
        ),
        Text(gender, style: appTextStyle(font: 'lexend')),
      ],
    );
  }

  void _saveProfile() async {
    final bool status = await ref.read(profileProvider.notifier).updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _selectedGender,
    );
    if(status){
      Navigator.pop(context);
    }
  }
}
