import 'package:ozi/app/core/constants/app_urls.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/models/all_services_model_vendor.dart';
import '../../../../data/response/api_status.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../auth/vendor/signup/view/service_details.dart';
import '../filter/view/filters_screen.dart';
import '../provider/service_provider.dart';
import '../service_details/view/service_details_screen.dart';

class VendorServicesScreen extends StatelessWidget {
  const VendorServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorServicesProvider(),
      child: const _MyServicesContent(),
    );
  }
}

class _MyServicesContent extends StatelessWidget {
  const _MyServicesContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorServicesProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Services",
                style: AppFontStyle.text_24_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),

              hBox(16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      hintText: "Search...",
                      prefix: Icon(Icons.search, color: AppColors.grey),
                      borderRadius: 40,
                    ),
                  ),
                  wBox(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FiltersScreen()),
                      );
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.tune, color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              hBox(16),

              /// ADD SERVICE
              CustomButton(
                height: 50,
                isOutlined: true,
                borderRadius: BorderRadius.circular(60),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsScreen(null,"Add New Service"),
                    ),
                  );
                  if (result == null || result != null) {
                    provider.getAllBookings();
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const VendorAddNewServiceScreen(),
                  //   ),
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: AppColors.primary),
                    wBox(8),
                    Text(
                      "Add New Service",
                      style: AppFontStyle.text_14_600(
                        AppColors.primary,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                  ],
                ),
              ),

              hBox(20),

              switch (provider.homeModel.status) {
                ApiStatus.loading => Expanded(
                  child: const Center(child: CircularProgressIndicator()),
                ),

                ApiStatus.completed => Expanded(
                  child:
                      (provider.homeModel.data?.data == null ||
                          provider.homeModel.data!.data!.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list_alt,
                                size: 80,
                                color: AppColors.grey.withValues(alpha: 0.3),
                              ),
                              hBox(16),
                              Text(
                                "No services available",
                                style: AppFontStyle.text_16_400(AppColors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: provider.homeModel.data?.data?.length ?? 0,
                          separatorBuilder: (_, __) => hBox(14),
                          itemBuilder: (_, index) {
                            VendorGetAllServicesModelData? service =
                                provider.homeModel.data?.data?[index];
                            return _serviceCard(
                              context: context,
                              service: service,
                              provider: provider,
                            );
                          },
                        ),
                ),

                ApiStatus.error => Expanded(
                  child: const Center(child: Text('Something went wrong')),
                ),

                _ => const SizedBox.shrink(),
              },
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SERVICE CARD ----------------
  Widget _serviceCard({
    required BuildContext context,
    required VendorGetAllServicesModelData? service,
    required VendorServicesProvider provider,
  }) {
    return GestureDetector(
      onTap: () async {
        // provider.getServiceDetails(service?.id ?? "");
        // Navigate to Service Details Screen
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceCardDetailsScreen(),
          ),
        );
        if (result == null || result != null) {
          provider.getAllBookings();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImage(
                    path:
                        '${AppUrls.imageBaseUrl}${service?.serviceImage ?? ''}',
                    height: 70,
                    width: 70,
                  ),
                ),

                wBox(12),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service?.serviceName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.text_14_600(AppColors.darkText),
                      ),
                      hBox(2),
                      Text(
                        service?.category?.categoryName ?? '',
                        style: AppFontStyle.text_12_400(AppColors.primary),
                      ),
                      hBox(4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: AppColors.grey),
                          wBox(4),
                          Text(
                            '${service?.durationValue ?? ''} ${service?.durationType ?? ''}',
                            style: AppFontStyle.text_12_400(AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: service!.isActive
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service.isActive ? "Active" : "Inactive",
                    style: AppFontStyle.text_11_500(
                      service.isActive ? AppColors.primary : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),

            hBox(12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${service.servicePrice ?? ''}",
                  style: AppFontStyle.text_16_600(AppColors.primary),
                ),

                Row(
                  children: [
                    /// DELETE
                    CustomButton(
                      height: 36,
                      width: 90,
                      isOutlined: true,
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        _showDeleteDialog(context, provider, service);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(
                            path: ImageConstants.bin,
                            height: 14,
                            width: 14,
                            color: AppColors.red,
                          ),
                          wBox(6),
                          Text(
                            "Delete",
                            style: AppFontStyle.text_12_500(Colors.red),
                          ),
                        ],
                      ),
                    ),

                    wBox(8),

                    /// EDIT
                    CustomButton(
                      height: 36,
                      width: 90,
                      isOutlined: true,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(service,"Edit Service"),
                          ),
                        );
                        // provider.editService(service);
                        // Navigate to edit screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => EditServiceScreen(service: service)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(
                            path: ImageConstants.edit,
                            height: 14,
                            width: 14,
                            color: AppColors.primary,
                          ),
                          wBox(6),
                          Text(
                            "Edit",
                            style: AppFontStyle.text_12_500(AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Delete Confirmation Dialog
  void _showDeleteDialog(
    BuildContext context,
    VendorServicesProvider provider,
    VendorGetAllServicesModelData service,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Service',
            style: AppFontStyle.text_18_600(AppColors.darkText),
          ),
          content: Text(
            'Are you sure you want to delete "${service.serviceName ?? ''}"? This action cannot be undone.',
            style: AppFontStyle.text_14_400(AppColors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppFontStyle.text_14_500(AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await provider.deleteService(service.id ?? '');
                Navigator.pop(dialogContext);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('${service.title} deleted successfully'),
                //     backgroundColor: AppColors.red,
                //   ),
                // );
              },
              child: Text(
                'Delete',
                style: AppFontStyle.text_14_600(AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
