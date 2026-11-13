import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/profile_details_model.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/global_colors.dart';
import '../../../widgets/text_style.dart';

class EditAddressPage extends ConsumerStatefulWidget {
  final ProfileModel user;
  const EditAddressPage({super.key, required this.user});

  @override
  ConsumerState<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends ConsumerState<EditAddressPage> {
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _addressController;
  late int _countryId;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.user.city);
    _stateController = TextEditingController(text: widget.user.state);
    _addressController = TextEditingController(text: widget.user.address);
    _countryId = widget.user.countryId == 0 ? 1 : widget.user.countryId;
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Address', style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildTextField('City', _cityController, Icons.location_city),
            const SizedBox(height: 16),
            _buildTextField('State', _stateController, Icons.map_outlined),
            const SizedBox(height: 16),
            _buildTextField('Address', _addressController, Icons.home_outlined, maxLines: 3),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileState.isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: profileState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Address', style: appTextStyle(font: 'lexend', color: Colors.white, fontWeight: FontWeight.bold)),
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

  void _saveAddress() async {
    final bool status = await ref.read(profileProvider.notifier).updateAddress(
      countryId: _countryId,
      stateStr: _stateController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
    );
    if(status){
      Navigator.pop(context);
    }
  }
}
