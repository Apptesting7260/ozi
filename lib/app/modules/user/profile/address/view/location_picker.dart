import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ozi/app/core/appExports/app_export.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _controller;

  LatLng? _selectedLatLng;
  String? _selectedAddress;

  final Set<Marker> _markers = {};

  /// When user taps map
  Future<void> _onTap(LatLng latLng) async {
    setState(() {
      _selectedLatLng = latLng;
      _selectedAddress = "Fetching address...";
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("selected"),
          position: latLng,
          infoWindow: const InfoWindow(title: "Selected Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    });

    _controller?.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          _selectedAddress =
          "${place.name ?? ''}, "
              "${place.street ?? ''}, "
              "${place.locality ?? ''}, "
              "${place.administrativeArea ?? ''}, "
              "${place.postalCode ?? ''}, "
              "${place.country ?? ''}";
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Unable to fetch address";
      });
    }
  }

  void _zoomIn() {
    _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _controller?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Select Location"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.9124, 75.7873),
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _controller = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: true,
            markers: _markers,
            onTap: _onTap,
          ),

          // Address Display Box
          if (_selectedAddress != null)
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: Text(
                  _selectedAddress!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Zoom Buttons
          Positioned(
            right: 15,
            bottom: 130,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor:AppColors.primary,
                  mini: true,
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  child:  Icon(Icons.add,color:AppColors.white,),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor:AppColors.primary,
                  mini: true,
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  child:  Icon(Icons.remove,color:AppColors.white,),
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _selectedLatLng == null
                  ? null
                  : () {
                //  Returns LatLng to previous screen
                Navigator.pop(context, _selectedLatLng);
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
