import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

/// Onboarding screen for user profile setup
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedCity;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  Future<void> _submitOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.submitOnboarding(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      city: _selectedCity!,
    );

    if (success && mounted) {
      // Navigate to home - HomeScreen will check premium and show gate if needed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (authProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error!,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < AppConstants.minAge || age > AppConstants.maxAge) {
      return 'Age must be between ${AppConstants.minAge} and ${AppConstants.maxAge}';
    }

    return null;
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Your City', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: AppConstants.cities.length,
                  itemBuilder: (context, index) {
                    final city = AppConstants.cities[index];
                    return ListTile(
                      title: Text(city, style: AppTextStyles.bodyLarge),
                      onTap: () {
                        setState(() {
                          _selectedCity = city;
                        });
                        Navigator.pop(context);
                      },
                      selected: _selectedCity == city,
                      selectedTileColor: AppColors.primary.withOpacity(0.1),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress indicator
                        LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: AppColors.textHint.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.starGold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Welcome text
                        Text('Tell us about yourself', style: AppTextStyles.h2),
                        const SizedBox(height: 8),
                        Text(
                          'Help us personalize your astro experience',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name field
                                Text('Full Name', style: AppTextStyles.label),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your full name',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: _validateName,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 24),

                                // Age field
                                Text('Age', style: AppTextStyles.label),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _ageController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your age',
                                    prefixIcon: Icon(Icons.cake_outlined),
                                  ),
                                  validator: _validateAge,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  textInputAction: TextInputAction.done,
                                ),
                                const SizedBox(height: 24),

                                // City field
                                Text('Location', style: AppTextStyles.label),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _showCityPicker,
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedCity == null
                                            ? AppColors.textHint
                                            : AppColors.primary,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: AppColors.textHint,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              _selectedCity ??
                                                  'Select your city',
                                              style: _selectedCity != null
                                                  ? AppTextStyles.bodyLarge
                                                  : AppTextStyles.bodyLarge
                                                        .copyWith(
                                                          color: AppColors
                                                              .textHint,
                                                        ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColors.textHint,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (_selectedCity == null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      left: 12,
                                    ),
                                    child: Text(
                                      'Please select a city',
                                      style: AppTextStyles.error,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Submit button
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return GradientButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _submitOnboarding,
                              isLoading: authProvider.isLoading,
                              child: Text(
                                'Complete Profile',
                                style: AppTextStyles.buttonLarge,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
