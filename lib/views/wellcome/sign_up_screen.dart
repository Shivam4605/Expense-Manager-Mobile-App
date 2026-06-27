// import 'dart:developer';

// import 'package:expence_manager/controllers/wellcome/login_controller.dart';
// import 'package:expence_manager/models/login_models/sign_up_model.dart';
// import 'package:expence_manager/widgets/reusable_style_component.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<SignUpScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 43),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 100),

//                 Center(
//                   child: SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: Image.asset("assets/Group 77.png"),
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 ReusableStyleComponent(
//                   context: context,
//                   message: "Create your Account",
//                   color: Colors.black,
//                   fontWeight: FontWeight.w600,
//                   fontsize: 16,
//                 ),

//                 const SizedBox(height: 30),

//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: Offset(0, 4),
//                         color: Color.fromRGBO(0, 0, 0, 0.115),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       hintText: "Name",
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintStyle: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: Offset(0, 4),
//                         color: Color.fromRGBO(0, 0, 0, 0.115),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _userNameController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "Username",
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintStyle: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: Offset(0, 4),
//                         color: Color.fromRGBO(0, 0, 0, 0.115),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintStyle: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: Offset(0, 4),
//                         color: Color.fromRGBO(0, 0, 0, 0.115),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "Confirm Password",
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintStyle: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//                 Material(
//                   child: InkWell(
//                     onTap: () async {
//                       final signUpModel = SignUpModel(
//                         name: _nameController.text.trim(),
//                         userName: _userNameController.text.trim(),
//                         password: _passwordController.text.trim(),
//                       );

//                       log("Request Body: ${signUpModel.toJson()}");

//                       await context.read<LoginController>().signUpUser(
//                         map: signUpModel.toJson(),
//                       );

//                       log("button tap are done");
//                     },
//                     child:
//                         Provider.of<LoginController>(
//                           context,
//                           listen: true,
//                         ).isLoading
//                         ? Center(child: CircularProgressIndicator())
//                         : Container(
//                             height: 49,
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: const Color.fromRGBO(14, 161, 125, 1),
//                             ),
//                             child: ReusableStyleComponent(
//                               context: context,
//                               message: "Sign Up",
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontsize: 16,
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:expence_manager/controllers/wellcome/login_controller.dart';
import 'package:expence_manager/models/login_models/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  // ── Design tokens ──────────────────────────────────────────────────────────
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _bgCard = Color(0xFF1A2634);
  static const Color _textWhite = Color(0xFFF0F4F8);
  static const Color _textMuted = Color(0xFF8A9BB0);
  static const Color _divider = Color(0xFF243040);
  static const Color _danger = Color(0xFFEF4444);

  // ── Controllers ────────────────────────────────────────────────────────────
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController _animCtrl;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _formOffset;
  late Animation<double> _formOpacity;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _formOffset = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.3, 0.75, curve: Curves.easeOut),
      ),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userNameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Validation + submit ────────────────────────────────────────────────────
  Future<void> _handleSignUp() async {
    final name = _nameCtrl.text.trim();
    final userName = _userNameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm = _confirmPasswordCtrl.text.trim();

    // Basic validation
    if (name.isEmpty || userName.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', isError: true);
      return;
    }

    if (password != confirm) {
      _showSnackBar('Passwords do not match', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters', isError: true);
      return;
    }

    final signUpModel = SignUpModel(
      name: name,
      userName: userName,
      password: password,
    );

    log('Request Body: ${signUpModel.toJson()}');

    await context.read<LoginController>().signUpUser(map: signUpModel.toJson());

    log('Sign up done');

    if (!mounted) return;
    _showSnackBar('Account created! Please sign in.', isError: false);
    Navigator.pop(context);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? _danger : _brand,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      // Back button in app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _divider),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textWhite,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ── Logo ───────────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _animCtrl,
                builder: (_, __) => Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: _LogoBadge(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Form ───────────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _animCtrl,
                builder: (_, __) => Opacity(
                  opacity: _formOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _formOffset.value),
                    child: _buildForm(),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        const Text(
          'Create account',
          style: TextStyle(
            color: _textWhite,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Fill in the details below to get started',
          style: TextStyle(
            color: _textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 28),

        // Full name
        _FieldLabel(label: 'Full Name'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _nameCtrl,
          hint: 'e.g. John Doe',
          icon: Icons.badge_outlined,
        ),

        const SizedBox(height: 18),

        // Username
        _FieldLabel(label: 'Username'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _userNameCtrl,
          hint: 'Choose a username',
          icon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: 18),

        // Password
        _FieldLabel(label: 'Password'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _passwordCtrl,
          hint: 'Min. 6 characters',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: _textMuted,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),

        const SizedBox(height: 18),

        // Confirm password
        _FieldLabel(label: 'Confirm Password'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _confirmPasswordCtrl,
          hint: 'Re-enter your password',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: _textMuted,
              size: 20,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),

        const SizedBox(height: 32),

        // Submit button
        Consumer<LoginController>(
          builder: (_, provider, __) => GestureDetector(
            onTap: provider.isLoading ? null : _handleSignUp,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                gradient: provider.isLoading
                    ? const LinearGradient(
                        colors: [Color(0xFF243040), Color(0xFF243040)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: provider.isLoading
                    ? []
                    : const [
                        BoxShadow(
                          color: Color(0x500EA17D),
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
              ),
              child: provider.isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Sign in link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(color: _textMuted, fontSize: 14),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(
                  color: _brand,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Logo badge ─────────────────────────────────────────────────────────────────
class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _SignUpScreenState._brand.withOpacity(0.15),
                width: 1.5,
              ),
            ),
          ),
          Container(
            height: 98,
            width: 98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _SignUpScreenState._brand.withOpacity(0.28),
                width: 1.5,
              ),
            ),
          ),
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _SignUpScreenState._brand.withOpacity(0.40),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Field label ────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _SignUpScreenState._textWhite,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }
}

// ── Dark text field ────────────────────────────────────────────────────────────
class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: _SignUpScreenState._textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _SignUpScreenState._textMuted.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: _SignUpScreenState._textMuted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _SignUpScreenState._bgCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _SignUpScreenState._divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _SignUpScreenState._divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _SignUpScreenState._brand,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
