import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import 'edit_profile/edit_general_page.dart';
import 'edit_profile/edit_bio_page.dart';
import 'edit_profile/edit_address_page.dart';
import 'edit_profile/edit_social_page.dart';

class AccountSettingsPage extends ConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.data;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: appTextStyle(
            font: 'lexend',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: profileState.isLoading && user == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : RefreshIndicator(
              onRefresh: () => ref.read(profileProvider.notifier).getProfile(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionHeader(context, 'General Information', () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGeneralPage(user: user),
                        ),
                      );
                    }
                  }),
                  _buildInfoCard([
                    _buildInfoTile(
                      Icons.phone_outlined,
                      'Phone',
                      user?.phone ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.cake_outlined,
                      'Age',
                      user?.age.toString() ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.person_outline,
                      'Gender',
                      user?.gender ?? 'Not set',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Professional Bio', () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBioPage(user: user),
                        ),
                      );
                    }
                  }),
                  _buildInfoCard([
                    _buildInfoTile(
                      Icons.work_outline,
                      'Job Title',
                      user?.jobTitle ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.description_outlined,
                      'Short Bio',
                      user?.shortBio ?? 'Not set',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Address', () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAddressPage(user: user),
                        ),
                      );
                    }
                  }),
                  _buildInfoCard([
                    _buildInfoTile(
                      Icons.location_on_outlined,
                      'City/State',
                      '${user?.city ?? ''}, ${user?.state ?? ''}',
                    ),
                    _buildInfoTile(
                      Icons.map_outlined,
                      'Address',
                      user?.address ?? 'Not set',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Social Presence', () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSocialPage(user: user),
                        ),
                      );
                    }
                  }),
                  _buildInfoCard([
                    _buildInfoTile(
                      Icons.link,
                      'Facebook',
                      user?.facebook ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.link,
                      'LinkedIn',
                      user?.linkedin ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.link,
                      'Twitter',
                      user?.twitter ?? 'Not set',
                    ),
                    _buildInfoTile(
                      Icons.link,
                      'Website',
                      user?.website ?? 'Not set',
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: appTextStyle(
              font: 'lexend',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 14),
            label: Text(
              'Edit',
              style: appTextStyle(font: 'lexend', fontSize: 13),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey.shade600),
      title: Text(
        label,
        style: appTextStyle(
          font: 'lexend',
          fontSize: 12,
          color: Colors.grey.shade500,
        ),
      ),
      subtitle: Text(
        value.isEmpty || value == '0' ? 'Not set' : value,
        style: appTextStyle(
          font: 'lexend',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
