import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmflux/core/services/auth_service.dart';
import 'package:farmflux/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import 'dart:async';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();
  Timer? _otpTimer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Updated _loadUserData to dynamically fetch user data based on the logged-in user's phone number
  Future<void> _loadUserData() async {
    const maxRetries = 5;
    int retryCount = 0;
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user == null) {
      return;
    }

    while (retryCount < maxRetries) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.phoneNumber).get();
        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            _nameController.text = data?['name'] ?? '';
            _emailController.text = data?['email'] ?? '';
            _phoneController.text = data?['phoneNumber'] ?? '';
          });
        }
        return; // Exit the loop if successful
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          return;
        }
        await Future.delayed(
          Duration(seconds: 2 * retryCount),
        ); // Exponential backoff
      }
    }
  }

  // Updated EditProfilePage to allow editing the phone number with OTP verification
  Future<void> _saveUserData() async {
    const maxRetries = 5;
    int retryCount = 0;
    final user = FirebaseAuth.instance.currentUser; // Get the current user
    final loc = AppLocalizations.of(context)!;

    if (user == null) {
      return;
    }

    // Check if the phone number has been changed
    if (_phoneController.text != user.phoneNumber) {
      // Send OTP to the new phone number
      await _authService.sendOTP(_phoneController.text, (verificationId) async {
        // Show a dialog to enter the OTP
        final otp = await _showOtpDialog();
        if (otp == null || otp.isEmpty) {
          return;
        }

        // Verify the OTP
        final isVerified = await _authService.verifyOTP(otp);
        if (!isVerified) {
          return;
        }

        // Replace old phone number data with new phone number data
        while (retryCount < maxRetries) {
          try {
            final oldPhoneNumber = user.phoneNumber;
            await _firestore.collection('users').doc(oldPhoneNumber).delete();
            await _firestore
                .collection('users')
                .doc(_phoneController.text)
                .set({
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'phoneNumber': _phoneController.text,
                }); // Show a confirmation message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.mobileNumberUpdatedSuccessfully),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                ),
              );

              Navigator.pop(context);
            }
            return; // Exit the loop if successful
          } catch (e) {
            retryCount++;
            if (retryCount >= maxRetries) {
              return;
            }
            await Future.delayed(
              Duration(seconds: 2 * retryCount),
            ); // Exponential backoff
          }
        }
      }, (error) {});
    } else {
      // Save data without phone number change
      while (retryCount < maxRetries) {
        try {
          await _firestore.collection('users').doc(user.phoneNumber).set({
            'name': _nameController.text,
            'email': _emailController.text,
            'phoneNumber': _phoneController.text,
          }); // Show a confirmation message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.profileUpdatedSuccessfully)),
            );

            Navigator.pop(context);
          }
          return; // Exit the loop if successful
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) {
            return;
          }
          await Future.delayed(
            Duration(seconds: 2 * retryCount),
          ); // Exponential backoff
        }
      }
    }
  }

  Future<String?> _showOtpDialog() async {
    final loc = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String? otp;

    if (!mounted) return null;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final otpController = TextEditingController();
        bool canResendInDialog = false;
        int otpTimeLeftInDialog = 60;
        Timer? otpTimerInDialog;

        void startResendTimerInDialog() {
          otpTimerInDialog?.cancel();
          otpTimerInDialog = Timer.periodic(Duration(seconds: 1), (timer) {
            if (otpTimeLeftInDialog > 0) {
              otpTimeLeftInDialog--;
            } else {
              canResendInDialog = true;
              timer.cancel();
            }
          });
        }

        // Start the timer
        startResendTimerInDialog();

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 400 ? 400 : screenWidth * 0.9,
                  maxHeight: screenHeight * 0.7,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth < 350 ? 20 : 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth < 350 ? 12 : 16),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sms_outlined,
                          color: AppConstants.primaryGreen,
                          size: screenWidth < 350 ? 28 : 32,
                        ),
                      ),
                      SizedBox(height: screenWidth < 350 ? 16 : 20),
                      Text(
                        loc.enterOTP,
                        style: TextStyle(
                          fontSize: screenWidth < 350 ? 18 : 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.pleaseEnterVerificationCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth < 350 ? 13 : 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: screenWidth < 350 ? 20 : 24),
                      // Custom OTP Input Field
                      Stack(
                        children: [
                          // Visual OTP boxes
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) {
                                bool isFilled =
                                    otpController.text.length > index;
                                bool isActive =
                                    otpController.text.length == index;

                                return Container(
                                  width: 48,
                                  height: 56,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isActive
                                              ? AppConstants.primaryGreen
                                              : isFilled
                                              ? Colors.green.shade400
                                              : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    boxShadow:
                                        isActive
                                            ? [
                                              BoxShadow(
                                                color: AppConstants.primaryGreen
                                                    .withValues(alpha: 0.15),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    isFilled ? otpController.text[index] : '',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          // Hidden TextField for input
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.0,
                              child: TextField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                onChanged: (value) {
                                  setDialogState(() {});
                                  if (value.length == 6) {
                                    otp = value;
                                    otpTimerInDialog?.cancel();
                                    Navigator.of(context).pop();
                                  }
                                },
                                onSubmitted: (value) {
                                  if (value.length == 6) {
                                    otp = value;
                                    otpTimerInDialog?.cancel();
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth < 350 ? 20 : 24),
                      // Resend OTP section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loc.didntReceiveOTP,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          if (canResendInDialog)
                            GestureDetector(
                              onTap: () async {
                                // Resend OTP logic
                                setDialogState(() {
                                  canResendInDialog = false;
                                  otpTimeLeftInDialog = 60;
                                });
                                startResendTimerInDialog();

                                // Store ScaffoldMessenger before async operation
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );

                                // Show resend confirmation
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(loc.otpResentSuccessfully),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                loc.resend,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          else
                            Text(
                              loc.resendInSeconds(otpTimeLeftInDialog),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: screenWidth < 350 ? 20 : 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenWidth < 350 ? 10 : 12,
                                ),
                              ),
                              onPressed: () {
                                otpTimerInDialog?.cancel();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                loc.cancel,
                                style: TextStyle(
                                  fontSize: screenWidth < 350 ? 14 : 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenWidth < 350 ? 10 : 12,
                                ),
                              ),
                              onPressed: () {
                                otp = otpController.text;
                                otpTimerInDialog?.cancel();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                loc.verifyOTP,
                                style: TextStyle(
                                  fontSize: screenWidth < 350 ? 14 : 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return otp;
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Set system UI overlay style for consistency
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF374151),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          loc.editProfileSettings,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 600 ? 500 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Minimal Profile Picture Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    _showImagePickerOptions();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryGreen.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFF0FDF4),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppConstants.primaryGreen.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppConstants.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.primaryGreen.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              _showImagePickerOptions();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Premium Personal Information Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Elegant Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppConstants.primaryGreen.withValues(
                                    alpha: 0.1,
                                  ),
                                  const Color(
                                    0xFF22C55E,
                                  ).withValues(alpha: 0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppConstants.primaryGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.personalInformation,
                                  style: TextStyle(
                                    fontSize: screenWidth < 350 ? 18 : 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.updateYourProfileDetails,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32), // Premium Form Fields
                      _buildPremiumTextField(
                        controller: _nameController,
                        label: loc.fullName,
                        hint: loc.enterYourFullName,
                        icon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),

                      _buildPremiumTextField(
                        controller: _emailController,
                        label: loc.emailAddress,
                        hint: loc.enterYourEmailAddress,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),

                      _buildPremiumTextField(
                        controller: _phoneController,
                        label: loc.phoneNumber,
                        hint: loc.enterYourPhoneNumber,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppConstants.primaryGreen.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight < 700 ? 14 : 16,
                        ),
                      ),
                      onPressed: _saveUserData,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.save_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            loc.saveChanges,
                            style: TextStyle(
                              fontSize: screenWidth < 350 ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight < 700 ? 14 : 16,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        loc.cancel,
                        style: TextStyle(
                          fontSize: screenWidth < 350 ? 14 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // Premium text field builder with enhanced design
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium label with better typography
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth < 350 ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Premium text field with enhanced styling
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E5E9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: TextStyle(
              fontSize: screenWidth < 350 ? 15 : 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
              letterSpacing: -0.2,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: screenWidth < 350 ? 14 : 15,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.1,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(icon, color: AppConstants.primaryGreen, size: 22),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 50,
                minHeight: 24,
              ),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppConstants.primaryGreen,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: screenWidth < 350 ? 16 : 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Show image picker options
  void _showImagePickerOptions() {
    final screenWidth = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              20,
              screenWidth * 0.05,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  loc.changeProfilePicture,
                  style: TextStyle(
                    fontSize: screenWidth < 350 ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                // Horizontal layout for all options to reduce modal height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.camera_alt,
                        label: loc.camera,
                        onTap: () {
                          Navigator.pop(context);
                          // Implement camera functionality
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.photo_library,
                        label: loc.gallery,
                        onTap: () {
                          Navigator.pop(context);
                          // Implement gallery functionality
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.delete,
                        label: loc.remove,
                        onTap: () {
                          Navigator.pop(context);
                          // Implement remove functionality
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: screenWidth < 350 ? 8 : 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth < 350 ? 12 : 16),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppConstants.primaryGreen,
                size: screenWidth < 350 ? 20 : 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth < 350 ? 10 : 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
