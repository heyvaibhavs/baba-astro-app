import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/horoscope_service.dart';
import '../widgets/gradient_button.dart';

/// Daily Horoscope screen with sign selection and date options
class DailyHoroscopeScreen extends StatefulWidget {
  const DailyHoroscopeScreen({super.key});

  @override
  State<DailyHoroscopeScreen> createState() => _DailyHoroscopeScreenState();
}

class _DailyHoroscopeScreenState extends State<DailyHoroscopeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedSign = 'Cancer';
  String _selectedPeriod = 'TODAY';
  String? _customDate;
  HoroscopeResponse? _horoscopeData;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _periods = ['TODAY', 'TOMORROW', 'YESTERDAY'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchHoroscope();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  Future<void> _fetchHoroscope() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String dayParam;
      if (_customDate != null) {
        dayParam = HoroscopeService.formatDateForAPI(_customDate!);
      } else {
        dayParam = _selectedPeriod;
      }

      final response = await HoroscopeService.getHoroscope(
        sign: _selectedSign,
        day: dayParam,
      );

      if (mounted) {
        setState(() {
          _horoscopeData = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch horoscope. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.starGold,
              onPrimary: AppColors.background,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customDate = DateFormat('dd-MM-yyyy').format(picked);
        _selectedPeriod = 'CUSTOM';
      });
      _fetchHoroscope();
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
      if (period != 'CUSTOM') {
        _customDate = null;
      }
    });
    if (period != 'CUSTOM') {
      _fetchHoroscope();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Horoscope'),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.galaxyPurple.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 48,
                            color: AppColors.starGold,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your Cosmic Forecast',
                            style: AppTextStyles.h2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Discover what the stars have in store for you',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign selection
                    Text('Select Your Zodiac Sign', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSign,
                          isExpanded: true,
                          style: AppTextStyles.bodyLarge,
                          dropdownColor: AppColors.cardBackground,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSign = newValue;
                              });
                              _fetchHoroscope();
                            }
                          },
                          items: HoroscopeService.zodiacSigns
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: AppColors.starGold,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(value),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Period selection tabs
                    Text('Select Time Period', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ..._periods.map(
                            (period) => Expanded(
                              child: GestureDetector(
                                onTap: () => _onPeriodChanged(period),
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedPeriod == period
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    period,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: _selectedPeriod == period
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                      fontWeight: _selectedPeriod == period
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Custom date picker button
                    GradientButton(
                      onPressed: _selectCustomDate,
                      height: 48,
                      gradientColors: [
                        AppColors.starGold.withOpacity(0.8),
                        AppColors.starGold,
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.background,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _customDate != null
                                ? 'Custom Date: $_customDate'
                                : 'Select Custom Date',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Horoscope content
                    if (_isLoading)
                      Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.starGold,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Consulting the stars...',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          AppConstants.largePadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: AppTextStyles.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            GradientButton(
                              onPressed: _fetchHoroscope,
                              height: 48,
                              child: Text(
                                'Try Again',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_horoscopeData != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.starGold.withOpacity(0.1),
                                  AppColors.starGold.withOpacity(0.05),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.starGold.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: AppColors.starGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _horoscopeData!.data.date,
                                      style: AppTextStyles.h3.copyWith(
                                        color: AppColors.starGold,
                                      ),
                                    ),
                                    Text(
                                      'for $_selectedSign',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Horoscope content
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              AppConstants.largePadding,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.psychology,
                                      color: AppColors.starGold,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Your Horoscope',
                                      style: AppTextStyles.h3,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _horoscopeData!.data.horoscopeData,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Refresh button
                          GradientButton(
                            onPressed: _fetchHoroscope,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Refresh Horoscope',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
