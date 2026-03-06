import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/appExports/app_export.dart';
import '../provider/location_picker_provider.dart';

class MapPickerPage extends StatefulWidget {
  final bool? isFromProfile;
  const MapPickerPage({super.key, this.isFromProfile});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocationPickerProvider>(
        context,
        listen: false,
      );
      provider.moveToCurrentLocation(context);
    });
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
              Positioned(top: 16, left: 16, right: 16, child: _infoBanner()),

              // Bottom panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomPanel(context, provider),
              ),

              // Floating buttons
              Positioned(
                right: 16,
                bottom: 150,
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
                    const SizedBox(height: 12),
                    _mapActionButton(
                      icon: Icons.help_outline,
                      tooltip: 'Help',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              'How to select location',
                              style: AppFontStyle.text_18_600(
                                AppColors.black,
                                fontFamily: AppFontFamily.bold,
                              ),
                            ),
                            content: Text(
                              'Drag the map or use the buttons to position the pin on your location. '
                              'You can also use the current location button.',
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: AppFontStyle.text_14_400(
                                AppColors.black,
                                fontFamily: AppFontFamily.semiBold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Got it',
                                  style: AppFontStyle.text_14_400(
                                    AppColors.primary,
                                    fontFamily: AppFontFamily.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                    Navigator.pop(context, provider.selectedLatLng);
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
