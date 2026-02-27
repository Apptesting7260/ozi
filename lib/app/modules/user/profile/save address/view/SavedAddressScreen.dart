// import '../../../../../core/appExports/app_export.dart';
// import '../../../../../routes/app_routes.dart';
// import '../../../../../shared/widgets/custom_app_bar.dart';
// import '../../../../../shared/widgets/custom_shimmer_box.dart';
// import '../provider/saved_address_provider.dart';

// class SavedAddressScreen extends StatefulWidget {
//   const SavedAddressScreen({super.key});

//   @override
//   State<SavedAddressScreen> createState() => _SavedAddressScreenState();
// }

// class _SavedAddressScreenState extends State<SavedAddressScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SavedAddressProvider>().fetchUserAddresses();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SavedAddressProvider>();

//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppBar(title: "Saved Addresses"),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 await provider.fetchUserAddresses();
//               },
//               child: provider.isLoading
//                   ? ListView(
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         ...List.generate(
//                           3,
//                           (_) => Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: ShimmerBox(
//                               width: double.infinity,
//                               height: 90,
//                               radius: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : provider.errorMessage.isNotEmpty &&
//                         provider.addresses.isEmpty
//                   ? Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.location_off_outlined,
//                               size: 60,
//                               color: AppColors.grey,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               provider.errorMessage,
//                               style: AppFontStyle.text_14_400(AppColors.grey),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 16),
//                             CustomButton(
//                               text: "Retry",
//                               onPressed: () {
//                                 provider.fetchUserAddresses();
//                               },
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : provider.addresses.isEmpty
//                   ? Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.location_off_outlined,
//                               size: 60,
//                               color: AppColors.grey,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'No saved addresses',
//                               style: AppFontStyle.text_16_600(AppColors.black),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Add your first address to get started',
//                               style: AppFontStyle.text_14_400(AppColors.grey),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 20),
//                             CustomButton(
//                               text: "+ Add New Address",
//                               onPressed: () => Navigator.pushNamed(
//                                 context,
//                                 AppRoutes.addAddressScreen,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : ListView(
//                       padding: REdgeInsets.all(16),
//                       children: [
//                         ...List.generate(provider.addresses.length, (index) {
//                           final address = provider.addresses[index];
//                           return _addressTile(
//                             provider: provider,
//                             index: index,
//                             selected: provider.selectedIndex == index,
//                             title: address.addressType ?? 'Other',
//                             tag: address.isDefault == 1 ? 'Default' : null,
//                             isDelete: address.isDefault == 1 ? true : false,
//                             icon: provider.getIconForAddressType(
//                               address.addressType,
//                             ),
//                             address: provider.getFormattedAddress(address),
//                             onTap: () {
//                               provider.selectAddress(index);
//                             },
//                             onEdit: () {
//                               // Set the address to edit
//                               provider.setEditingAddress(address);

//                               // Navigate to edit screen
//                               Navigator.pushNamed(
//                                 context,
//                                 AppRoutes.editAddressScreen,
//                               ).then((_) {
//                                 // Refresh addresses when coming back
//                                 provider.fetchUserAddresses();
//                               });
//                             },
//                             onDelete: () {
//                               provider.deleteAddress(index, context);
//                             },
//                           );
//                         }),
//                         SizedBox(height: 8),
//                         CustomButton(
//                           text: "+ Add New Address",
//                           isOutlined: true,
//                           onPressed: () => Navigator.pushNamed(
//                             context,
//                             AppRoutes.addAddressScreen,
//                           ),
//                           height: 56,
//                           borderRadius: BorderRadius.circular(60),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _addressTile({
//     required SavedAddressProvider provider,
//     required int index,
//     required bool selected,
//     required String title,
//     required String address,
//     required String icon,
//     String? tag,
//     bool? isDelete,
//     required VoidCallback onTap,
//     required VoidCallback onEdit,
//     required VoidCallback onDelete,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: selected
//               ? AppColors.primary.withOpacity(.08)
//               : AppColors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.containerBorder,
//             width: selected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ICON CONTAINER
//             Container(
//               height: 44,
//               width: 44,
//               decoration: BoxDecoration(
//                 color: selected
//                     ? AppColors.primary
//                     : AppColors.primary.withOpacity(.20),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: EdgeInsets.all(12),
//               child: CustomImage(
//                 path: icon,
//                 color: selected ? AppColors.white : AppColors.primary,
//               ),
//             ),

//             SizedBox(width: 14),

//             /// TITLE + ADDRESS
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         title,
//                         style: AppFontStyle.text_16_600(AppColors.black),
//                       ),
//                       if (tag != null)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             tag,
//                             style: AppFontStyle.text_12_500(AppColors.primary),
//                           ),
//                         ),
//                     ],
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     address.isNotEmpty ? address : 'No address details',
//                     style: AppFontStyle.text_13_400(AppColors.grey),
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(width: 12),

//             /// ICONS
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: onEdit,
//                   child: CustomImage(path: ImageConstants.edit),
//                 ),
//                 SizedBox(width: 16),
//                 GestureDetector(
//                   onTap: onDelete,
//                   child: isDelete != true
//                       ? CustomImage(path: ImageConstants.bin)
//                       : SizedBox(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      // By default select index 0 (Current Location)
      context.read<SavedAddressProvider>().selectAddress(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedAddressProvider>();

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Select Delivery Address"),

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
                        _addressTile(
                          provider: provider,
                          index: 0,
                          selected: provider.selectedIndex == 0,
                          title: "Current Location",
                          tag: "Live",
                          icon: "assets/images/proicons--location 2.png",
                          // ← adjust path
                          address:
                              provider.currentAddress ??
                              "Using GPS • Fetching your location...",
                          onTap: () {
                            provider.selectAddress(0);
                          },
                          onEdit: () {}, // no edit for current location
                          onDelete: () {}, // no delete for current location
                          isCurrent: true,
                        ),

                        SizedBox(height: 12),

                        // ───────────────────────────────────────────────
                        // Saved addresses from API (starting from index 1)
                        // ───────────────────────────────────────────────
                        ...List.generate(provider.addresses.length, (i) {
                          final realIndex = i + 1; // because 0 = current
                          final address = provider.addresses[i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _addressTile(
                              provider: provider,
                              index: realIndex,
                              selected: provider.selectedIndex == realIndex,
                              title: address.addressType ?? 'Other',
                              tag: address.isDefault == 1 ? 'Default' : null,
                              icon: provider.getIconForAddressType(
                                address.addressType,
                              ),
                              address: provider.getFormattedAddress(address),
                              onTap: () => provider.selectAddress(realIndex),
                              onEdit: () {
                                provider.setEditingAddress(address);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editAddressScreen,
                                ).then((_) => provider.fetchUserAddresses());
                              },
                              onDelete: () => provider.deleteAddress(
                                i,
                                context,
                              ), // original index
                              isDelete: address.isDefault == 1,
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
          // Always visible bottom button (Zomato style)
          // ───────────────────────────────────────────────
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
                // TODO: Your delivery flow / proceed logic here
                // Example: provider.selectedIndex == 0 → use current location
                // else use provider.addresses[selectedIndex - 1]
                Navigator.pop(context); // or go to next screen
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
