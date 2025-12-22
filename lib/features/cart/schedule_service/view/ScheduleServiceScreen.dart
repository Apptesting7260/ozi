import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../change address/view/ChangeAddressScreen.dart';
import '../../chnge payment method/view/ChangePaymentMethodScreen.dart';
import '../provider/ScheduleProvider.dart';

class ScheduleServiceScreen extends StatelessWidget {
  ScheduleServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleProvider(),
      child: _ScheduleServiceScreenContent(),
    );
  }
}

// ==================== SCREEN CONTENT ====================
class _ScheduleServiceScreenContent extends StatelessWidget {
  const _ScheduleServiceScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);

    final times = [
      '9:00 AM', '10:00 AM', '12:00 PM',
      '2:00 PM', '3:00 PM', '4:00 PM',
      '5:00 PM', '6:00 PM',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: "Booking Summary"),

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
                  itemCount: provider.quickDates.length + 1,
                  // +1 for "More Dates"
                  itemBuilder: (context, index) {
                    if (index == provider.quickDates.length) {
                      // "More Dates" button
                      return GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await CustomDatePicker
                              .showServiceDatePicker(context);
                          if (pickedDate != null) {
                            provider.selectDate(pickedDate);
                          }
                        },
                        child: Container(
                          width: 70,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.grey,
                                size: 20,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'More Dates',
                                style: AppFontStyle.text_10_600(
                                  AppColors.grey,
                                  fontFamily: AppFontFamily.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final date = provider.quickDates[index];
                    final dateTime = DateTime.now().add(Duration(days: index));
                    final isSelected = provider.selectedDate.day ==
                        dateTime.day &&
                        provider.selectedDate.month == dateTime.month &&
                        provider.selectedDate.year == dateTime.year;

                    return GestureDetector(
                      onTap: () => provider.selectDate(dateTime),
                      child: Container(
                        width: 70,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors
                              .lightGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(0xFF00BFA5) : Color(
                                0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date['day']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors
                                    .grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              date['date']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              date['month']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? AppColors.white : AppColors
                                    .darkText,
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

              // ========== SELECT TIME ==========
              Text(
                'Select Time',
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
              hBox(16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: times.map((time) {
                  final isSelected = provider.selectedTime == time;

                  return GestureDetector(
                    onTap: () => provider.selectTime(time),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors
                            .lightGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors
                              .white,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? AppColors.white : AppColors.black,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight
                              .normal,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeAddressScreen(),
                        ),
                      );
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.home_outlined,
                        color: Colors.black54,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: AppFontStyle.text_14_600(
                              AppColors.black,
                              fontFamily: AppFontFamily.semiBold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '123 Main Street, San Francisco, CA',
                            style: AppFontStyle.text_14_400(AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangePaymentMethodScreen(),
                        ),
                      );
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.black54,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit Card',
                            style: AppFontStyle.text_14_600(
                              AppColors.black,
                              fontFamily: AppFontFamily.semiBold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '•••• •••• •••• 4242',
                            style: AppFontStyle.text_14_400(AppColors.grey),
                          ),
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
                        '${provider.selectedDay}, ${provider
                            .selectedDateNumber} ${provider.selectedMonth}',
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
                        provider.selectedTime,
                        style: AppFontStyle.text_16_400(AppColors.darkText),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 32),

              // ========== CONTINUE BUTTON ==========
              CustomButton(
                onPressed: () {},
                text: 'Continue to Payment',
              ),
            ],
          ),
        ),
      ),
    );
  }
}