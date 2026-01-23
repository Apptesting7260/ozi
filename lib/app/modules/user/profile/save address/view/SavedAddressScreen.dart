import '../../../../../core/appExports/app_export.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_shimmer_box.dart';
import '../provider/saved_address_provider.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedAddressProvider>().fetchUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedAddressProvider>();

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Saved Addresses"),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await provider.fetchUserAddresses();
              },
              child: provider.isLoading
                  ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...List.generate(
                    3,
                        (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ShimmerBox(
                        width: double.infinity,
                        height: 90,
                        radius: 14,
                      ),
                    ),
                  ),
                ],
              )
                  : provider.errorMessage.isNotEmpty &&
                  provider.addresses.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 60, color: AppColors.grey),
                      SizedBox(height: 16),
                      Text(
                        provider.errorMessage,
                        style: AppFontStyle.text_14_400(AppColors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      CustomButton(
                        text: "Retry",
                        onPressed: () {
                          provider.fetchUserAddresses();
                        },
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ],
                  ),
                ),
              )
                  : provider.addresses.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 60, color: AppColors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No saved addresses',
                        style: AppFontStyle.text_16_600(
                            AppColors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your first address to get started',
                        style: AppFontStyle.text_14_400(
                            AppColors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: "+ Add New Address",
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.addAddressScreen,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView(
                padding: REdgeInsets.all(16),
                children: [
                  ...List.generate(
                    provider.addresses.length,
                        (index) {
                      final address = provider.addresses[index];
                      return _addressTile(
                        provider: provider,
                        index: index,
                        selected: provider.selectedIndex == index,
                        title: address.addressType ?? 'Other',
                        tag: address.isDefault == 1 ? 'Default' : null,
                        icon: provider.getIconForAddressType(
                            address.addressType),
                        address:
                        provider.getFormattedAddress(address),
                        onTap: () {
                          provider.selectAddress(index);
                        },
                        onEdit: () {
                          // Set the address to edit
                          provider.setEditingAddress(address);

                          // Navigate to edit screen
                          Navigator.pushNamed(
                            context,
                            AppRoutes.editAddressScreen,
                          ).then((_) {
                            // Refresh addresses when coming back
                            provider.fetchUserAddresses();
                          });
                        },
                        onDelete: () {
                          provider.deleteAddress(index, context);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  CustomButton(
                    text: "+ Add New Address",
                    isOutlined: true,
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.addAddressScreen),
                    height: 56,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ],
              ),
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
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(.08)
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
            /// ICON CONTAINER
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(.20),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(12),
              child: CustomImage(
                path: icon,
                color: selected ? AppColors.white : AppColors.primary,
              ),
            ),

            SizedBox(width: 14),

            /// TITLE + ADDRESS
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
                      if (tag != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            tag,
                            style: AppFontStyle.text_12_500(AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    address.isNotEmpty ? address : 'No address details',
                    style: AppFontStyle.text_13_400(AppColors.grey),
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            /// ICONS
            Row(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: CustomImage(path: ImageConstants.edit),
                ),
                SizedBox(width: 16),
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