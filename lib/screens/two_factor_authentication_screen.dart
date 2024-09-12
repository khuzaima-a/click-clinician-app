import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import '../shared/api_calls.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onVerificationSuccess;

  const TwoFactorAuthScreen({
    Key? key,
    required this.userId,
    required this.onVerificationSuccess,
  }) : super(key: key);

  @override
  _TwoFactorAuthScreenState createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendCode();
  }

  void _sendCode() async {
    setState(() {
      _isLoading = true;
      _canResend = false;
    });

    try {
      bool success = await ApiCalls.sendTwoFactorCode(widget.userId);
      if (success) {
        _startResendTimer();
      } else {
        showSnackBar(context, 'Failed to send 2FA code. Please try again.',
            SnackbarColors.error);
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.',
          SnackbarColors.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiCalls.verifyTwoFactorCode(
          widget.userId, _codeController.text);
      if (success) {
        showSnackBar(context, 'Successfully verified!', SnackbarColors.success);
        widget.onVerificationSuccess();
      } else {
        showSnackBar(context, 'Invalid 2FA code. Please try again.',
            SnackbarColors.error);
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.',
          SnackbarColors.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Two-Factor Authentication",
                  style: CustomStyles.headingText),
              DesignWidgets.addVerticalSpace(24),
              Text(
                "Enter the 6-digit code sent to your device",
                style: CustomStyles.paragraphText,
              ),
              DesignWidgets.addVerticalSpace(24),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: "Enter code",
                  filled: true,
                  fillColor: ColorsUI.backgroundColor,
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  hintStyle: CustomStyles.paragraphSubText,
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: ColorsUI.primaryColor, width: 2.0),
                  ),
                ),
              ),
              DesignWidgets.addVerticalSpace(24),
              DesignWidgets.getButton(
                isLoading: _isLoading,
                text: "Verify Code",
                onTap: _verifyCode,
              ),
              DesignWidgets.addVerticalSpace(16),
              Center(
                child: GestureDetector(
                  onTap: _canResend ? _sendCode : null,
                  child: Text(
                    _canResend
                        ? "Resend Code"
                        : "Resend Code in $_resendTimer seconds",
                    style: TextStyle(
                      color: _canResend
                          ? ColorsUI.primaryColor
                          : ColorsUI.lightHeading,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
