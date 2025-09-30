import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:jobline/shared/data/network_client/dio_client.dart';

class AuthenticationApi {
  final DioClient dioClient = DioClient();

  AuthenticationApi();

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<Response> signUpApi(
      {required String name,
      required String email,
      required String role,
      required String password}) async {
    try {
      final Response response = await dioClient.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'role': role,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  // Future<void> logInWithGoogle() async {
  //   try {
  //     late final firebase_auth.AuthCredential credential;
  //     if (isWeb) {
  //       final googleProvider = firebase_auth.GoogleAuthProvider();
  //       final userCredential = await _firebaseAuth.signInWithPopup(
  //         googleProvider,
  //       );
  //       credential = userCredential.credential!;
  //     } else {
  //       final googleUser = await _googleSignIn.signIn();
  //       final googleAuth = await googleUser!.authentication;
  //       credential = firebase_auth.GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //     }

  //     await _firebaseAuth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     throw LogInWithGoogleFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const LogInWithGoogleFailure();
  //   }
  // }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<Response> logInApi({
    String? email,
    required String password,
  }) async {
    try {
      final Response response = await dioClient.post('/api/auth/login',
          data: json.encode({
            'email': email,
            'password': password,
          }));

      return response;

      // // const url = "https://jobline-serverz.vercel.app/api/auth/login";
      // const url = "http://localhost:8080/api/auth/login";
      // final ur = Uri.parse(url);

      // var response = await http.post(ur,
      //     body: json.encode({"email": email, "password": password}),
      //     headers: {'Content-Type': "application/json"});
      // print("data");
      // print(response);

      // print(response.body);

      // return Response(requestOptions: RequestOptions(path: ""));
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> forgotPasswordApi({
    String email = "",
  }) async {
    try {
      final Response response =
          await dioClient.post('/api/auth/v1/forgot-password', data: {
        "email": email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOutApi() async {
    try {
      await Future.wait([
        //logout functionality

        // _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendPasswordResetApi(
      {String password = "", String code = ""}) async {
    try {
      final Response response = await dioClient.post(
          '/api/auth/v1/reset-password',
          data: {"password": password, "code": code});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendEmailWindowsApi({
    String email = "",
  }) async {
    try {
      final Response response = await dioClient
          .post('/api/auth/v1/email/windows/app/download-link', data: {
        "email": email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
