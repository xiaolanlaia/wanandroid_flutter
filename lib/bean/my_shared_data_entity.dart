

import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/my_shared_data_entity.g.dart';
import 'article_data_entity.dart';

@JsonSerializable()
class MySharedDataEntity {
	late MySharedDataCoinInfo coinInfo;
	late MySharedDataShareArticles shareArticles;

	MySharedDataEntity();

	factory MySharedDataEntity.fromJson(Map<String, dynamic> json) => $MySharedDataEntityFromJson(json);

	Map<String, dynamic> toJson() => $MySharedDataEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MySharedDataCoinInfo {
	late int coinCount;
	late int level;
	late String nickname;
	late String rank;
	late int userId;
	late String username;

	MySharedDataCoinInfo();

	factory MySharedDataCoinInfo.fromJson(Map<String, dynamic> json) => $MySharedDataCoinInfoFromJson(json);

	Map<String, dynamic> toJson() => $MySharedDataCoinInfoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MySharedDataShareArticles {
	late int curPage;
	late List<ArticleItemEntity> datas;
	late int offset;
	late bool over;
	late int pageCount;
	late int size;
	late int total;

	MySharedDataShareArticles();

	factory MySharedDataShareArticles.fromJson(Map<String, dynamic> json) => $MySharedDataShareArticlesFromJson(json);

	Map<String, dynamic> toJson() => $MySharedDataShareArticlesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}