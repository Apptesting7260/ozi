import 'package:intl/intl.dart';
import 'package:ozi/app/modules/user/profile/save%20address/provider/saved_address_provider.dart';
import 'package:ozi/app/modules/user/profile/save%20address/view/SavedAddressScreen.dart';
import 'package:ozi/app/modules/user/profile/save%20address/model/user_address_model.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_date_picker.dart';
import '../../chnge payment method/provider/PaymentMethodProvider.dart';
import '../../chnge payment method/view/ChangePaymentMethodScreen.dart';
import '../provider/ScheduleProvider.dart';

class ScheduleServiceScreen extends StatelessWidget {
  const ScheduleServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SavedAddressProvider()..fetchUserAddresses(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider()..scheduleService(),
        ),
      ],
      child: _ScheduleServiceScreenContent(),
    );
  }
}

class _ScheduleServiceScreenContent extends StatefulWidget {
  const _ScheduleServiceScreenContent();

  @override
  State<_ScheduleServiceScreenContent> createState() =>
      _ScheduleServiceScreenContentState();
}

class _ScheduleServiceScreenContentState
    extends State<_ScheduleServiceScreenContent> {
  // Static to persist across screen recreations within the same session
  static Data? _selectedAddress;
  static int? _selectedIndex;
  bool _hasAutoSetDefault = false;

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<SavedAddressProvider>();
    final provider = context.watch<ScheduleProvider>();
    List<String> times = provider.availableTimesForSelectedDay;

    // Additional UI-level filtering to ensure past slots are hidden for today
    // final now = DateTime.now();
    // final isToday =
    //     provider.selectedDate.year == now.year &&
    //     provider.selectedDate.month == now.month &&
    //     provider.selectedDate.day == now.day;

    // if (isToday) {

    //   final nowInMinutes = now.hour * 60 + now.minute;

    //   times = times.where((time) {
    //     try {
    //       // Parse string like "9:00 AM" to minutes
    //       final parts = time.split(' ');
    //       final timeParts = parts[0].split(':');
    //       int hour = int.parse(timeParts[0]);
    //       final minute = int.parse(timeParts[1]);
    //       final amPm = parts[1];

    //       if (amPm == 'PM' && hour != 12) hour += 12;
    //       if (amPm == 'AM' && hour == 12) hour = 0;

    //       final slotInMinutes = hour * 60 + minute;
    //       return slotInMinutes > nowInMinutes;
    //     } catch (e) {
    //       return true; // Fallback to show if parsing fails
    //     }
    //   }).toList();
    // }

    // Auto-set default address once addresses are loaded,
    // but only if user hasn't previously selected one

    if (!_hasAutoSetDefault &&
        !addressProvider.isLoading &&
        addressProvider.addresses.isNotEmpty) {
      _hasAutoSetDefault = true;
      // If a previous selection exists, verify it's still valid
      if (_selectedIndex != null &&
          _selectedIndex! >= 0 &&
          _selectedIndex! < addressProvider.addresses.length) {
        _selectedAddress = addressProvider.addresses[_selectedIndex!];
      } else {
        // No previous selection — use default address
        final defaultIndex = addressProvider.addresses.indexWhere(
          (addr) => addr.isDefault == true,
        );
        if (defaultIndex != -1) {
          _selectedAddress = addressProvider.addresses[defaultIndex];
          _selectedIndex = defaultIndex;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider.value(
            value: provider,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(title: "Schedule Service"),

                  hBox(20),
                  Text(
                    'Select Date',
                    style: AppFontStyle.text_16_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                  hBox(16),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 8),
                      itemCount: provider.quickDates.length + 1,
                      itemBuilder: (context, index) {
                        /// 🔹 LAST ITEM = MORE DATES
                        if (index == provider.quickDates.length) {
                          return GestureDetector(
                            onTap: () async {
                              final pickedDate =
                                  await CustomDatePicker.showServiceDatePicker(
                                    context,
                                    initialDate: provider.selectedDate,
                                  );
                              if (pickedDate != null) {
                                provider.selectDate(pickedDate, isCustom: true);
                              }
                            },
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'More\nDates',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        /// 🔹 NORMAL DATE ITEMS
                        final date = provider.quickDates[index];
                        final isSelected =
                            provider.selectedDate.year == date.year &&
                            provider.selectedDate.month == date.month &&
                            provider.selectedDate.day == date.day;

                        return GestureDetector(
                          onTap: () => provider.selectDate(date),
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.formatDatePart(date, 'day'),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.formatDatePart(date, 'date'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  provider.formatDatePart(date, 'month'),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  hBox(24),

                  /// -------- TIME ----------
                  Text(
                    'Select Time',
                    style: AppFontStyle.text_16_600(AppColors.black),
                  ),
                  hBox(16),
                  provider.isLoading
                      ? _timeShimmer()
                      : times.isEmpty
                      ? Center(
                          child: Text(
                            'No service available for this day',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.2,
                              ),
                          itemCount: times.length,
                          itemBuilder: (context, index) {
                            final time = times[index];
                            final isSelected = provider.selectedTime == time;
                            return GestureDetector(
                              onTap: () => provider.selectTime(time),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  time,
                                  style: AppFontStyle.text_14_600(
                                    isSelected ? Colors.white : Colors.black,
                                    fontFamily: AppFontFamily.semiBold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                  SizedBox(height: 24),

                  // ========== SERVICE ADDRESS ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Address',
                        style: AppFontStyle.text_16_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.medium,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Set previously selected index on provider
                          if (_selectedIndex != null) {
                            addressProvider.selectAddress(_selectedIndex!);
                          }
                          final selectedIndex = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: addressProvider,
                                child: const SavedAddressScreen(
                                  isservice: true,
                                ),
                              ),
                            ),
                          );
                          if (selectedIndex != null &&
                              selectedIndex >= 0 &&
                              selectedIndex <
                                  addressProvider.addresses.length) {
                            setState(() {
                              _selectedIndex = selectedIndex;
                              _selectedAddress =
                                  addressProvider.addresses[selectedIndex];
                            });
                          }
                        },
                        child: Text(
                          'Change Address >',
                          style: AppFontStyle.text_14_500(
                            AppColors.primary,
                            fontFamily: AppFontFamily.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.containerBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomImage(
                            path: ImageConstants.location,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _selectedAddress != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedAddress!.addressType != null &&
                                              _selectedAddress!
                                                  .addressType!
                                                  .isNotEmpty
                                          ? '${_selectedAddress!.addressType![0].toUpperCase()}${_selectedAddress!.addressType!.substring(1)}'
                                          : 'Address',
                                      style: AppFontStyle.text_14_600(
                                        AppColors.black,
                                        fontFamily: AppFontFamily.semiBold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      addressProvider.getFormattedAddress(
                                        _selectedAddress!,
                                      ),
                                      style: AppFontStyle.text_14_400(
                                        AppColors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Select an address',
                                  style: AppFontStyle.text_14_600(
                                    AppColors.black,
                                    fontFamily: AppFontFamily.semiBold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  hBox(12),

                  // ========== PAYMENT METHOD ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Method',
                        style: AppFontStyle.text_16_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.medium,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final selectedMethod =
                              await Navigator.push<PaymentModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePaymentMethodScreen(
                                    selectedMethodTitle:
                                        provider.selectedPaymentMethod?.title,
                                  ),
                                ),
                              );
                          if (selectedMethod != null) {
                            provider.setPaymentMethod(selectedMethod);
                          }
                        },
                        child: Text(
                          'Change method >',
                          style: AppFontStyle.text_14_500(
                            AppColors.primary,
                            fontFamily: AppFontFamily.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.containerBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomImage(
                            path:
                                provider.selectedPaymentMethod?.icon ??
                                ImageConstants.card,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.selectedPaymentMethod?.title ?? 'Cash',
                                style: AppFontStyle.text_14_600(
                                  AppColors.black,
                                  fontFamily: AppFontFamily.semiBold,
                                ),
                              ),
                              if (provider
                                      .selectedPaymentMethod
                                      ?.masked
                                      .isNotEmpty ??
                                  false) ...[
                                SizedBox(height: 4),
                                Text(
                                  provider.selectedPaymentMethod!.masked,
                                  style: AppFontStyle.text_14_400(
                                    AppColors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // ========== BOOKING SUMMARY ==========
                  Text(
                    'Booking Summary',
                    style: AppFontStyle.text_18_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: AppFontStyle.text_16_400(AppColors.grey),
                          ),
                          Text(
                            DateFormat(
                              'dd MMM, yyyy',
                            ).format(provider.selectedDate),
                            style: AppFontStyle.text_16_400(AppColors.darkText),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time',
                            style: AppFontStyle.text_16_400(AppColors.grey),
                          ),
                          Text(
                            provider.selectedTime ?? 'Not selected',
                            style: AppFontStyle.text_16_400(AppColors.darkText),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // ========== CONTINUE BUTTON ==========
                  CustomButton(
                    isLoading: provider.isBookingLoading,
                    onPressed:
                        (provider.selectedTime == null ||
                            _selectedAddress == null)
                        ? null
                        : () {
                            if (kDebugMode) {
                              print("inside this onPresses");
                            }
                            provider.bookServiceApi(
                              context: context,
                              addressId: _selectedAddress!.id.toString(),
                              paymentMethod:
                                  provider.selectedPaymentMethod?.title
                                      .trim()
                                      .toLowerCase()
                                      .replaceAll(' ', '_') ??
                                  'cash',
                            );
                          },
                    text: provider.selectedPaymentMethod?.title == 'Cash'
                        ? "Continue"
                        : 'Continue to Payment',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateShimmer() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
