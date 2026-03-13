import 'package:ozi/app/core/appExports/app_export.dart';

import 'package:ozi/app/data/repository/repository.dart';

import '../../../../../data/storage/user_preference.dart';

import '../model/document_verify_check_model.dart';

class ReadyToGoLivescreenProvider extends ChangeNotifier {

  final Repository _repo = Repository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  DocumentStatusModel? documentStatusModel;

  bool get isVerified => documentStatusModel?.data?.verifiedByAdmin ?? false;

  Future<void> getDocumentStatus() async {

    _isLoading = true;

    notifyListeners();

    try {

      documentStatusModel = await _repo.documentStatusCheck();

      bool verified = documentStatusModel?.data?.verifiedByAdmin ?? false;

      await UserPreference.saveIsDocumentVerified(verified);

    } catch (e) {

      debugPrint("Document Status Error: $e");

    }

    _isLoading = false;

    notifyListeners();

  }

}