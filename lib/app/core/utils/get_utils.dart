import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ozi/app/core/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/font_style.dart';
// import 'package:awesome_snackbar_content/src/content_type.dart';


class Get {
  static OutlineInputBorder defaultBorder(double? borderRadius) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: AppColors.fieldBgColor),
      borderRadius: BorderRadius.circular(borderRadius ?? 60.r),
    );
  }

  static OutlineInputBorder focusedBorder(double? borderRadius) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 0.7, color: AppColors.fieldBgColor),
      borderRadius: BorderRadius.circular(
        borderRadius ?? 60.r,
      ), // use parameter
    );
  }

  static OutlineInputBorder errorBorder([double? borderRadius]) {
    return OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(color: AppColors.redText, width: 0.7),
      borderRadius: BorderRadius.circular(
        borderRadius ?? 60.r,
      ), // use parameter
    );
  }

  static TextStyle errorTextStyle() {
    return AppFontStyle.text_12_400(AppColors.redText);
  }

  static consoleLog(String message, String name) {}

  //************************************* Email Validation *************************************//

  static bool isValidEmail(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static String getFormattedDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      final outputFormat = DateFormat('yyyy-MM-dd');

      return outputFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }
  static String getFormattedDate1(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      final outputFormat = DateFormat('dd-MM-yyyy');

      return outputFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }
  static String getFormattedFullDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final outputFormat = DateFormat('EEEE, dd MMM yyyy, hh:mm a');

      return outputFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static String formatTimeToAmPm(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }

  //************************************* Capitalize First Letter *************************************//
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  //************************************* Dial Call *************************************//

  static Future<void> dialCall(String number) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: number);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        consoleLog('Could not launch phone dialer', 'DialCall');
      }
    } catch (e) {
      consoleLog('Error launching dialer: $e', 'DialCall');
    }
  }

  //************************************* WhatsApp Support *************************************//

  static Future<void> whatsapp(BuildContext context) async {
    var contact = "+918977636465";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi BeautyGlad Support, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      errorToast(context, 'WhatsApp is not installed.');
    }
  }

  static Future<void> openPlayStore() async {
    final packageName = "com.app.beautyglad";

    final url = Uri.parse(
      Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=$packageName"
          : "https://apps.apple.com/app/id6753200073",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  //************************************* Share Referral Code *************************************//
  //
  // static Future<void> shareReferralCodeWithSharePlus(
  //   BuildContext context,
  // ) async {
  //   final profileProvider = Provider.of<ProfileProvider>(
  //     context,
  //     listen: false,
  //   );
  //   final code = profileProvider.profileAPIData.data?.create_account?.referralCode;
  //   final String shareText =
  //       "✨ Hey Gorgeous! ✨\n\n"
  //       "I just tried *BeautyGlad* for **Beauty Services at Home** 💅💆‍♀️ and had an amazing experience! 🌸\n\n"
  //       "Here’s a 🎁 gift of **200 Points** for you to try their services.\n"
  //       "I’m sure you’ll 💖 love them too!\n\n"
  //       "🔑 My Referral Code: {$code}\n\n"
  //       "📲 Download the app now 👉 {https://play.google.com/store/apps/details?id=com.app.beautyglad}";
  //
  //   try {
  //     await SharePlus.instance.share(
  //       ShareParams(
  //         text: shareText,
  //         subject: 'Join BeautyGlad with my referral code!',
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Failed to share. Please try again.',
  //           style: AppFontStyle.text_14_500(
  //             AppColors.white,
  //             fontFamily: AppFontFamily.medium,
  //           ),
  //         ),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8.r),
  //         ),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }

  //************************************* Time Ago Format *************************************//

  static String formatTimeAgo(String dateTimeString) {
    final dateTime = DateTime.tryParse(dateTimeString);
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 0) {
      return 'In the future';
    } else if (difference.inMinutes <= 10) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM yyyy').format(dateTime);
    }
  }

  //************************************* Logout Confirmation Dialog *************************************//

  // static Future<bool?> isLoginConfirmationDialog(BuildContext context) async {
  //   return await showModalBottomSheet<bool>(
  //     context: context,
  //     isDismissible: false,
  //     enableDrag: false,
  //     backgroundColor: AppColors.transparent,
  //     builder: (context) => _buildLogoutBottomSheet(context),
  //   );
  // }

  // static Widget _buildLogoutBottomSheet(BuildContext context) {
  //   return Container(
  //     padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           "Confirmation",
  //           style: AppFontStyle.text_24_600(
  //             AppColors.darkText,
  //             fontFamily: AppFontFamily.semiBold,
  //           ),
  //         ),
  //         hBox(8),
  //         Text(
  //           "Kindly Login/Signup Please",
  //           style: AppFontStyle.text_14_400(AppColors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //         hBox(20),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: CustomButton(
  //                 isOutlined: true,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 text: 'No',
  //               ),
  //             ),
  //             wBox(12),
  //             Expanded(
  //               child: CustomButton(
  //                 onPressed: () {
  //                   Navigator.pushNamedAndRemoveUntil(
  //                     context,
  //                     AppRoutes.login,
  //                     (route) => false,
  //                   );
  //                 },
  //                 text: 'Yes',
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: MediaQuery.of(context).padding.bottom),
  //       ],
  //     ),
  //   );
  // }

  //************************************* Available Slots Filter *************************************//

  static String generateSecureRandomId() {
    final random = Random.secure();
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomNumber = random.nextInt(999999999);
    return '${timestamp}_$randomNumber';
  }

  //************************************* Share Receipt on Whatsapp *************************************//

//   static Future<void> shareOnWhatsApp({
//     required BuildContext context,
//     required OrderConfirmData orderData,
//     required PlaceOrderData placeOrderData,
//     String supportPhone = '+918977636465',
//   }) async {
//     String formattedDateTime = getFormattedDate(
//       orderData.scheduledDateTime ?? '',
//     );
//     String message =
//         '''
// 🎉 *Booking Confirmed* 🎉
//
// ━━━━━━━━━━━━━━━━━━━━
// 📋 *ORDER DETAILS*
// ━━━━━━━━━━━━━━━━━━━━
//
// 🆔 *Order ID:* ${orderData.orderId}
// 📅 *Date & Time:* $formattedDateTime
// 👤 *Customer:* ${orderData.customerDetails?.name ?? 'N/A'}
// 📞 *Phone:* ${orderData.customerDetails?.mobile ?? 'N/A'}
// 📍 *Address:* ${orderData.customerDetails?.address ?? 'N/A'}
//
// ━━━━━━━━━━━━━━━━━━━━
// 🛍️ *SERVICES BOOKED*
// ━━━━━━━━━━━━━━━━━━━━
//
// ${_formatServicesList(placeOrderData.items)}
//
// ━━━━━━━━━━━━━━━━━━━━
// 💰 *BILLING DETAILS*
// ━━━━━━━━━━━━━━━━━━━━
//
// Subtotal: ₹${_formatPrice(orderData.billingDetails?.totalAmount)}
// ${orderData.billingDetails?.discount != null && orderData.billingDetails!.discount! > 0 ? 'Discount: -₹${_formatPrice(orderData.billingDetails?.discount)}\n' : ''}${orderData.billingDetails?.serviceCharge != null && orderData.billingDetails!.serviceCharge! > 0 ? 'Service Charge: ₹${_formatPrice(orderData.billingDetails?.serviceCharge)}\n' : ''}${orderData.billingDetails?.platformFee != null && orderData.billingDetails!.platformFee! > 0 ? 'Platform Fee: ₹${_formatPrice(orderData.billingDetails?.platformFee)}\n' : ''}${orderData.billingDetails?.loyaltyPoints != null && orderData.billingDetails!.loyaltyPoints! > 0 ? 'Loyalty Points: -₹${_formatPrice(orderData.billingDetails?.loyaltyPoints)}\n' : ''}
// 💳 *Total Payable:* ₹${_formatPrice(orderData.billingDetails?.totalPayable)}
//
// ━━━━━━━━━━━━━━━━━━━━
//
// ${orderData.specialInstructions?.isNotEmpty ?? false ? '📝 *Special Instructions:*\n${orderData.specialInstructions}\n\n━━━━━━━━━━━━━━━━━━━━\n\n' : ''}${orderData.importantNotes?.isNotEmpty ?? false ? '⚠️ *Important Notes:*\n${orderData.importantNotes}\n\n━━━━━━━━━━━━━━━━━━━━\n\n' : ''}
// Thank you for choosing BeautyGlad! 💖✨
//
// Need help? Contact us:
// 📞 $supportPhone
// 🌐 www.beautyglad.com
//
// _Your satisfaction is our priority!_ 🌟
// ''';
//
//     var encodedMessage = Uri.encodeComponent(message);
//     var androidUrl = "whatsapp://send?text=$encodedMessage";
//     var iosUrl = "https://wa.me/?text=$encodedMessage";
//
//     try {
//       Uri whatsappUri;
//       if (Platform.isIOS) {
//         whatsappUri = Uri.parse(iosUrl);
//       } else {
//         whatsappUri = Uri.parse(androidUrl);
//       }
//
//       bool launched = await launchUrl(
//         whatsappUri,
//         mode: LaunchMode.externalApplication,
//       );
//
//       if (!launched) {
//         throw Exception('Could not launch WhatsApp');
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.white),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'WhatsApp is not installed on your device',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: Colors.red.shade600,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             duration: Duration(seconds: 3),
//             action: SnackBarAction(
//               label: 'OK',
//               textColor: Colors.white,
//               onPressed: () {},
//             ),
//           ),
//         );
//       }
//     }
//   }

  static String _formatPrice(dynamic price) {
    if (price == null) return '0.00';
    return double.parse(price.toString()).toStringAsFixed(2);
  }

  // static String _formatServicesList(List<Items>? items) {
  //   if (items == null || items.isEmpty) {
  //     return 'No services booked.';
  //   }
  //
  //   return items.map((item) {
  //     final name = item.name ?? 'Unnamed Service';
  //     final qty = item.qty ?? 1;
  //     final price = item.price ?? 0;
  //     return '• $name (x$qty) – ₹$price';
  //   }).join('\n');
  // }


  static void showToast(
      String msg, {
        required ToastType type, // = ToastType.notice,
      }) {
    final context = navigatorKey.currentContext!;

    // Map enum to title and ContentType
    final title = _getTitle(type);
    // final contentType = _getContentType(type);

    // final snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: title,
    //     message: msg.replaceAll("Exception: ", ''),
    //     contentType: contentType,
    //   ),
    // );

    final snackBar = SnackBar(
      elevation: 0,
      // behavior: SnackBarBehavior.floating,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: type == ToastType.success ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              type == ToastType.success
                  ? Icons.check_circle
                  : Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(msg.replaceAll("Exception: ", ''), style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );


    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static String _getTitle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return 'Success';
      case ToastType.error:
        return 'Error';
      case ToastType.warning:
        return 'Warning';
      case ToastType.notice:
      default:
        return 'Notice';
    }
  }

  // static ContentType _getContentType(ToastType type) {
  //   switch (type) {
  //     case ToastType.success:
  //       return ContentType.success as ;
  //     case ToastType.error:
  //       return ContentType.failure;
  //     case ToastType.warning:
  //       return ContentType.warning;
  //     case ToastType.notice:
  //     default:
  //       return ContentType.help;
  //   }
  // }

}

enum ToastType { success, error, warning, notice }

//************************************* Navigator Key *************************************
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
