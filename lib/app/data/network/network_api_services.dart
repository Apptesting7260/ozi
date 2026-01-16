import '../../core/appExports/app_export.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../routes/app_routes.dart';
import '../Exception/app_exceptions.dart';
import '../storage/user_preference.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  Future<String?> getAccessTokenFromStorage() async {
    return await UserPreference.returnAccessToken();
  }


  @override
  Future<dynamic> getApi(String url, String token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    ).timeout(const Duration(seconds: 10));

    return returnResponse(response, url);
  }

  Future<dynamic> getApiWithPerms(
      Map<String, dynamic> data, String url, String token) async {
    final uri = Uri.parse(url).replace(
      queryParameters: data.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    ).timeout(const Duration(seconds: 10));

    return returnResponse(response, url);
  }

  @override
  Future<dynamic> postApi(var data, String url, String token) async {
    try {
      print('POST Request to: $url');
      print('Token: $token');
      print('Data: $data');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json", // Add this
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 50));

      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body Preview: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');

      return returnResponse(response, url);
    } catch (e) {
      print('postApi Error: $e');
      rethrow;
    }
  }

  Future<dynamic> patchApi(var data, String url, String token) async {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 50));

    return returnResponse(response, url);
  }

  Future<dynamic> patchMultipartApi(
      Map<String, String> fields,
      String url,
      String token,
      ) async {
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("PATCH", uri)
      ..headers.addAll({"Authorization": "Bearer $token"})
      ..fields.addAll(fields);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return returnResponse(response, url);
  }

  Future<dynamic> postApiWithoutToken(var data, String url) async {
    try {
      Get.consoleLog("\n$url\n${data.toString()}", "token + url + data");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 50));

      final responseJson = returnResponse(response, url);
      Get.consoleLog("$responseJson", "data from api");
      return responseJson;
    } on SocketException {
      throw Exception("Internet Connection Issue..");
    } on TimeoutException {
      throw Exception("Request Time Out..");
    }
  }

  Future<dynamic> getApiWithoutToken(String url) async {
    if (kDebugMode) {
      try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 50));
      return returnResponse(response, url);
    } on SocketException {
      throw Exception("Internet Connection Issue..");
    } on TimeoutException {
      throw Exception("Request Time Out..");
    }
    }
  }

  Future<dynamic> deleteApi(var data,String url, String token) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 50));

      return returnResponse(response, url);
    } on SocketException {
      throw Exception("Internet Connection Issue..");
    } on TimeoutException {
      throw Exception("Request Time Out..");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
  Future<dynamic> deleteApiWithoutData(String url, String token) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 50));

      return returnResponse(response, url);
    } on SocketException {
      throw Exception("Internet Connection Issue..");
    } on TimeoutException {
      throw Exception("Request Time Out..");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  Future<dynamic> putApi(var data,String url, String token) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 50));

      return returnResponse(response, url);
    } on SocketException {
      throw Exception("Internet Connection Issue..");
    } on TimeoutException {
      throw Exception("Request Time Out..");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }


  Future<dynamic> postApiMultiPart(
      String url,
      String token,
      Map<String, String> fields,
      Map<String, dynamic> files,
      ) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(fields)
      ..headers.addAll(headers);

    for (var entry in files.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        request.files.add(await http.MultipartFile.fromPath(key, value));
      } else if (value is List<String>) {
        for (int i = 0; i < value.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(key, value[i]));
        }
      } else {
        throw Exception("Unsupported file input type for key '$key'");
      }
    }

    http.StreamedResponse streamResponse =
    await request.send().timeout(const Duration(seconds: 50));

    String responseString = await streamResponse.stream.bytesToString();

    return returnResponseMultiPart(streamResponse, responseString, url);
  }

  Future<dynamic> postApiMultiPartBytes(
      String url,
      String token,
      Map<String, String> fields,
      Map<String, dynamic> files,
      ) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(fields)
      ..headers.addAll(headers);

    for (var entry in files.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Uint8List) {
        request.files.add(http.MultipartFile.fromBytes(
          key,
          value,
          filename: '$key.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (value is File) {
        request.files.add(await http.MultipartFile.fromPath(
          key,
          value.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (value is String) {
        request.files.add(await http.MultipartFile.fromPath(
          key,
          value,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (value is List<Uint8List>) {
        for (int i = 0; i < value.length; i++) {
          request.files.add(http.MultipartFile.fromBytes(
            key,
            value[i],
            filename: '$key$i.jpg',
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      } else if (value is List<File>) {
        for (int i = 0; i < value.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            value[i].path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      } else if (value is List<String>) {
        for (int i = 0; i < value.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            value[i],
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      } else {
        throw Exception(
            "Unsupported file type for key '$key': ${value.runtimeType}");
      }
    }

    http.StreamedResponse streamResponse =
    await request.send().timeout(const Duration(seconds: 50));

    String responseString = await streamResponse.stream.bytesToString();

    return returnResponseMultiPart(streamResponse, responseString, url);
  }

  dynamic returnResponse(http.Response response, String url) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 401:
        _handleLogout();
        throw UnauthenticatedException();
      default:
        throw FetchDataException(jsonDecode(response.body)['message'] ??
            'Error ${response.statusCode}');
    }
  }
  void _handleLogout() async {
    await UserPreference.clearSharedPreference();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    }
  }

  dynamic returnResponseMultiPart(
      http.StreamedResponse response, String responseBody, String url) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(responseBody);
      case 401:
        _handleLogout();
        throw UnauthenticatedException();
      default:
        throw FetchDataException(
            jsonDecode(responseBody)['message']?.toString() ??
                'Error ${response.statusCode}');
    }
  }

  Future<dynamic> postApiWithoutData(String url, String token) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    ).timeout(const Duration(seconds: 50));

    return returnResponse(response, url);
  }
}
