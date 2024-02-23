import 'dart:convert';
import '../../generated/json/base/json_convert_content.dart';

class ApiResponseEntity<T> {
	int? errorCode;
	String? errorMsg;
	T? data;

	ApiResponseEntity();

	factory ApiResponseEntity.fromJson(Map<String, dynamic> json) => $ApiResponseEntityFromJson<T>(json);

	Map<String, dynamic> toJson() => $ApiResponseEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
ApiResponseEntity<T> $ApiResponseEntityFromJson<T>(Map<String, dynamic> json) {
	final ApiResponseEntity<T> apiResponseEntity = ApiResponseEntity<T>();
	final int? errorCode = jsonConvert.convert<int>(json['errorCode']);
	if (errorCode != null) {
		apiResponseEntity.errorCode = errorCode;
	}
	final String? errorMsg = jsonConvert.convert<String>(json['errorMsg']);
	if (errorMsg != null) {
		apiResponseEntity.errorMsg = errorMsg;
	}
	final T? data = jsonConvert.convert<T>(json['data']);
	if (data != null) {
		apiResponseEntity.data = data;
	}
	return apiResponseEntity;
}

Map<String, dynamic> $ApiResponseEntityToJson(ApiResponseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['errorCode'] = entity.errorCode;
	data['errorMsg'] = entity.errorMsg;
	data['data'] = entity.data;
	return data;
}