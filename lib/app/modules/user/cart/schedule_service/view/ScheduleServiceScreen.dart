import 'package:intl/intl.dart';
import 'package:ozi/app/modules/user/cart/change%20address/provider/ChangeAddressProvider.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_date_picker.dart';
import '../../change address/view/ChangeAddressScreen.dart';
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
          create: (_) => ChangeAddressProvider()..fetchUserAddresses(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider()..scheduleService(),
        ),
      ],
      child: _ScheduleServiceScreenContent(),
    );
  }
}

class _ScheduleServiceScreenContent extends StatelessWidget {
  const _ScheduleServiceScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<ChangeAddressProvider>();
    final provider = context.watch<ScheduleProvider>();
    final times = provider.availableTimesForSelectedDay;

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
                                  );
                              if (pickedDate != null) {
                                provider.selectDate(pickedDate);
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
                        final date = DateTime.now().add(Duration(days: index));
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
                                  provider.quickDates[index]['day']!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.quickDates[index]['date']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  provider.quickDates[index]['month']!,
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
                  times.isEmpty
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
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: times.map((time) {
                            final isSelected = provider.selectedTime == time;
                            return GestureDetector(
                              onTap: () => provider.selectTime(time),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
                          final selectedIndex = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: addressProvider,
                                child: const ChangeAddressScreen(),
                              ),
                            ),
                          );
                          if (selectedIndex != null) {
                            final addressProvider =
                                Provider.of<ChangeAddressProvider>(
                                  context,
                                  listen: false,
                                );
                            addressProvider.selectAddress((selectedIndex));
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
                            path: ImageConstants.home2,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addressProvider.selectedAddress?.addressType !=
                                            null &&
                                        addressProvider
                                            .selectedAddress!
                                            .addressType!
                                            .isNotEmpty
                                    ? '${addressProvider.selectedAddress!.addressType![0].toUpperCase()}${addressProvider.selectedAddress!.addressType!.substring(1)}'
                                    : 'Address',
                                style: AppFontStyle.text_14_600(
                                  AppColors.black,
                                  fontFamily: AppFontFamily.semiBold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                addressProvider.selectedAddress != null
                                    ? addressProvider.getFormattedAddress(
                                        addressProvider.selectedAddress!,
                                      )
                                    : '',
                                style: AppFontStyle.text_14_400(AppColors.grey),
                              ),
                            ],
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
                            addressProvider.selectedAddress == null)
                        ? null
                        : () {
                            print("inside this onPresses");
                            provider.bookServiceApi(
                              context: context,
                              addressId:
                                  addressProvider.selectedAddress?.id ?? 0,
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
}
