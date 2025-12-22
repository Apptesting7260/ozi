import 'package:provider/provider.dart';

import '../../../core/appExports/app_export.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../provider/HelpProvider.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HelpProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Help & Support",
                  style: AppFontStyle.text_26_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
              ),
              SizedBox(height: 12),
              _tabButtons(),
              SizedBox(height: 16),
              Expanded(
                child: Consumer<HelpProvider>(
                  builder: (context, provider, _) {
                    return provider.tabIndex == 0
                        ? _faqWidget(context, provider)
                        : _supportWidget(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB BUTTONS
  // --------------------------------------------------------------------------
  Widget _tabButtons() {
    return Consumer<HelpProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                /// FAQs tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.changeTab(0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: provider.tabIndex == 0
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "FAQs",
                        style: AppFontStyle.text_14_500(
                          provider.tabIndex == 0
                              ? Colors.white
                              : AppColors.black,
                          fontFamily: AppFontFamily.medium,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Support tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.changeTab(1),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: provider.tabIndex == 1
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "Support",
                        style: AppFontStyle.text_14_500(
                          provider.tabIndex == 1
                              ? Colors.white
                              : AppColors.black,
                          fontFamily: AppFontFamily.medium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // FAQ WIDGET - FULL SCREEN SCROLLABLE
  // --------------------------------------------------------------------------
  Widget _faqWidget(BuildContext context, HelpProvider provider) {
    final data = [
      {
        "q": "How do I cancel a booking?",
        "a": "Contrary to popular belief, Lorem Ipsum text has roots in classical Latin from 45 BC, making it over 2000 years old. Richard McClintock."
      },
      {
        "q": "What payment methods are accepted?",
        "a": "We accept various payment methods including Visa, Mastercard, PayPal, UPI, and cash payments. All online transactions are secure and encrypted."
      },
      {
        "q": "How do I contact my service provider?",
        "a": "You can contact your service provider by opening your booking details and clicking on the chat icon. This will open a direct messaging channel."
      },
      {
        "q": "What if I'm not satisfied with the service?",
        "a": "If you're not satisfied with the service, you can request a refund within 24 hours of service completion, subject to our refund policy terms and conditions."
      },

    ];

    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: AppFontStyle.text_16_600(AppColors.darkText),
            ),
            hBox(20),

            // FAQ List
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final isExpanded = provider.expandedIndex == index;

                return AnimatedContainer(

                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => provider.toggleExpanded(index),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data[index]["q"]!,
                                style: AppFontStyle.text_14_600(AppColors.darkText),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(4),
                              // decoration: BoxDecoration(
                              //   color: isExpanded
                              //       ? AppColors.primary.withOpacity(0.1)
                              //       : Colors.transparent,
                              //   borderRadius: BorderRadius.circular(4),
                              // ),
                              child: Icon(
                                isExpanded ? Icons.remove : Icons.add,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Animated Answer
                      AnimatedCrossFade(
                        firstChild: SizedBox.shrink(),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hBox(10),
                            Text(
                              maxLines: 4,
                              data[index]["a"]!,
                              style: AppFontStyle.text_13_400(
                                AppColors.grey,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SUPPORT WIDGET - FULL SCREEN SCROLLABLE
  // --------------------------------------------------------------------------
  Widget _supportWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputBox("Email Address", "Enter email address"),
         hBox(16),

          _inputBox("Subject", "Enter your subject"),
          hBox(16),

          _largeInput("Message", "Write your message..."),
          hBox(16),

          CustomButton(
            text: "Send Message",
            onPressed: () {},
            height: 50,
            borderRadius: BorderRadius.circular(60),
          ),

          SizedBox(height: 24),

          Text(
            "Quick Actions",
            style: AppFontStyle.text_16_600(AppColors.darkText),
          ),

          SizedBox(height: 12),

          _quickActionCard(
            icon: Icons.phone_outlined,
            title: "Call Us",
            subtitle: "27 12315 1234",
            buttonText: "Call Now",
            onTap: () {
              // Implement call functionality
            },
          ),

          SizedBox(height: 12),

          _quickActionCard(
            icon: Icons.email_outlined,
            title: "Email Us",
            subtitle: "support@team.com",
            buttonText: "Send Email",
            onTap: () {
              // Implement email functionality
            },
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// ICON CONTAINER
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFontStyle.text_14_600(AppColors.darkText),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFontStyle.text_12_400(AppColors.grey),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                buttonText,
                style: AppFontStyle.text_12_600(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBox(String label, String hint) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      borderRadius: 12,
      textInputAction: TextInputAction.next,
      width: double.infinity,
      height: null,
      maxLines: 1,
      minLines: 1,
    );
  }

  Widget _largeInput(String label, String hint) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      borderRadius: 12,
      textInputType: TextInputType.multiline,
      maxLines: 5,
      minLines: 5,
      contentPadding: EdgeInsets.all(14),
      textInputAction: TextInputAction.newline,
    );
  }
}