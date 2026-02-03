class AppUrls {
  static const String baseUrl = "https://nbturls.in/oziservice/api";
  static const String imageBaseUrl = "https://nbturls.in/oziservice/public/";

  static const String login = "$baseUrl/send-otp";
  static const String verification = "$baseUrl/verify-otp";
  static const String chooseRole = "$baseUrl/select-user-role";
  static const String completeRegistration = "$baseUrl/complete-registration";
  static const String getHomeCategories = "$baseUrl/get-categories-by-lat-long";
  static const String logout = "$baseUrl/logout";
  static const String getServiceDetailsApi = "$baseUrl/get-services";
  static const String addToCartApi = "$baseUrl/add-to-cart";
  static const String getCartItemsApi = "$baseUrl/get-user-cart-items";
  static const String increaseCartQuantity = "$baseUrl/increase-cart-quantity";
  static const String decreaseCartQuantity = "$baseUrl/decrease-cart-quantity";
  static const String deleteCartItem = "$baseUrl/delete-cart-item";
  static const String getUserProfile = "$baseUrl/get-users-profile";
  static const String updateUserProfile = "$baseUrl/update-users-profile";
  static const String getUserAddress = "$baseUrl/get-user-addresses";
  static const String addUserAddress = "$baseUrl/store-user-address";
  static const String updateUserAddress = "$baseUrl/update-user-address";
  static const String deleteUserAddress = "$baseUrl/delete-user-address";
  static const String schedule_service = "$baseUrl/booking-vendor-availability";
  static const String bookService = "$baseUrl/book-services";
  static const String cancelBooking = "$baseUrl/booking-cancel";
  static const String getAllBookings = "$baseUrl/get-user-bookings";
  static const String getBookingDetails = "$baseUrl/user-booking-details?";
  static const String settingsUrl = "$baseUrl/settings?";
  static const String deleteAccountUrl = "$baseUrl/delete-profile";
  static const String updateNotificationUrl = "$baseUrl/update-notification?";
  static const String helpSupportUrl = "$baseUrl/get-faqs";
  static const String SupportUrl = "$baseUrl/send-user-email";

  // Vendor APIs
  static const String getAllCategories = "$baseUrl/get-all-categories";
  static const String saveCategoryForVendor = "$baseUrl/vendor-categories";
  static const String saveAvailabilityVendor = "$baseUrl/vendor-availability";
  static const String docsVendor = "$baseUrl/vendor-docs";
  static const String vendorHome = "$baseUrl/vendor-home-dashboard";
  static const String changeOnlineStatusVendor = "$baseUrl/vendor/status";
  static const String vendorGetCategoryData = "$baseUrl/get-vendor-categories";
  static const String storeVendorService = "$baseUrl/store-vendor-service";
  static const String acceptRejectBooking = "$baseUrl/vendor-Booking-Action";
  static const String vendorUpdateLocation = "$baseUrl/vendor-update-location";
  static const String vendorAllBookings = "$baseUrl/vendor-home-all-bookings";

  static const String vendorMyBookings =
      "$baseUrl/my-bookings?page={page}&limit=10";
  static const String vendorMyBookingsDetails =
      "$baseUrl/booking-details/{bookingid}";
  static const String vendorOtpVerify = "$baseUrl/verify-service-otp";
  static const String completeJob = "$baseUrl/complete-booking-status";

  static const String getAllServicesVendor = "$baseUrl/get-vendor-services";
  static const String deleteServiceVendor = "$baseUrl/delete-vendor-service/{serviceid}";


}
