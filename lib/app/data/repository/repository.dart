import 'dart:developer' as dev;
import 'package:ozi/app/modules/user/booking/model/bookingdetailsmodel.dart'
    as details;
import 'package:ozi/app/modules/user/booking/model/bookingmodel.dart';
import 'package:ozi/app/modules/user/cart/schedule_service/Model/bookservicemodel.dart';
import 'package:ozi/app/modules/user/home/model/category_model.dart';
import 'package:ozi/app/modules/user/home/service%20details/model/ServiceDetailsModel.dart';
import 'package:ozi/app/modules/user/profile/setting/model/settingsmodel.dart';
import 'package:ozi/app/modules/user/profile/view/model/logout_model.dart';
import 'package:ozi/app/modules/vendor/profile/help/model/helpsupportmodel.dart';
import 'package:ozi/app/view/user_role/choose_your_role/model/choose_role_model.dart';
import '../../core/appExports/app_export.dart';
import '../../core/constants/app_urls.dart';
import '../../modules/user/cart/view/model/cart_items_model.dart';
import '../../modules/user/cart/view/model/decrease_cart_quantity_model.dart';
import '../../modules/user/cart/view/model/increase_cart_quantity_model.dart';
import '../../modules/user/home/service details/model/add_to_cart.dart';
import '../../modules/user/profile/edit address/model/edit_address_model.dart';
import '../../modules/user/profile/edit profile/model/update_profile_model.dart';
import '../../modules/user/profile/save address/model/delete_address_model.dart';
import '../../view/auth/login/model/login_model.dart';
import '../../view/auth/verification_screen/model/verify_otp.dart';
import '../network/network_api_services.dart';

class Repository {
  final _apiService = NetworkApiServices();

  //**************************************************** Login API *****************************************************************//
  Future<LoginModel> userLoginApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.login,
      );
      return LoginModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  //   //************************************************** Verification API **************************************************//
  Future<verifyOtp> verificationUser(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.verification,
      );
      return verifyOtp.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  //****************************** Choose role API **********************************//
  Future<ChooseRoleModel> chooseRoleApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.chooseRole,
      );
      return ChooseRoleModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // ********************************** Category Api ****************************//

  Future<CategoryModel> homePageCategoryApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.getApi(AppUrls.getHomeCategories);
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************  logout Api *********************************//

  Future<LogoutModel> logoutApi() async {
    try {
      dynamic response = await _apiService.postApi({}, AppUrls.logout);
      return LogoutModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************** ServiceDetails Api ***************************************//
  Future<ServiceDetailsModel> serviceDetailsApi(
    int categoryId,
    int subcategoryId,
  ) async {
    try {
      final url =
          '${AppUrls.getServiceDetailsApi}?category_id=$categoryId&subcategory_id=$subcategoryId';

      dev.log('Service Details API URL: $url');

      dynamic response = await _apiService.getApi(url);

      dev.log('Service Details Raw Response: $response');

      return ServiceDetailsModel.fromJson(response);
    } catch (e) {
      dev.log('Error in serviceDetailsApi: $e');
      throw Exception(e);
    }
  }

  // *********************************** HelpCenter Api ***************************************//
  Future<helpSupportModel> helpCenterApi(String type) async {
    try {
      final url = '${AppUrls.helpSupportUrl}?type=$type';

      dev.log('helpCenterApi URL: $url');

      dynamic response = await _apiService.getApi(url);

      dev.log('helpCenterApi Response: $response');

      return helpSupportModel.fromJson(response);
    } catch (e) {
      dev.log('Error in helpCenterApi: $e');
      throw Exception(e);
    }
  }

  // **************************  AddToCart Api **************************//
  Future<AddToCartModel> addToCartApi(Map<String, dynamic> data) async {
    try {
      print('API Request URL: ${AppUrls.addToCartApi}');
      print('API Request Data: $data');

      dynamic response = await _apiService.postApi(data, AppUrls.addToCartApi);

      print('API Response: $response');
      print('API Response Type: ${response.runtimeType}');

      // Return raw response, let the provider parse it
      return AddToCartModel.fromJson(response);
    } catch (e) {
      print('addToCartApi Error: $e');
      rethrow;
    }
  }

  // **************************  cancelBooking Api **************************//
  Future<dynamic> cancelBookingApi(int bookingId) async {
    try {
      print('API Request URL: ${AppUrls.cancelBooking}');
      print('API Request Data: $bookingId');

      dynamic response = await _apiService.postApi({
        "booking_id": bookingId,
      }, AppUrls.cancelBooking);

      print('API Response: $response');
      print('API Response Type: ${response.runtimeType}');
      return response;
    } catch (e) {
      print('cancelBookingApi: $e');
      rethrow;
    }
  }

  // **************************  Get Cart Items Api **************************//
  Future<CartItemsModel> getCartItemsApi() async {
    try {
      print('API Request URL: ${AppUrls.getCartItemsApi}');

      dynamic response = await _apiService.getApi(AppUrls.getCartItemsApi);
      print('API Response: $response');
      return CartItemsModel.fromJson(response);
    } catch (e) {
      print('getCartItemsApi Error: $e');
      rethrow;
    }
  }

  Future<settingsModel> settingsApi() async {
    try {
      print('API Request URL: ${AppUrls.settingsUrl}');

      dynamic response = await _apiService.getApi(AppUrls.settingsUrl);
      print('API Response: $response');
      return settingsModel.fromJson(response);
    } catch (e) {
      print('settingsApi Error: $e');
      rethrow;
    }
  }

  // **************************  GetBookingDetails Api **************************//
  Future<details.bookingDetailsModel> getBookingDetailsApi(
    int bookingId,
  ) async {
    try {
      final url = "${AppUrls.getBookingDetails}booking_id=$bookingId";
      print('API Request URL: $url');

      dynamic response = await _apiService.getApi(url);
      print('API Response: $response');
      return details.bookingDetailsModel.fromJson(response);
    } catch (e) {
      print('getBookingDetailsApi Error: $e');
      rethrow;
    }
  }

  // **************************  GetAllBookings Api **************************//
  Future<bookingModel> getAllBookings(
    String status,
    int limit,
    int page,
  ) async {
    try {
      final url =
          '${AppUrls.getAllBookings}?status=$status&limit=$limit&page=$page';
      print('API Request URL: $url');

      dynamic response = await _apiService.getApi(url);
      print('API Response: $response');
      return bookingModel.fromJson(response);
    } catch (e) {
      print('getAllBookings Error: $e');
      rethrow;
    }
  }

  // **************************  Remove Cart Item Api **************************//
  Future<dynamic> removeCartItemApi(int cartId) async {
    try {
      final url = '${AppUrls.deleteCartItem}?cart_id=$cartId';

      dev.log('Remove Cart Item API URL: $url');

      dynamic response = await _apiService.postApi({}, url);

      dev.log('Remove Cart Item Raw Response: $response');

      return response;
    } catch (e) {
      dev.log('Error in removeCartItemApi: $e');
      throw Exception(e);
    }
  }

  //********************************* increaseCartQuantity Api ********************************//
  Future<IncreaseCartQuantityModel> increaseCartItemApi(int cartId) async {
    try {
      final url = '${AppUrls.increaseCartQuantity}?cart_id=$cartId';

      dev.log('Increase Cart Item API URL: $url');

      dynamic response = await _apiService.postApi({}, url);

      dev.log('Increase Cart Item Raw Response: $response');

      return IncreaseCartQuantityModel.fromJson(response);
    } catch (e) {
      dev.log('Error in increaseCartItemApi: $e');
      throw Exception(e);
    }
  }

  //********************************* decreaseCartQuantity Api ********************************//
  Future<DecreaseCartQuantityModel> decreaseCartItemApi(int cartId) async {
    try {
      final url = '${AppUrls.decreaseCartQuantity}?cart_id=$cartId';

      dev.log('Decrease Cart Item API URL: $url');

      dynamic response = await _apiService.postApi({}, url);

      dev.log('Decrease Cart Item Raw Response: $response');

      return DecreaseCartQuantityModel.fromJson(response);
    } catch (e) {
      dev.log('Error in decreaseCartItemApi: $e');
      throw Exception(e);
    }
  }

  // ********************************************* GetProfile Api ***********************************************//
  Future<dynamic> getProfileApi() async {
    try {
      dynamic response = await _apiService.getApi(AppUrls.getUserProfile);
      print('Profile API Response: $response');
      return response;
    } catch (e) {
      print('Profile API Error: $e');
      throw Exception(e);
    }
  }

  // ********************************************* UpdateProfile Api ***********************************************//
  Future<UpdateProfileModel> updateProfileApi(
    Map<String, String> fields,
    File? image,
  ) async {
    Map<String, File> fileMap = {};

    if (image != null) {
      fileMap["pro_img"] = image;
    }
    dynamic response = await _apiService.postApiMultiPart(
      AppUrls.updateUserProfile,
      fields,
      fileMap,
    );
    return UpdateProfileModel.fromJson(response);
  }

  // ********************************************* getUserAddress Api ***********************************************//
  Future<dynamic> getUserAddressApi() async {
    try {
      dynamic response = await _apiService.getApi(AppUrls.getUserAddress);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  // ********************************************* AddNewUserAddress Api ***********************************************//
  Future<dynamic> addNewUserAddressApi(Map<String, dynamic> data) async {
    try {
      dev.log("Add New User Address API URL: ${AppUrls.addUserAddress}");
      dev.log("Request Data: $data");

      final response = await _apiService.postApi(data, AppUrls.addUserAddress);

      return response;
    } catch (e) {
      dev.log("Error in addNewUserAddressApi: $e");
      throw Exception(e);
    }
  }

  // ********************************************* Support Api ***********************************************//
  Future<dynamic> supportApi(Map<String, dynamic> data) async {
    try {
      dev.log("Support API URL: ${AppUrls.SupportUrl}");
      dev.log("Request Data: $data");

      final response = await _apiService.postApi(data, AppUrls.SupportUrl);

      return response;
    } catch (e) {
      dev.log("Error in supportApi: $e");
      throw Exception(e);
    }
  }

  // ********************************************* scheduleApi ***********************************************//
  Future<dynamic> completescheduleServiceApi(Map<String, dynamic> data) async {
    try {
      dev.log("completescheduleServiceApi API URL: ${AppUrls.bookService}");
      dev.log("Request Data: $data");

      final response = await _apiService.postApi(data, AppUrls.bookService);

      return response;
    } catch (e) {
      dev.log("Error in scheduleServiceApi: $e");
      throw Exception(e);
    }
  }

  // ********************************************* deleteUserAddress Api ***********************************************//
  Future<DeleteAddressModel> deleteUserAddressApi(int addressId) async {
    try {
      dev.log("Delete User Address API URL: ${AppUrls.deleteUserAddress}");
      dev.log("Address ID: $addressId");

      // Use DELETE method with correct parameter name
      final response = await _apiService.deleteApi(
        {"address_id": addressId}, // Changed from "id" to "address_id"
        AppUrls.deleteUserAddress,
      );

      return DeleteAddressModel.fromJson(response);
    } catch (e) {
      dev.log("Error in deleteUserAddressApi: $e");
      throw Exception(e);
    }
  }

  // ********************************************* editUserAddress Api ***********************************************//
  Future<EditAddressModel> editUserAddressApi(
    int addressId,
    Map<String, dynamic> data,
  ) async {
    try {
      dev.log(
        "Edit User Address API URL: ${AppUrls.updateUserAddress}/$addressId",
      );
      dev.log("Request Data: $data");

      // Use PUT method and append addressId to URL
      final response = await _apiService.putApi(
        data,
        "${AppUrls.updateUserAddress}/$addressId",
      );

      return EditAddressModel.fromJson(response);
    } catch (e) {
      dev.log("Error in editUserAddressApi: $e");
      throw Exception(e);
    }
  }

  // ********************************************* editUserAddress Api ***********************************************//
  Future<BookServiceModel> scheduleServiceApi() async {
    try {
      dev.log("scheduleServiceApi API URL: ${AppUrls.schedule_service}");

      // Use PUT method and append addressId to URL
      final response = await _apiService.getApi(AppUrls.schedule_service);

      return BookServiceModel.fromJson(response);
    } catch (e) {
      dev.log("Error in scheduleServiceApi: $e");
      throw Exception(e);
    }
  }

  // **************************  Delete Profile Api **************************//
  Future<dynamic> deleteProfile() async {
    try {
      print('API Request URL: ${AppUrls.deleteAccountUrl}');

      dynamic response = await _apiService.deleteApi(
        {},
        AppUrls.deleteAccountUrl,
      );
      print('API Response: $response');
      return response;
    } catch (e) {
      print('deleteProfile Error: $e');
      rethrow;
    }
  }

  // **************************  Update Notification Api **************************//
  Future<dynamic> updateNotificationApi(int status) async {
    try {
      final url = '${AppUrls.updateNotificationUrl}notification=$status';
      print('API Request URL: $url');

      dynamic response = await _apiService.postApi({
        "notification": status,
      }, url);
      print('API Response: $response');
      return response;
    } catch (e) {
      print('updateNotificationApi Error: $e');
      rethrow;
    }
  }
}
