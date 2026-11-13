import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main_shell.dart';
import '../../network/api_urls.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cms_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_form_field.dart';
import '../../widgets/text_style.dart';
import 'register_screen.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;


  @override
  void initState() {
    super.initState();
    _emailController.text = "sachin.ertech@gmail.com";
    _passwordController.text = "Test@123";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Forgot Password',
          style: appTextStyle(
            font: 'lexend',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address and we will send you a link to reset your password.',
                style: appTextStyle(
                  font: 'lexend',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: emailController,
                label: "Email",
                hint: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please enter email";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: appTextStyle(
                font: 'lexend',
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(loginProvider).isLoading;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          await ref.read(loginProvider.notifier).forgotPassword(
                                email: emailController.text.trim(),
                              );
                          if (context.mounted) {
                            final state = ref.read(loginProvider);
                            if (state.error == null) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.data?.message ?? 'Reset link sent to your email.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Submit",
                        style: appTextStyle(
                          font: 'lexend',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Login logic here
      await ref.read(loginProvider.notifier).login(email: _emailController.text.trim(),password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final settingsAsync = ref.watch(settingsProvider);

    // Listen for login state changes to show errors or navigate
    ref.listen(loginProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.data != null && !next.isLoading) {
        // Only navigate if we have a token (Login success)
        // Successful login should have a token in the top level or nested user object
        final token = next.data!.bearerToken ?? next.data!.data?.user?.token;
        if (token != null && token.isNotEmpty) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged in successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MainShell()));
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Sign In",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: settingsAsync.when(
                    data: (settings) {
                      return Image.network(
                        '${ApiEndpoints.baseImageUrl}${settings?.logo}',
                        height: 80,
                        errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(Icons.school, color: Colors.white, size: 40),
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(color: AppColors.primaryColor),
                    error: (error, stack) => const CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.school, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome back 👋',
                  style: appTextStyle(
                    font: 'lexend',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue learning',
                  style: appTextStyle(
                    font: 'lexend',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter email";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Enter password",
                  isObscure: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Please enter password" : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showForgotPasswordDialog(),
                    child: Text(
                      'Forgot Password?',
                      style: appTextStyle(
                        font: 'lexend',
                        fontSize: 13,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loginState.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: loginState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Sign In",
                          style: appTextStyle(
                            font: 'lexend',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: appTextStyle(font: 'lexend', fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Register here",
                        style: appTextStyle(
                          font: 'lexend',
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
