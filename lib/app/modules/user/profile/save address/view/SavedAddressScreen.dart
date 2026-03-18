import '../../../../../core/appExports/app_export.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_shimmer_box.dart';
import '../../edit address/provider/edit_user_address_provider.dart';
import '../../edit address/view/edit_user_address_screen.dart';
import '../provider/saved_address_provider.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({
    this.isservice = false,
    this.isHome = false,
    super.key,
  });

  final bool isservice;
  final bool isHome;

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isservice) {
        context.read<SavedAddressProvider>().fetchUserAddresses();
        // By default select -2 (Current Location) if nothing selected
        if (context.read<SavedAddressProvider>().selectedIndex == -1) {
          context.read<SavedAddressProvider>().selectAddress(-2);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedAddressProvider>();

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: widget.isservice
                ? "Select Service Address"
                : "Saved Addresses",
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await provider.fetchUserAddresses();
              },
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
                        // ───────────────────────────────────────────────
                        // Always show CURRENT LOCATION as first item
                        // ───────────────────────────────────────────────
                        if (!widget.isservice || widget.isHome) ...[
                          _addressTile(
                            provider: provider,
                            index: -2,
                            selected: provider.selectedIndex == -2,
                            title: "Current Location",
                            tag: "Live",
                            icon: "assets/images/proicons--location 2.png",
                            // ← adjust path
                            address:
                                provider.currentAddress ??
                                "Using GPS • Fetching your location...",
                            onTap: () {
                              provider.selectAddress(-2);
                            },
                            onEdit: () {}, // no edit for current location
                            onDelete: () {}, // no delete for current location
                            isCurrent: true,
                          ),
                        ],
                        SizedBox(height: 12),

                        // ───────────────────────────────────────────────
                        // Saved addresses from API (starting from index 1)
                        // ───────────────────────────────────────────────
                        ...List.generate(provider.addresses.length, (i) {
                          final address = provider.addresses[i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _addressTile(
                              provider: provider,
                              index: i,
                              selected: provider.selectedIndex == i,
                              title: address.addressType ?? 'Other',
                              tag: address.isDefault == true ? 'Default' : null,
                              icon: provider.getIconForAddressType(
                                address.addressType,
                              ),
                              address: provider.getFormattedAddress(address),
                              onTap: () {
                                provider.selectAddress(i);
                                if (widget.isservice) {
                                  Navigator.pop(context, i);
                                }
                              },
                              onEdit: () {
                                provider.setEditingAddress(address);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider.value(
                                          value: provider,
                                        ),
                                        ChangeNotifierProvider(
                                          create: (_) =>
                                              EditUserAddressProvider(),
                                        ),
                                      ],
                                      child: EditUserAddressScreen(
                                        lat: address.latitude,
                                        lng: address.longitude,
                                        receiverName: address.receiverName,
                                        receiverMobile: address.receiverMobile,
                                        countryCode:
                                            address.receiverCountryCode,
                                      ),
                                    ),
                                  ),
                                ).then((_) => provider.fetchUserAddresses());
                              },
                              onDelete: () => provider.deleteAddress(
                                i,
                                context,
                              ), // original index
                              isDelete: address.isDefault == true,
                            ),
                          );
                        }),

                        SizedBox(height: 16),

                        // Add new address button
                        CustomButton(
                          text: "+ Add New Address",
                          isOutlined: true,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.addAddressScreen,
                          ).then((_) => provider.fetchUserAddresses()),
                          height: 56,
                          borderRadius: BorderRadius.circular(60),
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
            ),
          ),

          // ───────────────────────────────────────────────
          // Always visible bottom button (only for non-service mode)
          // ───────────────────────────────────────────────
          if (!widget.isservice)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: CustomButton(
                text: "Continue",
                onPressed: () {
                  Navigator.pop(context, provider.selectedIndex);
                },
                height: 56,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
        ],
      ),
    );
  }

  Widget _addressTile({
    required SavedAddressProvider provider,
    required int index,
    required bool selected,
    required String title,
    required String address,
    required String icon,
    String? tag,
    bool? isDelete,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool isCurrent = false,
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
            // Icon
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10),
              child: CustomImage(
                path: icon,
                color: selected ? AppColors.white : AppColors.primary,
              ),
            ),

            const SizedBox(width: 14),

            // Title + Address
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: AppFontStyle.text_12_500(AppColors.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address,
                    style: AppFontStyle.text_13_400(AppColors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Actions (only for saved addresses)
            if (!isCurrent)
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: CustomImage(path: ImageConstants.edit),
                  ),
                  const SizedBox(width: 16),
                  if (isDelete != true)
                    GestureDetector(
                      onTap: onDelete,
                      child: CustomImage(path: ImageConstants.bin),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
