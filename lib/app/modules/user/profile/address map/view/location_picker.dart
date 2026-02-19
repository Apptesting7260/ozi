import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:provider/provider.dart';
import '../provider/location_picker_provider.dart';

class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationPickerProvider(),
      child: const _LocationPickerView(),
    );
  }
}

class _LocationPickerView extends StatelessWidget {
  const _LocationPickerView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationPickerProvider>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text("Select Location"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.9124, 75.7873), // Static Jaipur
              zoom: 15,
            ),
            onMapCreated: provider.setController,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            markers: provider.markers,
            onTap: provider.onTap,
          ),

          // Address Card
          if (provider.selectedAddress != null)
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.selectedAddress!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right Side Buttons
          Positioned(
            right: 15,
            bottom: 140,
            child: Column(
              children: [
                // Current Location
                FloatingActionButton(
                  heroTag: "current",
                  mini: true,
                  backgroundColor: AppColors.primary,
                  onPressed: provider.moveToCurrentLocation,
                  child: Icon(Icons.my_location,
                      color: AppColors.white),
                ),
                const SizedBox(height: 12),

                // Zoom In
                FloatingActionButton(
                  heroTag: "zoomIn",
                  mini: true,
                  backgroundColor: AppColors.primary,
                  onPressed: provider.zoomIn,
                  child: Icon(Icons.add,
                      color: AppColors.white),
                ),
                const SizedBox(height: 12),

                // Zoom Out
                FloatingActionButton(
                  heroTag: "zoomOut",
                  mini: true,
                  backgroundColor: AppColors.primary,
                  onPressed: provider.zoomOut,
                  child: Icon(Icons.remove,
                      color: AppColors.white),
                ),
              ],
            ),
          ),

          // Confirm Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: provider.selectedLatLng == null
                  ? null
                  : () {
                Navigator.pop(
                  context,
                  provider.selectedLatLng, // return latlng
                );
              },

              child: const Text(
                "Confirm Location",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
