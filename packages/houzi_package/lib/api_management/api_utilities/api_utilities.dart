import 'dart:io' show Platform;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/user/user_login_info.dart';

class ApiUtilities {
  static const int MAX_TRIES = 3;
  static const int GET = 0;
  static const int POST = 1;
  static const int PUT = 2;
  static const int DELETE = 3;

   static const String ApiAppVersionKey = "app_version";
   static const String ApiHouziVersionKey = "houzi_version";
   static const String ApiAppBuildNumberKey = "app_build_number";
   static const String ApiAppPlatformKey = "app_platform";
   static const String ApiAppLanguageKey = "lang";
   static const String PlatformAndroidKey = "android";
   static const String PlatformIOSKey = "ios";

   static const String ApiHeaderAuthorizationKey = "Authorization";
   static const String ApiHeaderBearerString = "Bearer";
   static const String ApiHeaderPragmaKey = "Pragma";
   static const String ApiHeaderPragmaValue = "no-cache";
   static const String ApiHeaderCacheControlKey = "Cache-Control";
   static const String ApiHeaderCacheControlValue = "no-cache";
   static const String ApiHeaderRefreshKey = "Refresh";
   static const String ApiHeaderRefreshValue = "0";

  String getDevicePlatform() {
    String platform = "";
    if (Platform.isAndroid) {
      platform = PlatformAndroidKey;
    } else if (Platform.isIOS) {
      platform = PlatformIOSKey;
    }

    return platform;
  }

  String getAppBuildNumber() {
    String appBuildNumber = "";
    Map appInfoMap = HiveStorageManager.readAppInfo() ?? {};

    if (appInfoMap.isNotEmpty) {
      appBuildNumber = appInfoMap[APP_INFO_APP_BUILD_NUMBER] ?? "";
    }

    return appBuildNumber;
  }

  String getAppVersion() {
    String appVersion = "";
    Map appInfoMap = HiveStorageManager.readAppInfo() ?? {};

    if (appInfoMap.isNotEmpty) {
      appVersion = appInfoMap[APP_INFO_APP_VERSION] ?? "";
    }

    return appVersion;
  }

  Uri getUri({required String unEncodedPath, Map<String, dynamic>? params}) {
  Uri? uri;

  String authority = HiveStorageManager.readUrlAuthority() ?? WORDPRESS_URL_DOMAIN;
  String communicationProtocol = HiveStorageManager.readCommunicationProtocol() ?? WORDPRESS_URL_SCHEME;
  String urlScheme = WORDPRESS_URL_PATH;

  DefaultLanguageCodeHook defaultLanguageCodeHook = HooksConfigurations.defaultLanguageCode;
  String defaultLanguage = defaultLanguageCodeHook();
  String tempSelectedLanguage = HiveStorageManager.readLanguageSelection() ?? defaultLanguage;

  Locale selectedLocale = Locale(tempSelectedLanguage);
  Map<String, String>? localeMap = L10n.getLocaleMapFromHook(selectedLocale);

  String? customURLCode = localeMap?['languageCodeForURL']; 

  if (customURLCode != null && customURLCode.isNotEmpty) {
    if (!customURLCode.startsWith('/')) {
      customURLCode = '/$customURLCode';
    }

    String combinedPath = '$customURLCode$unEncodedPath';

    Map<String, dynamic> queryParams = {
      ...?params,
      ApiAppVersionKey: getAppVersion(),
      ApiHouziVersionKey: HOUZI_VERSION,
      ApiAppBuildNumberKey: getAppBuildNumber(),
      ApiAppPlatformKey: getDevicePlatform(),
    };

    if (communicationProtocol == HTTP) {
      uri = Uri.http(authority, combinedPath, queryParams);
    } else {
      uri = Uri.https(authority, combinedPath, queryParams);
    }

    return uri;
  }

  if (currentSelectedLocaleUrlPosition == changeUrlPath) {
    if (tempSelectedLanguage != defaultLanguage) {
      urlScheme = "$urlScheme/$tempSelectedLanguage";
    } else {
      urlScheme = urlScheme.replaceFirst(RegExp(r'/$tempSelectedLanguage'), '');
    }
  } else if (currentSelectedLocaleUrlPosition == defaultLangOnUrlAndSecondaryLangAsDirectory) {
    if (tempSelectedLanguage != defaultLanguage) {
      urlScheme = "$urlScheme/$tempSelectedLanguage";
    } else {
      urlScheme = urlScheme.replaceFirst(RegExp(r'/$tempSelectedLanguage'), '');
    }
  } else if (currentSelectedLocaleUrlPosition == changeUrlQueryParameter) {
    params ??= {};
    params[ApiAppLanguageKey] = tempSelectedLanguage;
  }

  if (urlScheme.isNotEmpty) {
    unEncodedPath = "$urlScheme$unEncodedPath";
  }

  Map<String, dynamic> queryParams = {
    ...?params,
    ApiAppVersionKey: getAppVersion(),
    ApiHouziVersionKey: HOUZI_VERSION,
    ApiAppBuildNumberKey: getAppBuildNumber(),
    ApiAppPlatformKey: getDevicePlatform(),
  };

  if (communicationProtocol == HTTP) {
    uri = Uri.http(authority, unEncodedPath, queryParams);
  } else {
    uri = Uri.https(authority, unEncodedPath, queryParams);
  }

  return uri!;
}

  final CacheOptions options = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),
    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error but for statuses 401 & 403.
    // Also allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to [null].
    hitCacheOnErrorExcept: [401, 403],
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to [null].
    maxStale: const Duration(minutes: 10),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended when [true].
    allowPostMethod: false,
  );

  Dio getDio({bool isNonce = false, bool forceExcludeCache = false}) {
    String token = HiveStorageManager.getUserToken() ?? "";
    Map<String, dynamic> headerHookMap = HiveStorageManager.readSecurityKeyMapData() ?? {};
    Map<String, dynamic> headerMap = {};

    if (!isNonce && token.isNotEmpty) {
      headerMap[ApiHeaderAuthorizationKey] = "$ApiHeaderBearerString $token";
    }

    if (forceExcludeCache) {
      headerMap[ApiHeaderPragmaKey] = ApiHeaderPragmaValue;
      headerMap[ApiHeaderCacheControlKey] = ApiHeaderCacheControlValue;
      headerMap[ApiHeaderRefreshKey] = ApiHeaderRefreshValue;
    }

    headerHookMap.removeWhere((key, value) => (value == null || value.isEmpty));
    if (headerHookMap.isNotEmpty) {
      headerMap.addAll(headerHookMap);
    }

    if (forceExcludeCache && headerMap.isNotEmpty) {
      Dio dio = Dio()
        ..options.headers = headerMap;

      return dio;
    }

    if (headerMap.isNotEmpty) {
      Dio dio = Dio()
        ..interceptors.add(DioCacheInterceptor(options: options))
        ..options.headers = headerMap;

      return dio;
    }

    Dio dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    return dio;
  }

   Future refreshToken() async {
    ApiManager _apiManager = ApiManager();
     print("Refreshing token.......................");
     // get user info from storage
     Map<String, String> _userInfo = HiveStorageManager.readUserCredentials();

     if (_userInfo.isNotEmpty) {
       // fetch nonce and update it in _user info
       String nonce = "";
       ApiResponse<String> nonceResponse = await _apiManager.fetchSignInNonceResponse();

       if (nonceResponse.success) {
         nonce = nonceResponse.result;
         _userInfo[API_NONCE] = nonce;

         late ApiResponse<UserLoginInfo?> response;

         if (_userInfo.containsKey(USER_SOCIAL_PLATFORM)) {
           response = await _apiManager.socialSignOn(_userInfo, nonce);
         } else {
           response = await _apiManager.login(_userInfo, nonce);
         }

         if (response.success && response.internet && response.result != null) {
           UserLoginInfo info = response.result!;
           Map<String, dynamic> userLoginData = _apiManager.convertUserLoginInfoToJson(info);
           HiveStorageManager.storeUserLoginInfoData(userLoginData);
         }
       }
     }
   }

   Future<Response> doRequestOnRoute(
       var uri,
       {
         Dio? dio,
         int type = GET,
         Map<String, dynamic>? formParams,
         FormData? formData,
         String tag = "",
         String? nonce = "",
         String nonceVariable = "",
         int tries = 1,
         bool handle500 = false,
         bool handle403 = true,
         bool useCache = true,
         bool isNonce = false,
         bool forceExcludeCache = false,
       }) async {
     try{
       dio ??= getDio(isNonce: isNonce, forceExcludeCache: forceExcludeCache);
       print("tag: $tag");
       print("uri: $uri");

       if (handle500) {
         dio.options.responseType = ResponseType.plain;
       }

       if (type == GET) {
         var response = await dio.getUri(uri);
         return response;
       }

       else if (type == POST) {

         if (formData != null) {
           var response = await dio.postUri(uri, data: formData);
           return response;
         }

         if (formParams != null && nonce != null && nonce.isNotEmpty) {
           formParams[nonceVariable] = nonce;
         }

         var response = await dio.postUri(uri, data: FormData.fromMap(formParams ?? {}));
         return response;
       }
     } on DioError catch (dioError) {
       if (dioError.response != null) {

         if (handle500) {
           return dioError.response!;
         }

         if (handle403) {
           if (dioError.response!.statusCode! == 403 || dioError.response!.statusCode! == 401) {
             if (tries <= MAX_TRIES) {
               await refreshToken();
               return doRequestOnRoute(
                 uri,
                 type: type,
                 formParams: formParams,
                 tag: tag,
                 tries: ++tries,
               );
             }
           }
         }
         if (kDebugMode) {
           print("$tag: error code = ${dioError.response!.statusCode}");
           print("$tag: error message = ${dioError.message}");
         }
         return dioError.response!;
       } else {
         if (kDebugMode) {
           print('$tag Response Error: ${dioError.error}');
         }
         return Response(
           requestOptions: RequestOptions(path: ''),
           statusMessage: dioError.error.toString(),
           statusCode: null,
         );
       }
     }
     return Response(
       requestOptions: RequestOptions(path: ''),
       statusMessage: "",
       statusCode: null,
     );
   }
}