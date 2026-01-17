import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../core/utils/toast.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';
import '../view/ready_to_go_livescreen.dart';

class IdentityVerificationProvider extends ChangeNotifier {

  final NetworkApiServices _apiService = NetworkApiServices();
  File? governmentId;
  File? certification;

  bool get isGovernmentUploaded => governmentId != null;
  bool get isCertificationUploaded => certification != null;

  bool get canContinue => isGovernmentUploaded;

  void setGovernmentId(File file) {
    governmentId = file;
    notifyListeners();
  }

  void setCertification(File file) {
    certification = file;
    notifyListeners();
  }

  bool _submitLoading = false;
  bool get submitLoading => _submitLoading;
  updateSubmitLoading(bool value){
    _submitLoading = value;
    notifyListeners();
  }

  Future<void> saveDocuments()async {
    updateSubmitLoading(true);
    try {
      Map<String,String> files = {
        "government_id_image":governmentId?.path??'',
        "certificate":certification?.path??''
      };
      print(files);
      final token = await UserPreference.returnAccessToken();
      final response = await _apiService.postApiMultiPart(AppUrls.docsVendor,token!,{},files);
      print(response);
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => ReadyToGoLiveScreen(),
        ),
      );
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (_) => IdentityVerificationScreen(),
      //   ),
      // );
      updateSubmitLoading(false);
    } catch (e) {
      updateSubmitLoading(false);
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }

  }

}
