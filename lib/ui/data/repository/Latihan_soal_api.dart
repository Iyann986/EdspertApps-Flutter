import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finalproject_edspertapp/ui/constants/R/urls.dart';
import 'package:finalproject_edspertapp/ui/data/models/exercise_result.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/helpers/user_email.dart';

class LatihanSoalApi {
  Dio dioApi() {
    BaseOptions options = BaseOptions(
      baseUrl: Urls.baseUrl,
      headers: {
        "x-api-key": Urls.apiKey,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      responseType: ResponseType.json,
    );
    final dio = Dio(options);
    return dio;
  }

  Future<NetworkResponse> _getRequest({endpoint, param}) async {
    try {
      final dio = dioApi();
      final result = await dio.get(endpoint, queryParameters: param);
      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "request timeout");
      }
      return NetworkResponse.error(data: null, message: "request error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: "other error");
    }
  }

  Future<NetworkResponse> _postRequest({endpoint, body}) async {
    try {
      final dio = dioApi();
      final result = await dio.post(endpoint, data: body);
      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "request timeout");
      }
      return NetworkResponse.error(data: null, message: "request error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: "other error");
    }
  }

  Future<NetworkResponse> getCourse() async {
    final result = await _getRequest(
      endpoint: Urls.courseList,
      param: {
        "course_id": "IPA",
        "user_email": UserEmail.getUserEmail(),
      },
    );
    return result;
  }

  Future<NetworkResponse> getExerciseList(id) async {
    final result = await _getRequest(
      endpoint: Urls.exerciseList,
      param: {
        "course_id": id,
        "user_email": UserEmail.getUserEmail(),
      },
    );
    return result;
  }

  Future<NetworkResponse> getBanner() async {
    final result = await _getRequest(
      endpoint: Urls.banner,
      // param: {
      //   "limit": "IPA",
      // },
    );
    return result;
  }

  Future<NetworkResponse> postRegister(body) async {
    final result = await _postRequest(
      endpoint: Urls.usersRegistrasi,
      body: body,
    );
    return result;
  }
}
