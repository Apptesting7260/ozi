import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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

  // @override
  // void initState() {
  //   super.initState();
  //   // Move to current location on start
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<AddAddressProvider>().moveToCurrentLocation();
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await setLocaleIdentifier("en_IN"); // or "en_US" or "hi_IN" etc.
      } catch (e) {
        debugPrint("setLocaleIdentifier failed: $e");
      }
      await context.read<AddAddressProvider>().moveToCurrentLocation();
      // Extra safety: agar upar wala fail bhi ho jaye to bhi try karo
      if (context.read<AddAddressProvider>().selectedLatLng != null) {
        await context.read<AddAddressProvider>().onCameraIdle(
          context.read<AddAddressProvider>().selectedLatLng!,
        );
      }
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
                                onTap: () {
                                  showCustomLocationBottomSheet(
                                    context,

                                    provider,
                                  );
                                },
                              ),
                              hBox(15), // Apartment
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
                              hBox(20),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: provider.isDefaultAddress,
                                      onChanged: provider.toggleDefaultAddress,
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  wBox(10),
                                  GestureDetector(
                                    onTap: () => provider.toggleDefaultAddress(
                                      !provider.isDefaultAddress,
                                    ),
                                    child: Text(
                                      "Set as default address",
                                      style: AppFontStyle.text_14_500(
                                        AppColors.black,
                                      ),
                                    ),
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

  void showCustomLocationBottomSheet(
    BuildContext context,
    AddAddressProvider provider,
  ) {
    final searchCtrl = TextEditingController(
      text: provider.streetAddressController.text.trim(),
    );
    List<Prediction> predictions = [];
    bool isLoading = false;
    bool isClosed = false;
    Timer? debounceTimer;

    Future<void> fetchSuggestions(
      String input,
      void Function(VoidCallback fn) setModalStateWrapper,
    ) async {
      if (isClosed || !context.mounted) return;

      setModalStateWrapper(() => isLoading = true);

      try {
        final String baseUrl =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json';
        final String locationParam = provider.selectedLatLng != null
            ? '&location=${provider.selectedLatLng!.latitude},${provider.selectedLatLng!.longitude}&radius=50000&strictbounds=false'
            : '';

        String effectiveInput = input.isEmpty ? "near" : input;

        final uri = Uri.parse(
          '$baseUrl?input=${Uri.encodeComponent(effectiveInput)}'
          '&key=AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ'
          '&components=country:in'
          '&language=en'
          '$locationParam'
          '&types=geocode|establishment',
        );

        final response = await http.get(uri);

        if (isClosed || !context.mounted) return;

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          if (json['status'] == 'OK') {
            final List<Prediction> newPreds = (json['predictions'] as List)
                .map((p) => Prediction.fromJson(p))
                .toList();

            setModalStateWrapper(() {
              predictions.clear();
              predictions.addAll(newPreds);
              isLoading = false;
            });
          } else {
            setModalStateWrapper(() {
              predictions.clear();
              isLoading = false;
            });
          }
        }
      } catch (e) {
        if (isClosed || !context.mounted) return;
        setModalStateWrapper(() {
          predictions.clear();
          isLoading = false;
        });
      }
    }

    bool isInitialFetchDone = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            // Load default suggestions when sheet opens ONLY ONCE
            if (!isInitialFetchDone) {
              isInitialFetchDone = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!sheetContext.mounted || isClosed) return;
                fetchSuggestions(searchCtrl.text, setModalState);
              });
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.92,
              minChildSize: 0.55,
              maxChildSize: 0.95,
              expand: false,
              builder: (innerContext, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(sheetContext),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Select delivery location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: isClosed ? null : searchCtrl,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search area, street name, landmark...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            debounceTimer?.cancel();
                            debounceTimer = Timer(
                              const Duration(milliseconds: 800),
                              () {
                                if (isClosed || !sheetContext.mounted) return;
                                fetchSuggestions(value, setModalState);
                              },
                            );
                          },
                        ),
                      ),

                      Expanded(
                        child: isLoading && predictions.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : predictions.isEmpty
                            ? Center(
                                child: Text(
                                  searchCtrl.text.isEmpty
                                      ? "Showing nearby places..."
                                      : "No results found – try different keyword",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: predictions.length,
                                itemBuilder: (ctx, i) {
                                  final pred = predictions[i];
                                  final main =
                                      pred.description?.split(', ').first ??
                                      pred.description ??
                                      "Unknown";
                                  final sub =
                                      pred.description
                                          ?.split(', ')
                                          .skip(1)
                                          .join(', ') ??
                                      "";

                                  return ListTile(
                                    key: ValueKey(
                                      pred.placeId ??
                                          pred.description ??
                                          i.toString(),
                                    ),
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 28,
                                    ),
                                    title: Text(
                                      main,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      sub,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () async {
                                      if (isClosed || !sheetContext.mounted)
                                        return;

                                      debounceTimer?.cancel();

                                      // Copy description before closing/clearing anything
                                      final selectedDescription =
                                          pred.description ?? "";

                                      // Close sheet first
                                      Navigator.pop(sheetContext);

                                      // Update provider after pop
                                      provider.streetAddressController.text =
                                          selectedDescription;
                                      await provider.selectManualPlace(pred);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      isClosed = true;
      debounceTimer?.cancel();
      debounceTimer = null;
      // Use a small delay for disposal to ensure all rebuilds finish
      Future.delayed(const Duration(milliseconds: 300), () {
        searchCtrl.dispose();
      });
    });
  }
  //   void showCustomLocationBottomSheet(
  //     BuildContext context,
  //     AddAddressProvider provider,
  //   ) {
  //     final TextEditingController searchCtrl = TextEditingController(
  //       text: provider.streetAddressController.text
  //           .trim(), // ← Auto-fill from main TextField
  //     );

  //     List<Prediction> predictions = [];
  //     bool isLoading = false;

  //     Timer? debounceTimer;
  //     bool _isBottomSheetClosed = false;
  //     // Fetch function
  //     Future<void> fetchSuggestions(
  //       String input,
  //       void Function(VoidCallback) setModalState,
  //     ) async {
  //       if (!context.mounted || _isBottomSheetClosed) return;

  //       setModalState(() => isLoading = true);

  //       try {
  //         final String baseUrl =
  //             'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //         final String locationParam = provider.selectedLatLng != null
  //             ? '&location=${provider.selectedLatLng!.latitude},${provider.selectedLatLng!.longitude}&radius=50000&strictbounds=false'
  //             : '';

  //         // Agar input empty hai to default nearby ke liye kuch bias keyword add kar sakte ho
  //         String effectiveInput = input.isEmpty
  //             ? "near"
  //             : input; // "near" ya "" try karo – better results

  //         final uri = Uri.parse(
  //           '$baseUrl?input=${Uri.encodeComponent(effectiveInput)}'
  //           '&key=AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ'
  //           '&components=country:in'
  //           '&language=en'
  //           '$locationParam'
  //           '&types=geocode|establishment', // Addresses + places
  //         );

  //         print(
  //           "Fetching URL: $uri",
  //         ); // Debug – console mein check karo kya request ja rahi

  //         final response = await http.get(uri);

  //         if (!context.mounted) return;

  //         if (response.statusCode == 200) {
  //           final json = jsonDecode(response.body);
  //           print(
  //             "API Response: ${json['status']} - Predictions: ${json['predictions']?.length ?? 0}",
  //           );

  //           if (json['status'] == 'OK') {
  //             final List<Prediction> newPreds = (json['predictions'] as List)
  //                 .map((p) => Prediction.fromJson(p))
  //                 .toList();
  // if (_isBottomSheetClosed || !modalContext.mounted) return;
  //             setModalState(() {
  //               predictions = newPreds;
  //               isLoading = false;
  //             });
  //           } else {
  //             setModalState(() {
  //               predictions = [];
  //               isLoading = false;
  //             });
  //             print("API Error: ${json['error_message'] ?? 'Unknown'}");
  //           }
  //         } else {
  //           print("HTTP Error: ${response.statusCode}");
  //         }
  //       } catch (e) {
  //         print("Fetch error: $e");
  //         if (context.mounted) {
  //           setModalState(() {
  //             predictions = [];
  //             isLoading = false;
  //           });
  //         }
  //       }
  //     }

  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (modalContext) {
  //         return StatefulBuilder(
  //           builder: (modalContext, setModalState) {
  //             // Open hone pe default fetch (nearby)
  //             WidgetsBinding.instance.addPostFrameCallback((_) async {
  //               if (modalContext.mounted) {
  //                 await fetchSuggestions(
  //                   searchCtrl.text,
  //                   setModalState,
  //                 ); // current text se start
  //               }
  //             });

  //             return DraggableScrollableSheet(
  //               initialChildSize: 0.92,
  //               minChildSize: 0.55,
  //               maxChildSize: 0.95,
  //               expand: false,
  //               builder: (context, scrollController) {
  //                 return Container(
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xFF1E1E1E),
  //                     borderRadius: BorderRadius.vertical(
  //                       top: Radius.circular(24),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       // Header
  //                       Padding(
  //                         padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
  //                         child: Row(
  //                           children: [
  //                             IconButton(
  //                               icon: const Icon(
  //                                 Icons.arrow_back,
  //                                 color: Colors.white,
  //                               ),
  //                               onPressed: () => Navigator.pop(modalContext),
  //                             ),
  //                             const SizedBox(width: 8),
  //                             const Expanded(
  //                               child: Text(
  //                                 "Select delivery location",
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),

  //                       // Search field (auto-filled)
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 8,
  //                         ),
  //                         child: TextField(
  //                           controller: searchCtrl,
  //                           autofocus: true,
  //                           style: const TextStyle(color: Colors.white),
  //                           decoration: InputDecoration(
  //                             hintText: "Search area, street name, landmark...",
  //                             hintStyle: TextStyle(color: Colors.grey[400]),
  //                             prefixIcon: const Icon(
  //                               Icons.search,
  //                               color: Colors.white70,
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.grey[850],
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                               borderSide: BorderSide.none,
  //                             ),
  //                           ),
  //                           onChanged: (value) {
  //                             debounceTimer?.cancel();
  //                             debounceTimer = Timer(
  //                               const Duration(milliseconds: 600),
  //                               () {
  //                                 if (modalContext.mounted) {
  //                                   fetchSuggestions(value, setModalState);
  //                                 }
  //                               },
  //                             );
  //                           },
  //                         ),
  //                       ),

  //                       Expanded(
  //                         child: isLoading
  //                             ? const Center(
  //                                 child: CircularProgressIndicator(
  //                                   color: Colors.white,
  //                                 ),
  //                               )
  //                             : predictions.isEmpty
  //                             ? Center(
  //                                 child: Text(
  //                                   searchCtrl.text.isEmpty
  //                                       ? "Showing nearby places..."
  //                                       : "No results found – try different keyword",
  //                                   style: TextStyle(
  //                                     color: Colors.grey[400],
  //                                     fontSize: 16,
  //                                   ),
  //                                 ),
  //                               )
  //                             : ListView.builder(
  //                                 controller: scrollController,
  //                                 itemCount: predictions.length,
  //                                 itemBuilder: (ctx, i) {
  //                                   final pred = predictions[i];
  //                                   final main =
  //                                       pred.description?.split(', ').first ??
  //                                       pred.description ??
  //                                       "Unknown";
  //                                   final sub =
  //                                       pred.description
  //                                           ?.split(', ')
  //                                           .skip(1)
  //                                           .join(', ') ??
  //                                       "";

  //                                   return ListTile(
  //                                     key: ValueKey(
  //                                       pred.placeId ??
  //                                           pred.description ??
  //                                           i.toString(),
  //                                     ),
  //                                     leading: const Icon(
  //                                       Icons.location_on,
  //                                       color: Colors.white70,
  //                                       size: 28,
  //                                     ),
  //                                     title: Text(
  //                                       main,
  //                                       style: const TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.w500,
  //                                       ),
  //                                     ),
  //                                     subtitle: Text(
  //                                       sub,
  //                                       style: TextStyle(
  //                                         color: Colors.grey[400],
  //                                         fontSize: 13,
  //                                       ),
  //                                       maxLines: 2,
  //                                       overflow: TextOverflow.ellipsis,
  //                                     ),
  //                                     onTap: () async {
  //                                       if (!modalContext.mounted) return;
  //                                       provider.streetAddressController.text =
  //                                           pred.description ?? "";
  //                                       await provider.selectManualPlace(pred);
  //                                       if (modalContext.mounted) {
  //                                         Navigator.pop(modalContext);
  //                                       }
  //                                     },
  //                                   );
  //                                 },
  //                               ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       },
  //     ).whenComplete(() {
  //       _isBottomSheetClosed = true;
  //       searchCtrl.dispose();
  //       debounceTimer?.cancel();
  //       debounceTimer = null;
  //     });
  //   }

  //   AddAddressProvider provider,
  // ) {
  //   final TextEditingController searchCtrl = TextEditingController();
  //   final List<Prediction> predictions = []; // local state for suggestions
  //   bool isLoading = false;

  //   // Debounce timer
  //   Timer? debounceTimer;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           return DraggableScrollableSheet(
  //             initialChildSize: 0.92,
  //             minChildSize: 0.55,
  //             maxChildSize: 0.95,
  //             expand: false,
  //             builder: (context, scrollController) {
  //               return Container(
  //                 decoration: const BoxDecoration(
  //                   color: Color(0xFF1E1E1E), // dark background like screenshot
  //                   borderRadius: BorderRadius.vertical(
  //                     top: Radius.circular(24),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     // Header
  //                     Padding(
  //                       padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
  //                       child: Row(
  //                         children: [
  //                           IconButton(
  //                             icon: const Icon(
  //                               Icons.arrow_back,
  //                               color: Colors.white,
  //                             ),
  //                             onPressed: () => Navigator.pop(context),
  //                           ),
  //                           const SizedBox(width: 8),
  //                           const Expanded(
  //                             child: Text(
  //                               "Select delivery location",
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     // Search field
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 16,
  //                         vertical: 8,
  //                       ),
  //                       child: TextField(
  //                         controller: searchCtrl,
  //                         autofocus: true,
  //                         style: const TextStyle(color: Colors.white),
  //                         decoration: InputDecoration(
  //                           hintText: "Search area, street name, landmark...",
  //                           hintStyle: TextStyle(color: Colors.grey[400]),
  //                           prefixIcon: const Icon(
  //                             Icons.search,
  //                             color: Colors.white70,
  //                           ),
  //                           filled: true,
  //                           fillColor: Colors.grey[850],
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                             borderSide: BorderSide.none,
  //                           ),
  //                           contentPadding: const EdgeInsets.symmetric(
  //                             vertical: 4,
  //                           ),
  //                         ),
  //                         onChanged: (value) {
  //                           if (debounceTimer?.isActive ?? false) {
  //                             debounceTimer!.cancel();
  //                           }

  //                           debounceTimer = Timer(
  //                             const Duration(milliseconds: 500),
  //                             () async {
  //                               if (value.trim().isEmpty) {
  //                                 setModalState(() {
  //                                   predictions.clear();
  //                                   isLoading = false;
  //                                 });
  //                                 return;
  //                               }

  //                               setModalState(() => isLoading = true);

  //                               try {
  //                                 final uri = Uri.parse(
  //                                   'https://maps.googleapis.com/maps/api/place/autocomplete/json'
  //                                   '?input=${Uri.encodeComponent(value)}'
  //                                   '&key=AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ'
  //                                   '&components=country:in'
  //                                   '&language=en'
  //                                   '${provider.selectedLatLng != null ? '&location=${provider.selectedLatLng!.latitude},${provider.selectedLatLng!.longitude}&radius=50000' : ''}',
  //                                 );

  //                                 final response = await http.get(uri);
  //                                 if (response.statusCode == 200) {
  //                                   final json = jsonDecode(response.body);

  //                                   if (json['status'] == 'OK') {
  //                                     final List<Prediction> newPreds =
  //                                         (json['predictions'] as List)
  //                                             .map(
  //                                               (p) => Prediction.fromJson(p),
  //                                             )
  //                                             .toList();

  //                                     setModalState(() {
  //                                       predictions.clear();
  //                                       predictions.addAll(newPreds);
  //                                       isLoading = false;
  //                                     });
  //                                   } else {
  //                                     setModalState(() {
  //                                       predictions.clear();
  //                                       isLoading = false;
  //                                     });
  //                                   }
  //                                 }
  //                               } catch (e) {
  //                                 print("Autocomplete error: $e");
  //                                 setModalState(() {
  //                                   predictions.clear();
  //                                   isLoading = false;
  //                                 });
  //                               }
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ),

  //                     // Results or loading
  //                     Expanded(
  //                       child: isLoading
  //                           ? const Center(
  //                               child: CircularProgressIndicator(
  //                                 color: Colors.white,
  //                               ),
  //                             )
  //                           : predictions.isEmpty
  //                           ? Center(
  //                               child: Text(
  //                                 searchCtrl.text.isEmpty
  //                                     ? "Start typing to search"
  //                                     : "No results found",
  //                                 style: TextStyle(
  //                                   color: Colors.grey[400],
  //                                   fontSize: 16,
  //                                 ),
  //                               ),
  //                             )
  //                           : ListView.builder(
  //                               controller: scrollController,
  //                               itemCount: predictions.length,
  //                               itemBuilder: (ctx, i) {
  //                                 final pred = predictions[i];
  //                                 return ListTile(
  //                                   leading: const Icon(
  //                                     Icons.location_on,
  //                                     color: Colors.white70,
  //                                     size: 28,
  //                                   ),
  //                                   title: Text(
  //                                     pred.description?.split(', ').first ??
  //                                         "Unknown",
  //                                     style: const TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                   subtitle: Text(
  //                                     pred.description
  //                                             ?.split(', ')
  //                                             .skip(1)
  //                                             .join(', ') ??
  //                                         "",
  //                                     style: TextStyle(
  //                                       color: Colors.grey[400],
  //                                       fontSize: 13,
  //                                     ),
  //                                     maxLines: 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                   onTap: () async {
  //                                     // Select this place
  //                                     await provider.selectManualPlace(pred);
  //                                     if (context.mounted) {
  //                                       Navigator.pop(context);
  //                                     }
  //                                   },
  //                                 );
  //                               },
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   ).whenComplete(() {
  //     searchCtrl.dispose();
  //     debounceTimer?.cancel();
  //   });
  // }
}
