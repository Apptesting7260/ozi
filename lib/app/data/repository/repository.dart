
import 'dart:developer' as dev;
import 'package:ozi/app/modules/user/home/model/category_model.dart';
import 'package:ozi/app/modules/user/home/service%20details/model/ServiceDetailsModel.dart';
import 'package:ozi/app/modules/user/profile/view/model/logout_model.dart';
import 'package:ozi/app/view/user_role/choose_your_role/model/choose_role_model.dart';
import '../../core/appExports/app_export.dart';
import '../../core/constants/app_urls.dart';
import '../../view/auth/login/model/login_model.dart';
import '../../view/auth/verification_screen/model/verify_otp.dart';
import '../network/network_api_services.dart';
import '../storage/user_preference.dart';

class Repository {
  final _apiService = NetworkApiServices();

  String token = '';

  Future<void> getToken() async {
    token = await UserPreference.returnAccessToken() ?? "";
  }

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
    await getToken();
    try {
      dynamic response = await _apiService.getApi(
        AppUrls.getHomeCategories,
        token,
      );
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************  logout Api *********************************//

  Future<LogoutModel> logoutApi() async {
    await getToken();
    try {
      dynamic response = await _apiService.postApi(
        {},
        AppUrls.logout,
        token,
      );
      return LogoutModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  // *********************************** ServiceDetails Api ***************************************//
  Future<ServiceDetailsModel> serviceDetailsApi(int categoryId, int subcategoryId) async {
    await getToken();
    try {
      final url = '${AppUrls.getServiceDetailsApi}?category_id=$categoryId&subcategory_id=$subcategoryId';

      dev.log('Service Details API URL: $url');
      dev.log('Token: ${token.isNotEmpty ? "Present" : "Missing"}');

      dynamic response = await _apiService.getApi(
        url,
        token,
      );

      dev.log('Service Details Raw Response: $response');

      return ServiceDetailsModel.fromJson(response);
    } catch (e) {
      dev.log('Error in serviceDetailsApi: $e');
      throw Exception(e);
    }
  }
  // **************************  AddToCart Api **************************//
  Future<dynamic> addToCartApi(Map<String, dynamic> data) async {
    await getToken();

    try {
      ('API Request URL: ${AppUrls.addToCartApi}');
      print('API Request Data: $data');
      print('API Token: $token');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      dynamic response = await _apiService.postApi(
        data,
        AppUrls.addToCartApi,
        token,
      );

      print('API Response: $response');
      return response;
    } catch (e) {
      print('addToCartApi Error: $e');
      rethrow;
    }
  }
  // **************************  Get Cart Items Api **************************//
  Future<dynamic> getCartItemsApi() async {
    await getToken();
    try {
      print('API Request URL: ${AppUrls.getCartItemsApi}');
      print('API Token: $token');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      dynamic response = await _apiService.getApi(
        AppUrls.getCartItemsApi,
        token,
      );
      print('API Response: $response');
      return response;
    } catch (e) {
      print('getCartItemsApi Error: $e');
      rethrow;
    }
  }

  // **************************  Remove Cart Item Api **************************//
  Future<dynamic> removeCartItemApi(int cartId) async {
    await getToken();
    try {
      final url = '${AppUrls.deleteCartItem}?cart_id=$cartId';

      dev.log('Remove Cart Item API URL: $url');
      dev.log('Token: ${token.isNotEmpty ? "Present" : "Missing"}');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      dynamic response = await _apiService.postApi(
        {},
        url,
        token,
      );

      dev.log('Remove Cart Item Raw Response: $response');

      return response;
    } catch (e) {
      dev.log('Error in removeCartItemApi: $e');
      throw Exception(e);
    }
  }
  //********************************* increaseCartQuantity Api ********************************//
  Future<dynamic> increaseCartItemApi(int cartId) async {
    await getToken();
    try {
      final url = '${AppUrls.increaseCartQuantity}?cart_id=$cartId';

      dev.log('Increase Cart Item API URL: $url');
      dev.log('Token: ${token.isNotEmpty ? "Present" : "Missing"}');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      dynamic response = await _apiService.postApi(
        {},
        url,
        token,
      );

      dev.log('Increase Cart Item Raw Response: $response');

      return response;
    } catch (e) {
      dev.log('Error in increaseCartItemApi: $e');
      throw Exception(e);
    }
  }
 //********************************* decreaseCartQuantity Api ********************************//
  Future<dynamic> decreaseCartItemApi(int cartId) async {
    await getToken();
    try {
      final url = '${AppUrls.decreaseCartQuantity}?cart_id=$cartId';

      dev.log('Decrease Cart Item API URL: $url');
      dev.log('Token: ${token.isNotEmpty ? "Present" : "Missing"}');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      dynamic response = await _apiService.postApi(
        {},
        url,
        token,
      );

      dev.log('Decrease Cart Item Raw Response: $response');

      return response;
    } catch (e) {
      dev.log('Error in decreaseCartItemApi: $e');
      throw Exception(e);
    }
  }

  // ********************************************* GetProfile Api ***********************************************//
  Future<dynamic> getProfileApi() async {
    await getToken();
    try {
      print('API Request URL: ${AppUrls.getUserProfile}');
      print('API Token: $token');

      if (token.isEmpty) {
        throw Exception('Authentication token is missing');
      }
      dynamic response = await _apiService.getApi(
        AppUrls.getUserProfile,
        token,
      );
      print('API Response: $response');
      return response;
    } catch (e) {
      print('getProfileApi Error: $e');
      rethrow;
    }
  }

  // ********************************************* UpdateProfile Api ***********************************************//
  Future<dynamic> updateProfileApi(
      Map<String, String> fields,
      File? image,
      ) async {
    await getToken();

    final Map<String, dynamic> files = {};

    if (image != null) {
      files["pro_img"] = image; // 'pro_img' is the key expected by the API for the profile image
    }

    return await _apiService.postApiMultiPart(
      AppUrls.updateUserProfile,
      token,
      fields,
      files,
    );
  }


}
