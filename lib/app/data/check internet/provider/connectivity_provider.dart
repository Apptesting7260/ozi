// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:async';
//
// enum ConnectivityStatus { online, offline }
//
// class ConnectivityProvider with ChangeNotifier {
//   ConnectivityStatus _status = ConnectivityStatus.offline;
//   late StreamSubscription<ConnectivityResult> _subscription;
//   final Connectivity _connectivity = Connectivity();
//
//   ConnectivityStatus get status => _status;
//   bool get isOnline => _status == ConnectivityStatus.online;
//   bool get isOffline => _status == ConnectivityStatus.offline;
//
//   ConnectivityProvider() {
//     _initializeConnectivity();
//   }
//
//   void _initializeConnectivity() async {
//     // Check initial connectivity
//     ConnectivityResult result = await _connectivity.checkConnectivity();
//     _updateStatus(result);
//
//     // Listen for connectivity changes
//     _subscription = _connectivity.onConnectivityChanged.listen(
//           (ConnectivityResult result) {
//         _updateStatus(result);
//       },
//     );
//   }
//
//   void _updateStatus(ConnectivityResult result) {
//     ConnectivityStatus newStatus = result == ConnectivityResult.none
//         ? ConnectivityStatus.offline
//         : ConnectivityStatus.online;
//
//     if (_status != newStatus) {
//       _status = newStatus;
//       notifyListeners();
//
//       // Automatically run functions based on connectivity
//       if (_status == ConnectivityStatus.online) {
//         _onConnected();
//       } else {
//         _onDisconnected();
//       }
//     }
//   }
//
//   void _onConnected() {
//     
//     // Add your functions that should run when internet is available
//     _syncData();
//     _fetchUpdates();
//   }
//
//   void _onDisconnected() {
//     
//     // Add your functions for offline mode
//     _saveToLocal();
//     _showOfflineMessage();
//   }
//
//   // Example functions that run automatically
//   Future<void> _syncData() async {
//     // Your sync logic here
//     try {
//       // Example: sync pending data to server
//       
//       // await apiService.syncPendingData();
//     } catch (e) {
//       
//     }
//   }
//
//   Future<void> _fetchUpdates() async {
//     // Your fetch logic here
//     try {
//       
//       // await apiService.fetchUpdates();
//     } catch (e) {
//       
//     }
//   }
//
//   void _saveToLocal() {
//     // Save current state to local storage
//     
//   }
//
//   void _showOfflineMessage() {
//     // You can use this to show offline indicators
//     
//   }
//
//   // Method to manually trigger online functions
//   void retryConnection() {
//     if (isOnline) {
//       _onConnected();
//     }
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }