import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/theme/app_theme.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _ctls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 45;
  Timer? _timer;
  String? _devCode;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthBloc>().state;
      if (state is OtpSent && state.devCode != null) {
        setState(() => _devCode = state.devCode);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSeconds <= 0) {
        _timer?.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  String get _enteredCode => _ctls.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onVerify(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final code = _enteredCode;
    if (code.length < 6) return;
    context.read<AuthBloc>().add(OtpSubmitted(code: code));
  }

  void _onResend(BuildContext context) {
    if (_resendSeconds > 0) return;
    context.read<AuthBloc>().add(const ResendOtpRequested());
    _startTimer();
  }

  String _maskedPhone(String phone) {
    if (phone.length < 6) return phone;
    final last2 = phone.substring(phone.length - 2);
    return '${phone.substring(0, 3)} ••• ••$last2';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent && state.devCode != null) {
          setState(() => _devCode = state.devCode);
        }
        if (state is OtpVerified) {
          context.goNamed('name', extra: {
            'idToken': state.idToken,
            'phone': state.phone,
          });
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.redAccent,
          ));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final phone = state is OtpSent
            ? state.phone
            : (state is OtpVerified ? state.phone : '');

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Back arrow — amber, left aligned
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () =>
                          context.canPop() ? context.pop() : context.goNamed('phone'),
                      child: const Icon(Icons.arrow_back,
                          color: AppColors.amber, size: 22),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'Check your phone',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "We've sent a 6-digit verification code to ",
                      style: const TextStyle(
                          color: AppColors.grey, fontSize: 14, height: 1.5),
                      children: [
                        TextSpan(
                          text: phone.isNotEmpty ? _maskedPhone(phone) : '',
                          style: const TextStyle(
                              color: AppColors.amber,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  if (_devCode != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🔧 Dev code: $_devCode',
                          style: const TextStyle(
                              color: AppColors.amber, fontSize: 13),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  // ── 6-box OTP input ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 5 ? 10 : 0),
                          child: _OtpBox(
                            controller: _ctls[i],
                            focusNode: _nodes[i],
                            onChanged: (v) => _onDigitChanged(i, v),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_enteredCode.length == 6 && !isLoading)
                          ? () => _onVerify(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: AppColors.greyDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'VERIFY CODE',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: 1.5),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Resend section
                  const Text(
                    "DIDN'T RECEIVE A CODE?",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 11,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _onResend(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: _resendSeconds > 0
                              ? AppColors.grey
                              : AppColors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _resendSeconds > 0
                              ? 'Resend Code (${_resendSeconds}s)'
                              : 'Resend Code',
                          style: TextStyle(
                            color: _resendSeconds > 0
                                ? AppColors.grey
                                : AppColors.amber,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // ── Security badge ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1C2D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield,
                              color: AppColors.amber, size: 20),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SECURE VERIFICATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Focus Operations uses encrypted SMS gateways for venue security.',
                                style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 54,
      decoration: BoxDecoration(
        // Matches Figma #122131 for OTP box background
        color: const Color(0xFF122131),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasValue ? AppColors.amber : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          // Amber for filled digits, grey dot for empty
          color: hasValue ? AppColors.amber : AppColors.greyDark,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}
