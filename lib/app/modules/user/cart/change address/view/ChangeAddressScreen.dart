import 'package:ozi/app/modules/user/profile/add%20new%20address/view/add_address_screen.dart';
import 'package:ozi/app/routes/app_routes.dart';
import 'package:ozi/app/shared/widgets/custom_shimmer_box.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/ChangeAddressProvider.dart';
import '../../../../../core/utils/location_permission_helper.dart';

class ChangeAddressScreen extends StatefulWidget {
  final bool isFromHome;
  const ChangeAddressScreen({super.key, this.isFromHome = false});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChangeAddressProvider>();
      provider.fetchUserAddresses();
      if (provider.selectedIndex == -1) {
        provider.useCurrentLocation(); // Default only if nothing selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeAddressProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Select Delivery Address"),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => await provider.fetchUserAddresses(),
                child: provider.isLoading
                    ? ListView(
                        padding: const EdgeInsets.all(16),
                        children: List.generate(
                          4,
                          (_) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ShimmerBox(
                              width: double.infinity,
                              height: 90,
                              radius: 14,
                            ),
                          ),
                        ),
                      )
                    : ListView(
                        padding: REdgeInsets.all(16),
                        children: [
                          // Always show Current Location as first tile
                          _currentLocationTile(provider),
                          SizedBox(height: 12),

                          // Saved addresses (if any)
                          ...List.generate(provider.addresses.length, (index) {
                            final address = provider.addresses[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _addressTile(
                                provider: provider,
                                index: index,
                                selected: provider.selectedIndex == index,
                                title: address.addressType ?? 'Other',
                                tag: address.isDefault == true
                                    ? 'Default'
                                    : null,
                                icon: provider.getIconForAddressType(
                                  address.addressType,
                                ),
                                address: provider.getFormattedAddress(address),
                                onTap: () {
                                  provider.selectAddress(index); // saved index
                                },
                              ),
                            );
                          }),

                          SizedBox(height: 16),

                          // Add new address button (always visible)
                          CustomButton(
                            text: "+ Add New Address",
                            isOutlined: true,
                            onPressed: () async {
                              if (await LocationPermissionHelper.handleLocationPermission(
                                context,
                              )) {
                                if (context.mounted) {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.addAddressScreen,
                                  );
                                  if (result == true) {
                                    provider.fetchUserAddresses();
                                  }
                                }
                              }
                            },
                            height: 56,
                            borderRadius: BorderRadius.circular(60),
                          ),

                          SizedBox(height: 24),
                        ],
                      ),
              ),
            ),

            // Always visible Continue button at bottom
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: CustomButton(
                text: "Continue",
                onPressed: () {
                  if (provider.selectedIndex == -2) {
                    // Current location selected
                    Navigator.pop(context, -2); // or some flag for current
                  } else if (provider.selectedIndex >= 0) {
                    // Saved address selected
                    Navigator.pop(context, provider.selectedIndex);
                  }
                },
                height: 56,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentLocationTile(ChangeAddressProvider provider) {
    final bool selected = provider.selectedIndex == -2;

    return GestureDetector(
      onTap: () {
        provider.useCurrentLocation();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.containerBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.20),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: provider.isLocationLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : CustomImage(
                      path: ImageConstants
                          .location, // or better: current_location icon
                      color: selected ? AppColors.white : AppColors.primary,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Use Current Location",
                        style: AppFontStyle.text_16_600(
                          selected ? AppColors.primary : AppColors.black,
                        ),
                      ),
                      if (selected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Live",
                            style: AppFontStyle.text_12_500(AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.currentLocationAddress ?? "Detecting location...",
                    style: AppFontStyle.text_13_400(AppColors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressTile({
    required ChangeAddressProvider provider,
    required int index,
    required bool selected,
    required String title,
    required String address,
    required String icon,
    String? tag,

    bool isCurrent = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.containerBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.20),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: CustomImage(
                path: icon,
                color: selected ? AppColors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppFontStyle.text_16_600(AppColors.black),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          tag,
                          style: AppFontStyle.text_12_500(AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.isNotEmpty ? address : 'No address details',
                    style: AppFontStyle.text_13_400(AppColors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
