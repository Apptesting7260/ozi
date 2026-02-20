import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ozi/app/modules/user/profile/save%20address/provider/saved_address_provider.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/add_address_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  LatLng? _lastCameraPosition;

  @override
  void initState() {
    super.initState();
    // Move to current location on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddAddressProvider>().moveToCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddAddressProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Select Delivery Location"),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Google Map Section
                Column(
                  children: [
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
                            // No markers needed in central pin mode
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

                          // Use Current Location Button overlay
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

                              // Street Address
                              CustomTextFormField(
                                controller: provider.streetAddressController,
                                label: "House No, Street Name*",
                                hintText: "e.g. 123, Blue Street",
                                borderRadius: 12,
                              ),
                              hBox(15),

                              // Apartment
                              CustomTextFormField(
                                controller: provider.apartmentController,
                                label: "Apartment / Area / Landmark (Optional)",
                                hintText: "e.g. Near Central Park",
                                borderRadius: 12,
                              ),
                              hBox(15),

                              // City and ZIP Code
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: provider.cityController,
                                      label: "City*",
                                      hintText: "City Name",
                                      borderRadius: 12,
                                    ),
                                  ),
                                  wBox(10),
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: provider.zipCodeController,
                                      label: "ZIP Code*",
                                      hintText: "123456",
                                      borderRadius: 12,
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              hBox(15),

                              // Country
                              CustomTextFormField(
                                controller: provider.countryController,
                                label: "Country / Country Code*",
                                hintText: "e.g. India or IN",
                                borderRadius: 12,
                              ),
                              hBox(20),

                              // Address type selection
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

                              // Save Button
                              CustomButton(
                                text: "Save Address",
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        bool success = await provider
                                            .addNewAddress(context);
                                        if (success && context.mounted) {
                                          context
                                              .read<SavedAddressProvider>()
                                              .fetchUserAddresses();
                                          Navigator.pop(context, true);
                                        }
                                      },
                                child: provider.isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : null,
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
    final provider = context.read<AddAddressProvider>();

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
