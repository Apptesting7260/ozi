

abstract class BaseApiServices {

  Future<dynamic> getApi(String url,String token) ;


  Future<dynamic> postApi(dynamic data, String url, String token);
}