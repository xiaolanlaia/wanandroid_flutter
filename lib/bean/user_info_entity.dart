import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
	late bool admin;
	late List<dynamic> chapterTops;
	late int coinCount;
	late List<int> collectIds;
	late String email;
	late String icon;
	late int id;
	late String nickname;
	late String password;
	late String publicName;
	late String token;
	late int type;
	late String username;

	UserInfoEntity();

	factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}