import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../network/api_urls.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import '../auth/login_page.dart';
import 'cms_details_page.dart';
import 'faq_page.dart';
import 'edit_profile/change_password_page.dart';
import '../orders/orders_page.dart';
import 'account_settings_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.data;

    // Listen for logout completion
    ref.listen(loginProvider, (previous, next) {
      if (previous?.isLoading == true &&
          !next.isLoading &&
          next.data == null &&
          next.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: profileState.isLoading && user == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : RefreshIndicator(
              onRefresh: () => ref.read(profileProvider.notifier).getProfile(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  Text(
                    'Account',
                    style: appTextStyle(
                      font: 'lexend',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoCard([
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Account Settings',
                        style: appTextStyle(
                          font: 'lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSettingsPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 15),
                  _buildInfoCard([
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Change Password',
                        style: appTextStyle(
                          font: 'lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Text(
                    'Orders',
                    style: appTextStyle(
                      font: 'lexend',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoCard([
                    ListTile(
                      leading: const Icon(
                        Icons.data_array,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Orders',
                        style: appTextStyle(
                          font: 'lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 15),
                  Text(
                    'Settings',
                    style: appTextStyle(
                      font: 'lexend',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInfoCard([
                    ListTile(
                      leading: const Icon(
                        Icons.policy_outlined,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: appTextStyle(font: 'lexend'),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CmsDetailsPage(
                              title: 'Privacy Policy',
                              slug: 'privacy-policy',
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.question_answer_outlined,
                        color: Colors.grey,
                      ),
                      title: Text('Faqs', style: appTextStyle(font: 'lexend')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FaqPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.subscriptions_outlined,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'Subscribe Us',
                        style: appTextStyle(font: 'lexend'),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showSubscribeSheet(),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.contact_support_outlined,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'Contact US',
                        style: appTextStyle(font: 'lexend'),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showContactSheet(),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.gavel_outlined,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'Terms & Conditions',
                        style: appTextStyle(font: 'lexend'),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CmsDetailsPage(
                              title: 'Terms & Conditions',
                              slug: 'terms-and-conditions',
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context, ref),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: appTextStyle(
                          font: 'lexend',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: user?.image != null && user!.image.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: '${ApiEndpoints.baseImageUrl}${user!.image}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.category_outlined,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                    )
                  : Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                  onPressed: () => _pickAndUploadImage(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user?.name ?? 'Loading...',
          style: appTextStyle(
            font: 'lexend',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user?.email ?? '',
          style: appTextStyle(
            font: 'lexend',
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onEdit) {
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(sheetContext, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(sheetContext, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );

    // User dismissed the bottom sheet.
    if (source == null) return;

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      await ref
          .read(profileProvider.notifier)
          .uploadProfilePic(File(pickedFile.path));
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Logout',
          style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: appTextStyle(font: 'lexend'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: appTextStyle(font: 'lexend', color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(loginProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: appTextStyle(font: 'lexend', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscribeSheet() {
    final emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Subscribe to our Newsletter',
              style: appTextStyle(
                font: 'lexend',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay updated with our latest courses and offers.',
              style: appTextStyle(
                font: 'lexend',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty) return;
                  final success = await ref
                      .read(profileProvider.notifier)
                      .subscribeUs(email: emailController.text.trim());
                  if (success && mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Subscribe Now',
                  style: appTextStyle(
                    font: 'lexend',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showContactSheet() {
    final user = ref.read(profileProvider).data;
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Contact Us',
                style: appTextStyle(
                  font: 'lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Have a question? We\'d love to hear from you.',
                style: appTextStyle(
                  font: 'lexend',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.subject),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        subjectController.text.isEmpty ||
                        messageController.text.isEmpty) {
                      return;
                    }
                    final success = await ref
                        .read(profileProvider.notifier)
                        .contactUs(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          subject: subjectController.text.trim(),
                          content: messageController.text.trim(),
                        );
                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Send Message',
                    style: appTextStyle(
                      font: 'lexend',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
