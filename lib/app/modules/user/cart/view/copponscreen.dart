import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:ozi/app/modules/user/cart/view/cupponprovider.dart';
import 'package:ozi/app/modules/user/cart/view/model/couponmodel.dart' as model;
import 'package:intl/intl.dart';

class CopponScreen extends StatefulWidget {
  const CopponScreen({super.key});

  @override
  State<CopponScreen> createState() => _CopponScreenState();
}

class _CopponScreenState extends State<CopponScreen> {
  final TextEditingController _couponController = TextEditingController();
  CupponProvider provider = CupponProvider();

  @override
  void initState() {
    super.initState();
    provider.fetchCoupons();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<CupponProvider>().fetchCoupons();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: provider,
          child: Column(
            children: [
              CustomAppBar(title: "Coupon Code"),
              Expanded(
                child: Consumer<CupponProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return Center(child: Text(provider.errorMessage!));
                    }

                    final coupons = provider.couponsModel?.data ?? [];

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          hBox(20),
                          _buildCouponInput(),
                          hBox(24),
                          ...coupons.map(
                            (coupon) => _buildCouponCard(coupon, provider),
                          ),
                          hBox(20),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildBottomApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Icon(Icons.percent, color: AppColors.primary, size: 20.w),
          wBox(12),
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                hintStyle: AppFontStyle.text_14_400(AppColors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle manual apply
            },
            child: Text(
              "Apply",
              style: AppFontStyle.text_16_600(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(model.Data coupon, CupponProvider provider) {
    final bool isSelected = provider.selectedCoupon?.id == coupon.id;
    final expiryDate = coupon.expiryDate != null
        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(coupon.expiryDate!))
        : "N/A";

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Save \$${coupon.value ?? '0'}",
                style: AppFontStyle.text_16_700(AppColors.black),
              ),
              GestureDetector(
                onTap: () => provider.selectCoupon(coupon),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    border: Border.all(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 14.w, color: AppColors.white)
                      : null,
                ),
              ),
            ],
          ),
          hBox(4),
          Text(
            "${coupon.type == 'percentage' ? (coupon.value ?? '0') + '%' : '\$' + (coupon.value ?? '0')} off on service book",
            style: AppFontStyle.text_14_400(AppColors.grey),
          ),
          hBox(16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: 1,
                style: BorderStyle
                    .solid, // Custom dashed border would be better but standard for now
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon.code ?? "",
                  style: AppFontStyle.text_16_600(AppColors.primary),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon.code ?? ""));
                    Get.showToast(
                      "Code copied to clipboard",
                      type: ToastType.success,
                    );
                  },
                  child: Icon(Icons.copy, color: AppColors.primary, size: 20.w),
                ),
              ],
            ),
          ),
          hBox(12),
          Text(
            "Valid until $expiryDate",
            style: AppFontStyle.text_12_400(AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomApplyButton() {
    return Consumer<CupponProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: CustomButton(
            text: "Apply",
            height: 52.h,
            color: provider.selectedCoupon != null
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            onPressed: provider.selectedCoupon != null
                ? () {
                    Navigator.pop(context, provider.selectedCoupon);
                  }
                : null,
          ),
        );
      },
    );
  }
}
