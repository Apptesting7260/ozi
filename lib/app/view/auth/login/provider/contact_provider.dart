import 'package:flutter/material.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import 'package:ozi/app/data/repository/repository.dart';

class ContactProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  Future<void> sendToAdmin(
    Map<String, String> fields,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.sendToAdminApi(fields);
      if (response['status'] == true) {
        Get.showToast(response['message'], type: ToastType.success);
        Navigator.pop(context);
      } else {
        Get.showToast(response['message'], type: ToastType.error);
      }
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      _isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }
}
