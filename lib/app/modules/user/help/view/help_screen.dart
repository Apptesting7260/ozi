import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../shared/widgets/custom_shimmer_box.dart';
import '../provider/HelpProvider.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HelpUserProvider()..fetchHelpData('user'),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  "Help & Support",
                  style: AppFontStyle.text_26_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
              ),
              hBox(12),
              _tabButtons(),
              hBox(16),
              Expanded(
                child: Consumer<HelpUserProvider>(
                  builder: (context, provider, _) {
                    return provider.tabIndex == 0
                        ? _faqWidget(context, provider)
                        : _supportWidget(context, provider);
                  },
                ),
              ),
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
    return Consumer<HelpUserProvider>(
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
  Widget _faqWidget(BuildContext context, HelpUserProvider provider) {
    if (provider.isLoading) {
      return _faqShimmer();
    }

    // 🔹 Clean the list ONCE
    final faqs =
        provider.helpModel?.data
            ?.where(
              (e) =>
                  e != null &&
                  e.question != null &&
                  e.question!.trim().isNotEmpty &&
                  e.answer != null &&
                  e.answer!.trim().isNotEmpty,
            )
            .toList() ??
        [];

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

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final isExpanded = provider.expandedIndex == index;
                final faq = faqs[index];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(15),
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
                                faq.question!,
                                style: AppFontStyle.text_14_600(
                                  AppColors.darkText,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.remove : Icons.add,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),

                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            faq.answer ?? "",
                            maxLines: 5,
                            style: AppFontStyle.text_13_400(
                              AppColors.grey,

                              height: 1.5,
                            ),
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                );
              },
            ),

            hBox(20),
          ],
        ),
      ),
    );
  }

  // Widget _faqWidget(BuildContext context, HelpUserProvider provider) {
  //   if (provider.isLoading) {
  //     return _faqShimmer();
  //   }
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: REdgeInsets.symmetric(horizontal: 16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Frequently Asked Questions",
  //             style: AppFontStyle.text_16_600(AppColors.darkText),
  //           ),
  //           hBox(20),

  //           // FAQ List
  //           ListView.separated(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemCount: provider.helpModel?.data?.length ?? 0,
  //             separatorBuilder: (context, index) => SizedBox(height: 12),
  //             itemBuilder: (context, index) {
  //               final isExpanded = provider.expandedIndex == index;

  //               return AnimatedContainer(
  //                 duration: Duration(milliseconds: 300),
  //                 padding: EdgeInsets.all(15),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.lightGrey,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     InkWell(
  //                       onTap: () => provider.toggleExpanded(index),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Expanded(
  //                             child: Text(
  //                               provider.helpModel?.data?[index].question ?? "",
  //                               style: AppFontStyle.text_14_600(
  //                                 AppColors.darkText,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(width: 8),
  //                           Container(
  //                             padding: EdgeInsets.all(4),
  //                             child: Icon(
  //                               isExpanded ? Icons.remove : Icons.add,
  //                               color: AppColors.primary,
  //                               size: 20,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     // Animated Answer
  //                     AnimatedCrossFade(
  //                       firstChild: SizedBox.shrink(),
  //                       secondChild: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           hBox(10),
  //                           Text(
  //                             maxLines: 4,
  //                             provider.helpModel?.data?[index].answer ?? "",
  //                             style: AppFontStyle.text_13_400(
  //                               AppColors.grey,
  //                               height: 1.5,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       crossFadeState: isExpanded
  //                           ? CrossFadeState.showSecond
  //                           : CrossFadeState.showFirst,
  //                       duration: Duration(milliseconds: 300),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  //           hBox(20),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // --------------------------------------------------------------------------
  // SUPPORT WIDGET - FULL SCREEN SCROLLABLE
  // --------------------------------------------------------------------------
  Widget _supportWidget(BuildContext context, HelpUserProvider provider) {
    // final contact = provider.contactInfo;
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputBox("Email Address", "Enter email address", _emailController),
          hBox(16),

          _inputBox("Subject", "Enter your subject", _subjectController),
          hBox(16),

          _largeInput("Message", "Write your message...", _messageController),
          hBox(16),

          CustomButton(
            text: provider.isLoading ? "Sending..." : "Send Message",
            onPressed: provider.isLoading
                ? null
                : () {
                    if (_emailController.text.trim().isEmpty ||
                        _subjectController.text.trim().isEmpty ||
                        _messageController.text.trim().isEmpty) {
                      Get.showToast(
                        "Please fill all fields",
                        type: ToastType.error,
                      );
                      return;
                    }

                    if (!Get.isValidEmail(_emailController.text.trim())) {
                      Get.showToast(
                        "Please enter a valid email address",
                        type: ToastType.error,
                      );
                      return;
                    }

                    provider.sendSupportMessage(
                      email: _emailController.text.trim(),
                      subject: _subjectController.text.trim(),
                      message: _messageController.text.trim(),
                    );
                  },
            height: 50,
            borderRadius: BorderRadius.circular(60),
          ),

          hBox(24),

          Text(
            "Quick Actions",
            style: AppFontStyle.text_16_600(AppColors.darkText),
          ),

          hBox(12),
          // if (contact?.callUs != null)
          _quickActionCard(
            imagePath: ImageConstants.call,
            title: "Call Us",
            subtitle: provider.helpModel?.actions?.callUs.toString() ?? "",
            buttonText: "Call Now",
            onTap: () {
              Get.dialCall(
                provider.helpModel?.actions?.callUs.toString() ?? "",
              );
            },
          ),

          // _quickActionCard(
          //   imagePath: ImageConstants.call,
          //   title: "Call Us",
          //   subtitle: provider.helpModel?.data?[0].callUs.toString() ?? "",
          //   buttonText: "Call Now",
          //   onTap: () {
          //     if (provider.helpModel?.data?[0].callUs != null) {
          //       Get.dialCall(provider.helpModel!.data![0].callUs!.toString());
          //     }
          //   },
          // ),
          hBox(12),

          _quickActionCard(
            imagePath: ImageConstants.mail,
            title: "Email Us",
            subtitle: provider.helpModel?.actions?.emailUs ?? "",
            buttonText: "Send Email",
            onTap: () {
              // if (provider.helpModel?.data?[0].emailUs != null) {
              //   Get.dialCall(provider.helpModel!.data![0].emailUs!.toString());
              // }
              // Implement email functionality if needed
            },
          ),

          hBox(40),
        ],
      ),
    );
  }

  Widget _quickActionCard({
    required String imagePath,
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
            child: Center(
              child: CustomImage(path: imagePath, color: AppColors.primary),
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
                Text(subtitle, style: AppFontStyle.text_12_400(AppColors.grey)),
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

  Widget _inputBox(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      controller: controller,
      borderRadius: 12,
      textInputAction: TextInputAction.next,
      width: double.infinity,
      height: null,
      maxLines: 1,
      minLines: 1,
      textInputType: label.toLowerCase().contains("email")
          ? TextInputType.emailAddress
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        if (label.toLowerCase().contains("email")) {
          if (!Get.isValidEmail(value.trim())) {
            return "Enter a valid email address";
          }
        }
        return null;
      },
    );
  }

  Widget _largeInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      controller: controller,
      borderRadius: 12,
      textInputType: TextInputType.multiline,
      maxLines: 5,
      minLines: 5,
      contentPadding: EdgeInsets.all(14),
      textInputAction: TextInputAction.newline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _faqShimmer() {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 200.w, height: 20.h, radius: 4.r),
            hBox(20),
            ListView.separated(
              itemCount: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => hBox(12),
              itemBuilder: (context, index) {
                return ShimmerBox(
                  width: double.infinity,
                  height: 60.h,
                  radius: 12.r,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
