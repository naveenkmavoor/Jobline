import 'dart:developer';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:jobline/shared/data/network_client/dio_interceptors.dart';

class DioClient {
  static Dio _dio = Dio();
  static final DioClient _singleton = DioClient._internal();

  DioClient._internal() {
    final String baseUrl = "https://jobline-f7wz6hu4l-bhavisshyya.vercel.app/";
    final cookieJar = CookieJar();
    _dio
          ..options.baseUrl = baseUrl
          ..options.extra["withCredentials"] = true
          ..options.connectTimeout = 60 * 1000
          ..options.receiveTimeout = 60 * 1000
          ..interceptors.add(
            CookieManager(cookieJar),
          )
          ..interceptors.add(
            AwesomeDioInterceptor(baseUrl: baseUrl),
          ) // create a new Dio instance
        ;
  }

  factory DioClient() {
    return _singleton;
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void setDefaultHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

// Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      log(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

// Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    dynamic data,

    // CancelToken? cancelToken,
    // ProgressCallback? onSendProgress,
    // ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Patch:----------------------------------------------------------------------
  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    // CancelToken? cancelToken,
    // ProgressCallback? onSendProgress,
    // ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  void init(String baseUrl) {
    //TODO initializeInterceptors();
  }
}
