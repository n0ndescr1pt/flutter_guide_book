```shell
flutter pub add dio
flutter pub add dio_exeptions
flutter pub add talker_dio_logger
```

Создаем класс обертку для дио
```dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_api/dio_exeptions.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

class ApiProvider {
	final Dio _dio;
	final TalkerDioLogger talkerDioLogger;

	ApiProvider({required this.talkerDioLogger, required String baseUrl})
		: _dio = Dio(BaseOptions(
			baseUrl: baseUrl,
			receiveTimeout: const Duration(seconds: 20),
			connectTimeout: const Duration(seconds: 20),
			sendTimeout: const Duration(seconds: 20),
		)) {

	_dio.interceptors.add(InterceptorsWrapper(
		onError: (DioException e, handler) {
			_handleError(e);
			return handler.next(e);
		},
		onRequest: (options, handler) {
			_handleRequest(options);
			return handler.next(options);
			},
		));
	}
	  
	
	Future<dynamic> apiCall(String url,
		{Map<String, dynamic>? queryParameters,
		Map<String, dynamic>? body,
		required RequestType requestType}) async {
	late Response response;
	try {
	switch (requestType) {
		case RequestType.get:
		{
			response = await _dio.get(url, queryParameters: queryParameters);
			break;
		}
		case RequestType.post:
		{
			response = await _dio.post(url, data: body);
			break;
		}
		case RequestType.delete:
		{
			response = await _dio.delete(url, queryParameters: queryParameters);
			break;
		}
		case RequestType.put:
		{
			response = await _dio.put(url, data: body);
			break;
		}
		return response.data;
		
	} catch (error) {
		if (error is Exception) {
			rethrow;
		} else {
			throw Exception("Unexpected error: $error");
			}
		}
	}
	
	static void _handleError(DioException e) {
	switch (e.type) {
		case DioExceptionType.connectionTimeout:
		case DioExceptionType.sendTimeout:
		case DioExceptionType.receiveTimeout:
			throw TimeoutException(e.requestOptions.toString());
		case DioExceptionType.cancel:
			break;
		case DioExceptionType.unknown:
			throw NoInternetConnectionException(e.requestOptions);
		case DioExceptionType.badCertificate:
			throw BadCertificateExeption(e.requestOptions);
		case DioExceptionType.connectionError:
			throw InternalServerErrorException(e.requestOptions);
		case DioExceptionType.badResponse:
			switch (e.response?.statusCode) {
				case 400:
					throw BadRequestException(e.requestOptions);
				case 401:
					throw UnauthorizedException(e.requestOptions);
				case 404:
					throw NotFoundException(e.requestOptions);
				case 409:
					throw ConflictException(e.requestOptions);
				case 500:
					throw InternalServerErrorException(e.requestOptions);
			}
			break;
		}
	}
}

enum RequestType { get, post, put, delete }
```

#### Создание
```dart
final talker = TalkerFlutter.init(
filter: BaseTalkerFilter(types: []),
settings: TalkerSettings(enabled: true),
);

final talkerDioLogger = TalkerDioLogger(
talker: talker,
settings: const TalkerDioLoggerSettings(printResponseData: false));

final ApiProvider apiProvider = ApiProvider(
talkerDioLogger: talkerDioLogger,
baseUrl: "https://petstore.swagger.io/v2");
)
```

#### Использование
```dart
final response = apiProvider.apiCall("/store/inventory",
	requestType: RequestType.get),
```

#### Пояснение

Интерцепторы это специальные функции, которые позволяют вам контролировать и модифицировать HTTP запросы и ответы. Они используются для добавления заголовков, обработки ошибок и других операций до отправки запроса на сервер или после получения ответа.
```dart
// Добавление перехватчика запросов
_dio.interceptors.add(InterceptorsWrapper(
		onError: (DioException e, handler) {
		// Выполняется при возникновении ошибки
			_handleError(e);

			// Передать управление следующему интерцептору
			return handler.next(e);
		},
		onRequest: (options, handler) {
		// Выполняется перед отправкой запроса на сервер
			_handleRequest(options);
			
			// Передать управление следующему интерцептору
			return handler.next(options);
			
			},
		));
	}
```
