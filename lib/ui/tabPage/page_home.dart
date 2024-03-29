import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wanandroid_flutter/utils/log_utils.dart';
import '../../bean/article_data_entity.dart';
import '../../bean/banner_entity.dart';
import '../../bean/base/api_response_entity.dart';
import '../../network/api.dart';
import '../../network/request_util.dart';
import '../article_item_layout.dart';
import '../base/base_page.dart';
import '../detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BasePage<HomePage>, AutomaticKeepAliveClientMixin {
  var _pageIndex = 0;
  List<ArticleItemEntity> _articleList = List.empty();
  List<BannerEntity>? bannerData;

  var retryCount = 0.obs;

  var dataUpdate = 0.obs;

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refreshRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              return RetryWidget(onTapRetry: () => retryCount.value++);
            }
            return Obx(() {
              LogUtils.i("data update: ${dataUpdate.value}");
              return Scaffold(
                body: EasyRefresh.builder(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoad: _loadRequest,
                  childBuilder: (context, physics) {
                    return CustomScrollView(
                      physics: physics,
                      slivers: [
                        if (bannerData != null && bannerData!.isNotEmpty)
                          SliverToBoxAdapter(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        enableInfiniteScroll: true,
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        enlargeCenterPage: true,
                                        enlargeStrategy:
                                        CenterPageEnlargeStrategy.height),
                                    items: _bannerList(),
                                  ))),
                        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Get.to(() => DetailPage(
                                        _articleList[index].link,
                                        _articleList[index].title));
                                  },
                                  child: ArticleItemLayout(
                                      itemEntity: _articleList[index],
                                      onCollectTap: () {
                                        _onCollectClick(_articleList[index]);
                                      }));
                            }, childCount: _articleList.length))
                      ],
                    );
                  },
                ),
              );
            });
          } else {
            return const Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void _onRefresh() async {
    await _refreshRequest();
    _refreshController.finishRefresh();
    dataUpdate.refresh();
  }

  void _loadRequest() async {
    _pageIndex++;
    ApiResponseEntity<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>("${Api.homePageArticle}$_pageIndex/json");
    if (res.isSuccessful) {
      _articleList.addAll(res.data?.datas ?? List.empty());
    }
    _refreshController.finishLoad();
    dataUpdate.refresh();
  }

  Future<bool> _refreshRequest() async {
    _pageIndex = 0;

    bool resultStatus = true;

    List<ArticleItemEntity> result = [];

    ApiResponseEntity<List<BannerEntity>> bannerRes = await HttpGo.instance.get(Api.banner);
    bannerData = bannerRes.data;
    resultStatus &= bannerRes.isSuccessful;

    LogUtils.d("__request-banner: isSuccessful:${bannerRes.isSuccessful} code:${bannerRes.errorCode} msg:${bannerRes.errorMsg} data:${bannerRes.data}");

    ApiResponseEntity<List<ArticleItemEntity>> topRes = await HttpGo.instance.get(Api.topArticle);
    if (topRes.isSuccessful) {
      result.addAll(topRes.data ?? List.empty());
    }
    resultStatus &= topRes.isSuccessful;
    LogUtils.d("__request-topRes:${topRes.data.toString()}");

    ApiResponseEntity<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>("${Api.homePageArticle}$_pageIndex/json");
    resultStatus &= res.isSuccessful;
    LogUtils.d("__request-res:${res.data.toString()}");

    if (res.isSuccessful) {
      result.addAll(res.data?.datas ?? List.empty());
    }
    _articleList = result;
    return resultStatus;
  }

  List<Widget> _bannerList() => bannerData!
      .map((e) => Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(6))
      ),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            e.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
          ))))
      .toList();

  _onCollectClick(ArticleItemEntity itemEntity) async {
    bool collected = itemEntity.collect;
    ApiResponseEntity<dynamic> res = await (collected
        ? HttpGo.instance.post("${Api.uncollectArticel}${itemEntity.id}/json")
        : HttpGo.instance.post("${Api.collectArticle}${itemEntity.id}/json"));

    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: collected ? "取消收藏！" : "收藏成功！");
      itemEntity.collect = !itemEntity.collect;
    } else {
      Fluttertoast.showToast(
          msg: (collected ? "取消失败 -- " : "收藏失败 -- ") +
              (res.errorMsg ?? res.errorCode.toString()));
    }
  }

    @override
  bool get wantKeepAlive => true;

}
