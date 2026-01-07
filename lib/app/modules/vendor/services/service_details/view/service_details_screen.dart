import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/modules/vendor/services/edit%20service/view/vendor_editservice_screen.dart';

import '../provider/service_details_provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailsProvider(),
      child: const _ServiceDetailsContent(),
    );
  }
}

// ... rest of the screen code from the artifact

class _ServiceDetailsContent extends StatelessWidget {
  const _ServiceDetailsContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceDetailsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEFEFEF),
                ),
                padding: REdgeInsets.all(14),
                child: CustomImage(path: ImageConstants.back),
              ),
            ),
          ),
        ),

        /// 🔹 TITLE PADDING
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Service Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        centerTitle: true,

        /// 🔹 RIGHT PADDING CONTROL
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                _showOptionsMenu(context, provider);
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ============ SERVICE CARD ============
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      provider.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 40, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 3,
                          provider.serviceName,
                          style: AppFontStyle.text_16_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              provider.duration,
                              style: AppFontStyle.text_12_400(AppColors.grey),
                            ),

                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '\$${provider.price.toStringAsFixed(2)}',
                              style: AppFontStyle.text_18_600(
                                AppColors.primary,
                                fontFamily: AppFontFamily.bold,
                              ),
                            ),

                            Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.70),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                provider.isActive ? 'Active' : 'Inactive',
                                style: AppFontStyle.text_12_400(AppColors.white),
                              ),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ============ ABOUT SERVICE ============
              Text(
                'About Service',
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.bold,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                maxLines: 10,
                provider.description,
                style: AppFontStyle.text_14_400(
                  AppColors.grey,
                ),
              ),


              const SizedBox(height: 24),

              /// ============ PERFORMANCE ============
              Text(
                'Performance',
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.bold,
                ),
              ),

              hBox(12),

              Row(
                children: [
                  Expanded(
                    child: _performanceTile(
                      title: 'Today Bookings',
                      value: provider.todayBookings.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _performanceTile(
                      title: 'Total Bookings',
                      value: provider.totalBookings.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      /// ============ BOTTOM BUTTONS ============
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            /// Delete Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  showDeleteDialog(context, );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                label: Text(
        'Delete',
        style: AppFontStyle.text_14_600(
          Colors.red,
          fontFamily: AppFontFamily.bold,
        ),
      ),

    ),
            ),
            const SizedBox(width: 12),

            /// Edit Button
            Expanded(
              child: CustomButton(
                height: 52,
                isOutlined: true,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  VendorEditserviceScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CustomImage(path: ImageConstants.edit, color: AppColors.primary,),
                    wBox(8),
                    Text(
                      'Edit',
                      style: AppFontStyle.text_14_600(
                        AppColors.primary,
                        fontFamily: AppFontFamily.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// Performance Tile Widget
  Widget _performanceTile({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppFontStyle.text_24_700(
              AppColors.black,
              fontFamily: AppFontFamily.bold,
            ),
          ),

          const SizedBox(height: 4),
          Text(
            title,
            style: AppFontStyle.text_13_400(AppColors.grey),
          ),

        ],
      ),
    );
  }

  /// Options Menu (Three dots)
  void _showOptionsMenu(BuildContext context, ServiceDetailsProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.toggle_on, color: Color(0xFF00B4A6)),
                title: Text(
                  provider.isActive ? 'Deactivate Service' : 'Activate Service',
                ),
                onTap: () {
                  provider.toggleStatus();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Service ${provider.isActive ? "activated" : "deactivated"}',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: const Text('Share Service'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share functionality')),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  /// Delete Confirmation Dialog
  Future<void> showDeleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.white,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  "Delete Service?",
                  style: AppFontStyle.text_20_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  maxLines: 3,
                  "Are you sure you want to delete Shirt Sleeve Shortening & Fitting Service? This action cannot be undone.",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    CustomButton(
                      width: 140,
                      text: "Cancel",
                      textStyle: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.medium),
                      color: AppColors.grey,
                      isOutlined: true,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    wBox(10),
                    CustomButton(
                      width: 140,
                      text: "Delete",
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}