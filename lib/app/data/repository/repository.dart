
import 'dart:developer' as dev;
import 'package:ozi/app/modules/user/home/model/category_model.dart';
import 'package:ozi/app/modules/user/home/service%20details/model/ServiceDetailsModel.dart';
import 'package:ozi/app/modules/user/profile/view/model/logout_model.dart';
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
import '../../modules/user/profile/view/model/user_profile_model.dart';
import '../../view/auth/login/model/login_model.dart';
import '../../view/auth/verification_screen/model/verify_otp.dart';
import '../network/network_api_services.dart';
import '../storage/user_preference.dart';

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
      dynamic response = await _apiService.getApi(
        AppUrls.getHomeCategories,
      );
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************  logout Api *********************************//

  Future<LogoutModel> logoutApi() async {
    try {
      dynamic response = await _apiService.postApi(
        {},
        AppUrls.logout,
      );
      return LogoutModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************** ServiceDetails Api ***************************************//
  Future<ServiceDetailsModel> serviceDetailsApi(int categoryId, int subcategoryId) async {
    try {
      final url = '${AppUrls.getServiceDetailsApi}?category_id=$categoryId&subcategory_id=$subcategoryId';

      dev.log('Service Details API URL: $url');


      dynamic response = await _apiService.getApi(
        url,
      );

      dev.log('Service Details Raw Response: $response');

      return ServiceDetailsModel.fromJson(response);
    } catch (e) {
      dev.log('Error in serviceDetailsApi: $e');
      throw Exception(e);
    }
  }
  // **************************  AddToCart Api **************************//
  Future<AddToCartModel> addToCartApi(Map<String, dynamic> data) async {


    try {
      print('API Request URL: ${AppUrls.addToCartApi}');
      print('API Request Data: $data');



      dynamic response = await _apiService.postApi(
        data,
        AppUrls.addToCartApi,
      );

      print('API Response: $response');
      print('API Response Type: ${response.runtimeType}');

      // Return raw response, let the provider parse it
      return AddToCartModel.fromJson(response);
    } catch (e) {
      print('addToCartApi Error: $e');
      rethrow;
    }
  }
  // **************************  Get Cart Items Api **************************//
  Future<CartItemsModel> getCartItemsApi() async {
    try {
      print('API Request URL: ${AppUrls.getCartItemsApi}');

      dynamic response = await _apiService.getApi(
        AppUrls.getCartItemsApi,
      );
      print('API Response: $response');
      return CartItemsModel.fromJson(response);
    } catch (e) {
      print('getCartItemsApi Error: $e');
      rethrow;
    }
  }
  // **************************  Remove Cart Item Api **************************//
  Future<dynamic> removeCartItemApi(int cartId) async {
    try {
      final url = '${AppUrls.deleteCartItem}?cart_id=$cartId';

      dev.log('Remove Cart Item API URL: $url');



      dynamic response = await _apiService.postApi(
        {},
        url,
      );

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



      dynamic response = await _apiService.postApi(
        {},
        url
      );

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



      dynamic response = await _apiService.postApi(
        {},
        url
      );

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
      dynamic response = await _apiService.getApi(
        AppUrls.getUserProfile,
      );
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
      dynamic response = await _apiService.getApi(
        AppUrls.getUserAddress,
      );
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

      final response = await _apiService.postApi(
        data,
        AppUrls.addUserAddress,
      );

      return response;

    } catch (e) {
      dev.log("Error in addNewUserAddressApi: $e");
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
        {"address_id": addressId},  // Changed from "id" to "address_id"
        AppUrls.deleteUserAddress,
      );

      return DeleteAddressModel.fromJson(response);

    } catch (e) {
      dev.log("Error in deleteUserAddressApi: $e");
      throw Exception(e);
    }
  }


  // ********************************************* editUserAddress Api ***********************************************//
  Future<EditAddressModel> editUserAddressApi(int addressId, Map<String, dynamic> data) async {

    try {
      dev.log("Edit User Address API URL: ${AppUrls.updateUserAddress}/$addressId");
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
  }}
