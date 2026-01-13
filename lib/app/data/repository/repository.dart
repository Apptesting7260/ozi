
import 'package:ozi/app/view/user_role/choose_your_role/model/choose_role_model.dart';

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

//   //**************************************************** Complete Profile  API *****************************************************************//
//
//   Future<CompleteProfileModel> completeProfileApi(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.completeProfile,
//       token,
//     );
//     return CompleteProfileModel.fromJson(response);
//   }
//
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





//   //************************************** Get Cities API *************************************//
//   Future<GetCitiesModel> getCitiesApi() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.getCities, token);
//     return GetCitiesModel.fromJson(response);
//   }
//
//   //************************************** Get Area API *************************************//
//   Future<AreaModel> getAreaApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.getArea, token);
//     return AreaModel.fromJson(response);
//   }
//
//   //************************************** Logout API ******************************************//
//   Future<LogoutModel> logoutUser() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.logout, token);
//     return LogoutModel.fromJson(response);
//   }
//
//   //**************************************************** Complete Profile  API *****************************************************************//
//
//   Future<EditProfileModel> editProfileApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.putApi(
//       data,
//       AppUrls.editProfile,
//       token,
//     );
//     return EditProfileModel.fromJson(response);
//   }
//
//   //**************************************************** Complete Profile  API *****************************************************************//
//
//   Future<AddNewAddressModel> addNewAddressApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.newAddAddress,
//       token,
//     );
//     return AddNewAddressModel.fromJson(response);
//   }
//
//   //************************************** Get User Profile API *************************************//
//   Future<GetAddressModel> getAddressListApi() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.getAddress, token);
//     return GetAddressModel.fromJson(response);
//   }
//
//   //************************************** Delete Address API *************************************//
//   Future<DeleteAddressModel> deleteAddressApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.deleteApi(data, AppUrls.delete, token);
//     return DeleteAddressModel.fromJson(response);
//   }
//
//   //************************************** Primary Address API *************************************//
//   Future<AddressPrimaryModel> addressPrimary(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.primaryAddress,
//       token,
//     );
//     return AddressPrimaryModel.fromJson(response);
//   }
//
//   //************************************** Upload Profile Image *************************************//
//   Future<UploadAvtarModel> uploadProfileImage(
//       Map<String, String> fields,
//       Map<String, dynamic> files,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApiMultiPartBytes(
//       AppUrls.uploadProfileImage,
//       token,
//       fields,
//       files,
//     );
//     return UploadAvtarModel.fromJson(response);
//   }
//
//   //************************************** Get User Profile API *************************************//
//   Future<ProfileModel> getUserProfileApi() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.getProfile, token);
//     return ProfileModel.fromJson(response);
//   }
//
//   //**************************************************Edit Mobile Verification OTP API **************************************************//
//   Future<AddNewAddressModel> verifyEditMobileNumber(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.putApi(
//       data,
//       AppUrls.verifyEditMobile,
//       token,
//     );
//     return AddNewAddressModel.fromJson(response);
//   }
//
//   //************************************** Get Service Category API *************************************//
//   Future<ServiceCategoryModel> getServiceCategoryApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(data,AppUrls.serviceCategory, token);
//     return ServiceCategoryModel.fromJson(response);
//   }
//
//   //************************************** Get service list API *************************************//
//   Future<ServiceListModel> getServiceList(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.serviceList,
//       token,
//     );
//     return ServiceListModel.fromJson(response);
//   }
//
//   //************************************** Get sub Category API *************************************//
//   Future<SubCategoriesModel> getSubCategoryApi(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.subCategory,
//       token,
//     );
//     return SubCategoriesModel.fromJson(response);
//   }
//
//   //************************************** Get sub Category Item API *************************************//
//   Future<SubCategoryItemCategoryModel> getSubCategoryItemApi(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.subCategoryItem,
//       token,
//     );
//     return SubCategoryItemCategoryModel.fromJson(response);
//   }
//
//   //************************************** Add service API *************************************//
//   Future<AddServiceModel> addServiceApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.addService,
//       token,
//     );
//     return AddServiceModel.fromJson(response);
//   }
//
//   //**************************************************** Complete Profile  API *****************************************************************//
//
//   Future<UpdateCartModel> updateCartApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.putApi(
//       data,
//       AppUrls.updateService,
//       token,
//     );
//     return UpdateCartModel.fromJson(response);
//   }
//
//   //************************************** fetch home API *************************************//
//   Future<HomeModel> homeApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(data,AppUrls.home, token);
//     return HomeModel.fromJson(response);
//   }
//
//   //************************************** fetch Cart API *************************************//
//   Future<FetchCartModel> fetchCartApi() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.fetchCart, token);
//     return FetchCartModel.fromJson(response);
//   }
//
//   //************************************** Book Appointment API *************************************//
//   Future<BookAppointmentModel> bookAppointment(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.bookAppointment,
//       token,
//     );
//     return BookAppointmentModel.fromJson(response);
//   }
//
//   //************************************** Place Order API *************************************//
//   Future<PlaceOrderModel> placeOrder(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.placeOrder,
//       token,
//     );
//     return PlaceOrderModel.fromJson(response);
//   }
//
//   //************************************** fetch Order API *************************************//
//   Future<FetchOrderModel> fetchOrderApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(
//       data,
//       AppUrls.fetchOrders,
//       token,
//     );
//     return FetchOrderModel.fromJson(response);
//   }
//
//   //************************************** fetch Order API *************************************//
//   Future<OrderDetailModel> fetchOrderDetail(String orderID) async {
//     await getToken();
//     dynamic response = await _apiService.getApi(
//       AppUrls.orderDetail + orderID,
//       token,
//     );
//     return OrderDetailModel.fromJson(response);
//   }
//
//   //************************************** fetch Loyal points *************************************//
//   Future<LoyaltyTransactionHistoryModel> loyaltyTransactionHistory(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(
//       data,
//       AppUrls.loyaltyTransactionHistory,
//       token,
//     );
//     return LoyaltyTransactionHistoryModel.fromJson(response);
//   }
//
//   //************************************** fetch Loyal points *************************************//
//   Future<MoneyWalletModel> moneyWalletTransactionHistory(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(
//       data,
//       AppUrls.loyaltyTransactionHistory,
//       token,
//     );
//     return MoneyWalletModel.fromJson(response);
//   }
//
//   //************************************** Apply loyalty points API *************************************//
//   Future<ApplyLoyaltyPointsModel> applyLoyaltyApi(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.applyLoyaltyPoints,
//       token,
//     );
//     return ApplyLoyaltyPointsModel.fromJson(response);
//   }
//
//   //************************************** Cancel  Order API *************************************//
//   Future<CancelOrderModel> cancelOrder(String orderID,Map<String, dynamic> data) async {
//     await getToken();
//     final url = "${AppUrls.cancelOrder}$orderID/cancel";
//     dynamic response = await _apiService.deleteApi(data,url, token);
//     return CancelOrderModel.fromJson(response);
//   }
//
//   //************************************** Reschedule  Order API *************************************//
//   Future<RescheduleOrderModel> rescheduleOrder(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.rescheduleOrder,
//       token,
//     );
//     return RescheduleOrderModel.fromJson(response);
//   }
//
//   //************************************** GET Coupon list API *************************************//
//
//   Future<CouponListModel> fetchCouponList() async {
//     await getToken();
//     dynamic response = await _apiService.getApi(AppUrls.fetchCouponList, token);
//     return CouponListModel.fromJson(response);
//   }
//
//   //**************************************************** Complete Profile  API *****************************************************************//
//
//   Future<ApplyJobModel> applyJobForPartner(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.applyJob, token);
//     return ApplyJobModel.fromJson(response);
//   }
//
//   //**************************************************** Create Order RazoryPay API *****************************************************************//
//
//   Future<CreateOrderModel> createRazorpayOrder(
//       Map<String, dynamic> data,
//       ) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(
//       data,
//       AppUrls.createRazorpayOrder,
//       token,
//     );
//     return CreateOrderModel.fromJson(response);
//   }
//
//   //**************************************************** Fetch Time Slots API *****************************************************************//
//
//   Future<FetchSlotModel> fetchTimeSlots( Map<String, dynamic> data,) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(data,AppUrls.fetchTimeSlots, token);
//     return FetchSlotModel.fromJson(response);
//   }
//
//   //**************************************************** check Slots API *****************************************************************//
//
//   Future<CheckSlotModel> checkTimeSlots( Map<String, dynamic> data,) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(data,AppUrls.checkSlot, token);
//     return CheckSlotModel.fromJson(response);
//   }
//
//   //**************************************************** Create Voucher  API *****************************************************************//
//
//   Future<CreateVoucherModel> createVoucherApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.createVoucher, token);
//     return CreateVoucherModel.fromJson(response);
//   }
//
//
//   //**************************************************** fetch Voucher  API *****************************************************************//
//
//   Future<FetchVoucherModel> fetchVoucherApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.fetchVoucher, token);
//     return FetchVoucherModel.fromJson(response);
//   }
//
//   //**************************************************** Redeem Voucher  API *****************************************************************//
//
//   Future<FetchVoucherModel> redeemVoucherApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.redeemVoucher, token);
//     return FetchVoucherModel.fromJson(response);
//   }
//
//
//   //**************************************************** update city  API *****************************************************************//
//
//   Future<UpdateCityModel> updateCityApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.updateCity, token);
//     return UpdateCityModel.fromJson(response);
//   }
//
//   //**************************************************** update city  API *****************************************************************//
//
//   Future<SearchItemModel> searchItemApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.searchItemApi, token);
//     return SearchItemModel.fromJson(response);
//   }
//   //************************************** GET Notification API *************************************//
//
//   Future<NotificationModel> getNotification(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.getApiWithPerms(data,AppUrls.notifications, token,);
//     return NotificationModel.fromJson(response);
//   }
//
//   //************************************* Delete Account API ******************************************//
//
//   Future<LogoutModel> deleteAccount(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.deleteApi(data, AppUrls.userDelete, token);
//     return LogoutModel.fromJson(response);
//   }
//   //**************************************************** Add Money Wallet Api  API *****************************************************************//
//
//   Future<AddMoneyWalletModel> addMoneyToWalletApi(Map<String, dynamic> data) async {
//     await getToken();
//     dynamic response = await _apiService.postApi(data, AppUrls.addMoney, token);
//     return AddMoneyWalletModel.fromJson(response);
//   }
// }
}
