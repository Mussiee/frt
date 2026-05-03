import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/theme/app_theme.dart';
import '../../../../shared/widgets/focus_text_field.dart';

class NameEntryScreen extends StatefulWidget {
  final String idToken;
  final String phone;

  const NameEntryScreen({
    super.key,
    required this.idToken,
    required this.phone,
  });

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final _firstNameCtl = TextEditingController();
  final _lastNameCtl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _firstNameCtl.dispose();
    _lastNameCtl.dispose();
    super.dispose();
  }

  void _onProceed() {
    final first = _firstNameCtl.text.trim();
    final last = _lastNameCtl.text.trim();
    if (first.isEmpty || last.isEmpty) {
      setState(() => _error = 'Please enter both first and last name');
      return;
    }
    setState(() => _error = null);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Amber glow top-right (matches Figma Background Decoration #F59E0B)
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.18),
                    blurRadius: 200,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),
          // Lighter amber glow bottom-left (matches Figma Overlay+Blur #FFC174)
          Positioned(
            bottom: -80,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC174).withValues(alpha: 0.12),
                    blurRadius: 180,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Back arrow — amber, matching OTP and Phone screens
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.goNamed('phone'),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.amber,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    "What's your\nname?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please Enter your name to continue',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  FocusTextField(
                    label: 'FIRST NAME',
                    hint: 'e.g. Julian',
                    controller: _firstNameCtl,
                    suffixIcon: Icons.badge_outlined,
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                  ),
                  const SizedBox(height: 16),
                  FocusTextField(
                    label: 'LAST NAME',
                    hint: 'e.g. Thorne',
                    controller: _lastNameCtl,
                    suffixIcon: Icons.person_outline,
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Thin amber divider above the button
                  Container(
                    height: 1,
                    color: AppColors.amber.withValues(alpha: 0.20),
                    margin: const EdgeInsets.only(bottom: 24),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PROCEED',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
