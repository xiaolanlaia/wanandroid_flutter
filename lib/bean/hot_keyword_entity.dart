

import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/hot_keyword_entity.g.dart';

@JsonSerializable()
class HotKeywordEntity {
	late int id;
	late String link;
	late String name;
	late int order;
	late int visible;

	HotKeywordEntity();

	factory HotKeywordEntity.fromJson(Map<String, dynamic> json) => $HotKeywordEntityFromJson(json);

	Map<String, dynamic> toJson() => $HotKeywordEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}