import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:ozi/app/core/constants/app_urls.dart';
import '../../../../../core/appExports/app_export.dart';
import '../provider/location_picker_provider.dart';

class MapPickerPage extends StatefulWidget {
  final bool? isFromProfile;
  const MapPickerPage({super.key, this.isFromProfile});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocationPickerProvider>(
        context,
        listen: false,
      );
      provider.moveToCurrentLocation(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationPickerProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              'Select Delivery Location',
              style: AppFontStyle.text_18_600(
                AppColors.white,
                fontFamily: AppFontFamily.semiBold,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: provider.selectedLatLng,
                  zoom: 16,
                ),
                onMapCreated: provider.setController,
                onCameraMove: provider.onCameraMove,
                onCameraIdle: provider.onCameraIdle,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),

              // Center pin
              const Center(
                child: Icon(Icons.location_pin, size: 42, color: Colors.red),
              ),

              // Info banner
              //  Positioned(top: 16, left: 16, right: 16, child: _infoBanner()),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: _searchBar(provider),
              ),

              // Bottom panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomPanel(context, provider),
              ),

              Positioned(
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 170,

                child: Column(
                  children: [
                    _mapActionButton(
                      icon: Icons.my_location,
                      tooltip: 'Current Location',
                      onTap: () => provider.moveToCurrentLocation(context),
                    ),
                    const SizedBox(height: 12),
                    _mapActionButton(
                      icon: Icons.add,
                      tooltip: 'Zoom In',
                      onTap: provider.zoomIn,
                    ),
                    const SizedBox(height: 12),
                    _mapActionButton(
                      icon: Icons.remove,
                      tooltip: 'Zoom Out',
                      onTap: provider.zoomOut,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        elevation: 3,
        shape: const CircleBorder(),
        color: Colors.white,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 22, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _infoBanner() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Move the map to select your exact location',
                style: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(LocationPickerProvider provider) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _searchController,
        googleAPIKey: AppUrls.googlePlaceKey,
        debounceTime: 600,
        countries: const ["in"],
        isLatLngRequired: true,
        isCrossBtnShown: false,
        inputDecoration: InputDecoration(
          hintText: "Search location...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, _) {
              return value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // 1. Clear text immediately
                        _searchController.clear();
                        // 2. Clear provider state
                        provider.clearSearch();
                        // 3. Force a small delay before unfocusing to let the UI breathe
                        Future.delayed(Duration.zero, () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        getPlaceDetailWithLatLng: (prediction) {
          final lat = double.tryParse(prediction.lat ?? '');
          final lng = double.tryParse(prediction.lng ?? '');

          if (lat != null && lng != null) {
            // Use microtask to prevent the Map from blocking the UI thread
            Future.microtask(
              () => provider.moveToSearchedLocation(LatLng(lat, lng)),
            );
          }

          // Use .text to avoid selection/cursor conflicts during rapid typing
          _searchController.text = prediction.description ?? '';

          // Ensure keyboard closes only after the text is settled
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusManager.instance.primaryFocus?.unfocus();
          });
        },
        itemClick: (prediction) {
          _searchController.text = prediction.description ?? '';

          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusManager.instance.primaryFocus?.unfocus();
          });
        },
      ),
    );
  }
  // Widget _searchBar(LocationPickerProvider provider) {
  //   return Material(
  //     elevation: 4,
  //     borderRadius: BorderRadius.circular(12),
  //     child: GooglePlaceAutoCompleteTextField(
  //       textEditingController: _searchController,
  //       googleAPIKey: AppUrls.googlePlaceKey,
  //       debounceTime: 600,
  //       countries: const ["in"],
  //       isLatLngRequired: true,
  //       isCrossBtnShown: false,

  //       //  Use onChanged here instead of addListener in initState
  //       // This avoids full Consumer rebuild on every keystroke
  //       inputDecoration: InputDecoration(
  //         hintText: "Search location...",
  //         prefixIcon: const Icon(Icons.search),

  //         //  ValueListenableBuilder reads controller directly — no Provider rebuild
  //         suffixIcon: ValueListenableBuilder<TextEditingValue>(
  //           valueListenable: _searchController,
  //           builder: (context, value, _) {
  //             return value.text.isNotEmpty
  //                 ? IconButton(
  //                     icon: const Icon(Icons.close),
  //                     onPressed: () {
  //                       _searchController.clear();
  //                       provider.clearSearch();
  //                       //  FocusManager is more reliable than FocusScope for full dismiss
  //                       FocusManager.instance.primaryFocus?.unfocus();
  //                     },
  //                   )
  //                 : const SizedBox.shrink();
  //           },
  //         ),

  //         filled: true,
  //         fillColor: Colors.white,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),

  //       getPlaceDetailWithLatLng: (prediction) {
  //         final lat = double.tryParse(prediction.lat ?? '');
  //         final lng = double.tryParse(prediction.lng ?? '');

  //         if (lat != null && lng != null) {
  //           Future.microtask(() {
  //             provider.moveToSearchedLocation(LatLng(lat, lng));
  //           });
  //         }

  //         _searchController.value = TextEditingValue(
  //           text: prediction.description ?? '',
  //           selection: TextSelection.collapsed(
  //             offset: (prediction.description ?? '').length,
  //           ),
  //         );

  //         Future.delayed(const Duration(milliseconds: 100), () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //         });
  //       },

  //       itemClick: (prediction) {
  //         _searchController.value = TextEditingValue(
  //           text: prediction.description ?? '',
  //           selection: TextSelection.collapsed(
  //             offset: (prediction.description ?? '').length,
  //           ),
  //         );

  //         Future.delayed(const Duration(milliseconds: 100), () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget _bottomPanel(BuildContext context, LocationPickerProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.08)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selected Address',
            style: AppFontStyle.text_15_500(
              AppColors.black,
              fontFamily: AppFontFamily.semiBold,
            ),
          ),
          const SizedBox(height: 6),
          provider.isLoadingAddress
              ? Row(
                  children: const [
                    SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                  ],
                )
              : Text(
                  provider.address.isEmpty
                      ? 'Move map to select address'
                      : provider.address,
                  maxLines: 4,
                  overflow: TextOverflow.visible,
                  style: AppFontStyle.text_15_500(
                    AppColors.black,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: widget.isFromProfile == true
                ? () async {
                    final _ = await provider.updateLocationFromLatLng(
                      provider.selectedLatLng,
                    );
                    if (kDebugMode) {
                      print(
                        "Post Api Hit ==================================> ${provider.selectedLatLng}",
                      );
                    }
                    Navigator.pop(context);
                  }
                : () {
                    Navigator.pop(context, {
                      "latLng": provider.selectedLatLng,
                      "address": provider.address,
                      "city": provider.city,
                      "state": provider.state,
                      "country": provider.country,
                    });
                  },
            child: Container(
              color: AppColors.primary,
              width: double.infinity,
              height: 45,
              child: Center(
                child: Text(
                  'Confirm Location',
                  style: AppFontStyle.text_16_600(
                    AppColors.white,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
