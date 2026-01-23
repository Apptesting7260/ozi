class AppUrls {
  static const String baseUrl = "https://nbturls.in/oziservice/api";
  static const String imageBaseUrl = "https://nbturls.in/oziservice/public/";



  static const String login = "$baseUrl/send-otp";
  static const String verification = "$baseUrl/verify-otp";
  static const String chooseRole = "$baseUrl/select-user-role";
  static const String completeRegistration = "$baseUrl/complete-registration";
  static const String getHomeCategories = "$baseUrl/get-all-categories";
  static const String logout = "$baseUrl/logout";
  static const String getServiceDetailsApi = "$baseUrl/get-services";
  static const String addToCartApi = "$baseUrl/add-to-cart";
  static const String getCartItemsApi = "$baseUrl/get-user-cart-items";
  static const String increaseCartQuantity = "$baseUrl/increase-cart-quantity";
  static const String decreaseCartQuantity = "$baseUrl/decrease-cart-quantity";
  static const String deleteCartItem = "$baseUrl/delete-cart-item";
  static const String getUserProfile = "$baseUrl/get-users-profile";
  static const String updateUserProfile = "$baseUrl/update-users-profile";



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
}
