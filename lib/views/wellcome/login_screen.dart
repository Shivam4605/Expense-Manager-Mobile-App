// import 'dart:developer';

// import 'package:expence_manager/controllers/wellcome/login_controller.dart';
// import 'package:expence_manager/controllers/wellcome/user_controller.dart';
// import 'package:expence_manager/models/login_models/login_model.dart';
// import 'package:expence_manager/views/transaction/transaction_screen.dart';
// import 'package:expence_manager/widgets/reusable_style_component.dart';
// import 'package:expence_manager/views/wellcome/sign_up_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 43),
//         child: SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
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
//                   message: "Login to your Account",
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
//                     controller: _userNameController,
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

//                 GestureDetector(
//                   onTap: () async {
//                     final loginModel = LoginModel(
//                       userName: _userNameController.text.trim(),
//                       password: _passwordController.text.trim(),
//                     );

//                     UserController userController = UserController();

//                     await Provider.of<LoginController>(
//                       context,
//                       listen: false,
//                     ).loginUser(map: loginModel.toJson());

//                     await userController.getuserData();

//                     log("button tap are done");
//                     log(
//                       "${Provider.of<LoginController>(context, listen: false).isSuccessFlag}",
//                     );
//                     log("shared preferences ${userController.name}");
//                     log("shared preferences ${userController.userName}");
//                     log("shared preferences ${userController.isLoggedIn}");

//                     log("Before Navigation");

//                     log("Context mounted = ${context.mounted}");
//                     if (userController.isLoggedIn) {
//                       if (!context.mounted) return;

//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const TransactionScreen(),
//                         ),
//                         (route) => false,
//                       );
//                     }
//                   },
//                   child: Consumer<LoginController>(
//                     builder: (context, provider, child) {
//                       return provider.isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : Container(
//                               height: 49,
//                               width: double.infinity,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: const Color.fromRGBO(14, 161, 125, 1),
//                               ),
//                               child: const Text("Sign In"),
//                             );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ReusableStyleComponent(
//                         context: context,
//                         message: "Don't have an account?",
//                         color: const Color.fromRGBO(0, 0, 0, 1),
//                         fontWeight: FontWeight.w500,
//                         fontsize: 14,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SignUpScreen(),
//                             ),
//                           );
//                         },
//                         child: ReusableStyleComponent(
//                           context: context,
//                           message: "Sign up",
//                           color: const Color.fromRGBO(14, 161, 125, 1),
//                           fontWeight: FontWeight.w500,
//                           fontsize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
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
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/models/login_models/login_model.dart';
import 'package:expence_manager/views/transaction/transaction_screen.dart';
import 'package:expence_manager/views/wellcome/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);

  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _bgCard = Color(0xFF1A2634);
  static const Color _textWhite = Color(0xFFF0F4F8);
  static const Color _textMuted = Color(0xFF8A9BB0);
  static const Color _divider = Color(0xFF243040);

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _userNameCtrl = TextEditingController();
  bool _obscurePassword = true;

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
    _passwordCtrl.dispose();
    _userNameCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final loginModel = LoginModel(
      userName: _userNameCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    final userController = UserController();

    await Provider.of<LoginController>(
      context,
      listen: false,
    ).loginUser(map: loginModel.toJson());

    await userController.getuserData();

    log('Login attempt done');
    log('isLoggedIn: ${userController.isLoggedIn}');

    if (userController.isLoggedIn) {
      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const TransactionScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
        (route) => false,
      );
    } else {
      if (!context.mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFEF4444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'Invalid username or password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _LogoSection(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

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

                  const Spacer(),

                  AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _formOpacity.value,
                      child: _buildSignUpRow(),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
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
          'Welcome back',
          style: TextStyle(
            color: _textWhite,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to continue tracking your expenses',
          style: TextStyle(
            color: _textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 32),

        _FieldLabel(label: 'Username'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _userNameCtrl,
          hint: 'Enter your username',
          icon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: 20),

        _FieldLabel(label: 'Password'),
        const SizedBox(height: 8),
        _DarkTextField(
          controller: _passwordCtrl,
          hint: 'Enter your password',
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

        const SizedBox(height: 32),

        Consumer<LoginController>(
          builder: (_, provider, __) => GestureDetector(
            onTap: provider.isLoading ? null : _handleLogin,
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
                        'Sign In',
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
      ],
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: _textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => SignUpScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: _brand,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _LoginScreenState._brand.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
            ),
            Container(
              height: 108,
              width: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _LoginScreenState._brand.withOpacity(0.28),
                  width: 1.5,
                ),
              ),
            ),
            Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _LoginScreenState._brand.withOpacity(0.40),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _LoginScreenState._textWhite,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }
}

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
        color: _LoginScreenState._textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _LoginScreenState._textMuted.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: _LoginScreenState._textMuted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _LoginScreenState._bgCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _LoginScreenState._divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _LoginScreenState._divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _LoginScreenState._brand,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
