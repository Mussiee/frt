import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../utils/theme/app_theme.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');
  String? _validationError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(PhoneNumber number) {
    setState(() {
      _phoneNumber = number;
      _validationError = null;
    });
  }

  String? get _e164 {
    final raw = _phoneNumber.phoneNumber ?? '';
    if (raw.trim().length < 8) return null;
    return raw.trim();
  }

  void _onContinue(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final phone = _e164;
    if (phone == null) {
      setState(() => _validationError = 'Please enter a valid phone number');
      return;
    }
    context.read<AuthBloc>().add(PhoneSubmitted(phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) context.pushNamed('otp');
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final canProceed = _e164 != null && !isLoading;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Amber glow top-right (matching Figma Overlay+Blur #F59E0B)
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
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                        blurRadius: 200,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),
              // Green glow bottom-left (matching Figma #4EDEA3)
              Positioned(
                bottom: -80,
                left: -120,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4EDEA3).withValues(alpha: 0.10),
                        blurRadius: 200,
                        spreadRadius: 80,
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
                      // Back button
                      GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.goNamed('splash'),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.amber, size: 22),
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your mobile number to manage\nyour floor operations.',
                        style: TextStyle(
                            color: AppColors.grey, fontSize: 15, height: 1.5),
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        'PHONE NUMBER',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Phone input with amber border
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _validationError != null
                                ? Colors.redAccent
                                : AppColors.amber,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF0D0D0D),
                        ),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: _onPhoneChanged,
                          onInputValidated: (_) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            useBottomSheetSafeArea: true,
                            leadingPadding: 12,
                          ),
                          textFieldController: _phoneController,
                          formatInput: true,
                          keyboardType:
                              const TextInputType.numberWithOptions(signed: true),
                          inputDecoration: const InputDecoration(
                            hintText: '(555) 000-0000',
                            hintStyle:
                                TextStyle(color: AppColors.greyDark, fontSize: 15),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          ),
                          selectorTextStyle:
                              const TextStyle(color: Colors.white, fontSize: 15),
                          textStyle:
                              const TextStyle(color: Colors.white, fontSize: 15),
                          spaceBetweenSelectorAndTextField: 0,
                          initialValue: _phoneNumber,
                        ),
                      ),
                      if (_validationError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(_validationError!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12)),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'By continuing, you agree to receive automated SMS\nmessages for authentication. Standard rates apply.',
                        style:
                            TextStyle(color: AppColors.grey, fontSize: 12, height: 1.5),
                      ),
                      const Spacer(),
                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              canProceed ? () => _onContinue(context) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                canProceed ? AppColors.amber : AppColors.greyDark,
                            foregroundColor: Colors.black,
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.chevron_right, size: 22),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            text: 'Need help? ',
                            style:
                                TextStyle(color: AppColors.grey, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'Contact Support',
                                style: TextStyle(
                                    color: AppColors.amber,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
