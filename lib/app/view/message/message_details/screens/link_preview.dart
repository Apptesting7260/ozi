// // import 'package:flutter/material.dart';
// // import 'package:flutter_link_previewer/flutter_link_previewer.dart';
// import 'package:flutter_chat_core/flutter_chat_core.dart' show LinkPreviewData;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_link_previewer/flutter_link_previewer.dart';
// import 'package:g_clout_media/core/appExports/app_export.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_link_previewer/flutter_link_previewer.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../../../Routes/app_routes.dart';
// import '../../../../../../utils/get_utils.dart';
// import '../../../../../features_lists/singleReel/screens/singlereelscreen.dart';
//
// class UrlPreviewWidget extends StatefulWidget {
//   final String url;
//   final double borderRadius;
//
//   const UrlPreviewWidget({
//     super.key,
//     required this.url,
//     this.borderRadius = 10,
//   });
//
//   @override
//   State<UrlPreviewWidget> createState() => _UrlPreviewWidgetState();
// }
//
// class _UrlPreviewWidgetState extends State<UrlPreviewWidget> {
//   LinkPreviewData? _linkPreviewData;
//
//   bool _isCustom = false;
//   String? _entityType;
//   String? _entityId;
//   String? _customTitle;
//   String? _customImage;
//
//   @override
//   void initState() {
//     super.initState();
//     _parseUrl(widget.url);
//   }
//
//   /// ---------------------------------------
//   /// Parse URL → Detect entityType/entityId
//   /// ---------------------------------------
//   void _parseUrl(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return;
//
//     // Example URL: /post/9ea1...
//     final segments = uri.pathSegments;
//
//     if (segments.length >= 2) {
//       final type = segments[0];
//       final id = segments[1];
//
//       if (["post", "reel", "profile"].contains(type)) {
//         _entityType = type;
//         _entityId = id;
//         _isCustom = true;
//
//         await _fetchCustomPreview(type, id);
//         // setState(() {});
//         return;
//       }
//     }
//
//     // Not a custom preview
//     _isCustom = false;
//   }
//
//   /// ---------------------------------------
//   /// Call API to fetch title/image
//   /// ---------------------------------------
//   Future<void> _fetchCustomPreview(String type, String id) async {
//     try {
//       final response =
//       await http.get(Uri.parse("${AppUrls.baseUrl}profile/$type/$id"));
//       print('url is ${AppUrls.baseUrl}profile/$type/$id');
//       print('response is ${response.statusCode} ${response.body}');
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print(data);
//         _customTitle = data?['data']?["title"] ?? "";
//         _customImage = data?['data']?["image"] ?? "";
//         setState(() {
//
//         });
//       }
//     } catch (e) {
//       print("Error fetching custom preview: $e");
//     }
//   }
//
//   /// ---------------------------------------
//   /// Navigate inside app (post / reel / profile)
//   /// ---------------------------------------
//   void _navigateInside() {
//     if (_entityType == null || _entityId == null) return;
//     navigateFromNotification(entityId: _entityId,entityType: _entityType??'');
//     // final ctx = Navigator.of(context);
//
//     // if (_entityType == "post") {
//     //   ctx.pushNamed("/singlePost", arguments: {"postId": _entityId});
//     // } else if (_entityType == "reel") {
//     //   ctx.pushNamed("/reelScreen", arguments: {"reelId": _entityId});
//     // } else if (_entityType == "profile") {
//     //   ctx.pushNamed("/userProfile", arguments: {"userId": _entityId});
//     // }
//   }
//
//   static Future<void> navigateFromNotification({
//     required String entityType,
//     required dynamic entityId,
//     Map<String, dynamic>? extraData,
//   }) async {
//
//     final context = navigatorKey.currentContext;
//
//     if (context == null) {
//       debugPrint("❌ navigatorKey context is null");
//       return;
//     }
//
//     debugPrint("🔀 Notification navigate: type=$entityType id=$entityId");
//
//     switch (entityType) {
//
//       case "reel":
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder:
//                 (context) => Singlereelscreen(
//               isFirstLoad: true,
//               reelId: entityId,
//             ),
//           ),
//         );
//         break;
//
//       case "post":
//         Navigator.pushNamed(
//           context,
//           AppRoutes.singlePost,
//           arguments: {'postId': entityId ?? ""},
//         );
//
//         break;
//
//       case "profile":
//         Navigator.pushNamed(
//           context,
//           AppRoutes.userProfileScreen,
//           arguments: entityId,
//         );
//         break;
//
//       default:
//         debugPrint("⚠ Unknown entityType: $entityType");
//         break;
//     }
//   }
//
//   /// ---------------------------------------
//   /// Open external URL
//   /// ---------------------------------------
//   void _openExternal() async {
//     final uri = Uri.parse(widget.url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   /// ---------------------------------------
//   /// On Tap Handler
//   /// ---------------------------------------
//   void _handleTap() {
//     print('is custome $_isCustom');
//     if (_isCustom) {
//       _navigateInside();
//     } else {
//       _openExternal();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Custom preview (API-based)
//     if (_isCustom && (_customTitle != null || _customImage != null)) {
//       return GestureDetector(
//         onTap: _handleTap,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (_customImage != null && _customImage!.isNotEmpty)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(widget.borderRadius),
//                   child: CustomImage(path:_customImage!, fit: BoxFit.contain,),
//                 ),
//               if (_customTitle != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(
//                     _customTitle!,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w200, fontSize: 8),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // Default preview (normal URL)
//     return GestureDetector(
//       onTap: _handleTap,
//       child: LinkPreview(
//         text: widget.url,
//         linkPreviewData: _linkPreviewData,
//         onLinkPreviewDataFetched: (data) {
//           setState(() => _linkPreviewData = data);
//         },
//         borderRadius: widget.borderRadius,
//         insidePadding: const EdgeInsets.all(10),
//         outsidePadding: const EdgeInsets.symmetric(vertical: 6),
//         titleTextStyle:
//         const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//     );
//   }
// }
//
//
// //
// // class UrlPreviewWidget extends StatefulWidget {
// //   final String url;
// //   final double borderRadius;
// //   final EdgeInsets insidePadding;
// //   final EdgeInsets outsidePadding;
// //
// //   const UrlPreviewWidget({
// //     super.key,
// //     required this.url,
// //     this.borderRadius = 8.0,
// //     this.insidePadding = const EdgeInsets.all(8),
// //     this.outsidePadding = const EdgeInsets.symmetric(vertical: 4),
// //   });
// //
// //   @override
// //   State<UrlPreviewWidget> createState() => _UrlPreviewWidgetState();
// // }
// //
// // class _UrlPreviewWidgetState extends State<UrlPreviewWidget> {
// //   LinkPreviewData? _linkPreviewData;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Return empty Container if URL is empty
// //     if (widget.url.isEmpty) return const SizedBox.shrink();
// //
// //     return LinkPreview(
// //       text: widget.url,
// //       linkPreviewData: _linkPreviewData,
// //       onLinkPreviewDataFetched: (data) {
// //         setState(() {
// //           _linkPreviewData = data;
// //         });
// //       },
// //       parentContent: widget.url,
// //       borderRadius: widget.borderRadius,
// //       sideBorderColor: Colors.grey.shade300,
// //       sideBorderWidth: 1,
// //       insidePadding: widget.insidePadding,
// //       outsidePadding: widget.outsidePadding,
// //       titleTextStyle: const TextStyle(
// //         fontWeight: FontWeight.bold,
// //         fontSize: 16,
// //       ),
// //       // bodyTextStyle: const TextStyle(
// //       //   fontSize: 14,
// //       //   color: Colors.black87,
// //       // ),
// //       // descriptionMaxLines: 2,
// //       imageBuilder: (imageUrl) {
// //         return ClipRRect(
// //           borderRadius: BorderRadius.circular(widget.borderRadius),
// //           child: Image.network(
// //             imageUrl,
// //             fit: BoxFit.cover,
// //             errorBuilder: (context, error, stackTrace) {
// //               return const SizedBox.shrink();
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
