import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../core/utils/toast.dart';
import '../../../../../data/models/vendor_document_model.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';
import '../view/ready_to_go_livescreen.dart';

class IdentityVerificationProvider extends ChangeNotifier {

  IdentityVerificationProvider(bool isFromProfile){
    if(isFromProfile){
      // getDocuments();
    }
  }

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

  Future<void> saveDocuments(bool isFromProfile)async {
    updateSubmitLoading(true);
    try {
      Map<String,String> files = {
        "government_id_image":governmentId?.path??'',
        "certificate":certification?.path??''
      };
      print(files);
      final response = await _apiService.postApiMultiPart(AppUrls.docsVendor,{},files);
      print(response);
      if(isFromProfile==false){
        await UserPreference.saveStep('4');
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ReadyToGoLiveScreen(),
          ),
        );
      }else{
        Navigator.pop(navigatorKey.currentContext!);
      }
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

  String? fetchedCertificate;
  String? govtIdImage;

  Future<void> getDocuments()async {
    try {
      final response = await _apiService.getApi(AppUrls.getDocumentsVendor);
      VendorDocumentModel fetchedDocuments = VendorDocumentModel.fromJson(response);
      fetchedCertificate = fetchedDocuments.data?.certificate;
      govtIdImage = fetchedDocuments.data?.governmentIdImage;
      notifyListeners();
      print(response);
    } catch (e) {
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }
  }

}
