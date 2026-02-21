import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ozi/app/modules/user/profile/save%20address/provider/saved_address_provider.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/edit_user_address_provider.dart';

class EditUserAddressScreen extends StatefulWidget {
  const EditUserAddressScreen({super.key});

  @override
  State<EditUserAddressScreen> createState() => _EditUserAddressScreenState();
}

class _EditUserAddressScreenState extends State<EditUserAddressScreen> {
  LatLng? _lastCameraPosition;

  @override
  void initState() {
    super.initState();

    final savedProvider = context.read<SavedAddressProvider>();
    final editProvider = context.read<EditUserAddressProvider>();

    editProvider.init(savedProvider.editingAddress);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditUserAddressProvider>();

    if (!provider.initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Edit Address"),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Map Section
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target:
                                  provider.selectedLatLng ??
                                  provider.initialLocation,
                              zoom: 15,
                            ),
                            onMapCreated: provider.setMapController,
                            onCameraMove: (position) {
                              _lastCameraPosition = position.target;
                            },
                            onCameraIdle: () {
                              if (_lastCameraPosition != null && mounted) {
                                provider.onCameraIdle(_lastCameraPosition!);
                              }
                            },
                            onTap: provider.onMapTap,
                            markers: provider.markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                          ),

                          // Fixed Central Pin
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 35),
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 45,
                              ),
                            ),
                          ),

                          // Move to Current Location Button
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton(
                              onPressed: provider.moveToCurrentLocation,
                              backgroundColor: AppColors.primary,
                              mini: true,
                              child: Icon(
                                Icons.my_location,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Section
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: REdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery details",
                                style: AppFontStyle.text_14_600(
                                  AppColors.black,
                                ),
                              ),
                              hBox(15),

                              CustomTextFormField(
                                controller: provider.streetController,
                                label: "House No, Street Name*",
                                borderRadius: 12,
                              ),
                              hBox(15),

                              CustomTextFormField(
                                controller: provider.apartmentController,
                                label: "Apartment / Area / Landmark (Optional)",
                                borderRadius: 12,
                              ),
                              hBox(15),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: provider.cityController,
                                      label: "City*",
                                      borderRadius: 12,
                                    ),
                                  ),
                                  wBox(10),
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: provider.zipController,
                                      label: "ZIP Code*",
                                      borderRadius: 12,
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              hBox(20),

                              Text(
                                "Save address as",
                                style: AppFontStyle.text_14_600(
                                  AppColors.black,
                                ),
                              ),
                              hBox(12),
                              Row(
                                children: [
                                  _typeTile(
                                    "Home",
                                    ImageConstants.home2,
                                    0,
                                    provider.selectedType == 0,
                                  ),
                                  wBox(10),
                                  _typeTile(
                                    "Work",
                                    ImageConstants.work,
                                    1,
                                    provider.selectedType == 1,
                                  ),
                                  wBox(10),
                                  _typeTile(
                                    "Other",
                                    ImageConstants.location,
                                    2,
                                    provider.selectedType == 2,
                                  ),
                                ],
                              ),
                              hBox(25),

                              CustomButton(
                                text: provider.isLoading
                                    ? "Saving..."
                                    : "Save Address",
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        final success = await provider
                                            .updateAddress(context);
                                        if (success && context.mounted) {
                                          context
                                              .read<SavedAddressProvider>()
                                              .fetchUserAddresses();
                                          Navigator.pop(context, true);
                                        }
                                      },
                              ),
                              hBox(20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeTile(String title, String imagePath, int index, bool isSelected) {
    final provider = context.read<EditUserAddressProvider>();

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.updateType(index),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.containerBorder,
              width: isSelected ? 1.5 : 1,
            ),
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: imagePath,
                color: isSelected ? AppColors.primary : AppColors.grey,
                height: 16,
                width: 16,
              ),
              wBox(6),
              Text(
                title,
                style: AppFontStyle.text_13_500(
                  isSelected ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
