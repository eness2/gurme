import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/features/auth/screen/forget_password/forget_password_form.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  void loseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: loseFocus,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 19,
                ),
                Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                    Align(
                      child: Text(
                        "Şifreni Sıfırla",
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const ForgetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}