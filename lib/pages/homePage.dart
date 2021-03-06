import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/banner_entity.dart';
import 'package:wanandroid_flutter/entity/common_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';
import 'package:wanandroid_flutter/widget/my_phoenix_footer.dart' as myPhoenixFooter;
import 'package:wanandroid_flutter/widget/my_phoenix_header.dart' as myPhoenixHeader;

import 'loginPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerData> bannerDatas = List();
  List<ArticleDataData> articleDatas = List();

  ScrollController _scrollController;
  SwiperController _swiperController;

  int _page = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {});
    _swiperController = SwiperController();

    getHttp();
  }

  void getHttp() async {
    try {
      //banner
      var bannerResponse = await HttpUtil().get(Api.BANNER);
      Map bannerMap = json.decode(bannerResponse.toString());
      var bannerEntity = BannerEntity.fromJson(bannerMap);

      //article
      var articleResponse =
          await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json");
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

      setState(() {
        bannerDatas = bannerEntity.data;
        articleDatas = articleEntity.data.datas;
      });

      _swiperController.startAutoplay();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        header: myPhoenixHeader.PhoenixHeader(),
        footer: myPhoenixFooter.PhoenixFooter(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _page = 0;
            });
            getHttp();
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () async {
            setState(() {
              _page++;
            });
            getMoreData();
          });
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) return getBanner();
                if (index < articleDatas.length - 1) //??????banner??????
                  return getRow(index);
                return null;
              },
              childCount: articleDatas.length + 1, //+1 ??????banner??????
            ),
          ),
        ],
      ),
    );
  }

  Widget getBanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //1.8???banner????????????0.8???viewportFraction??????
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        itemCount: bannerDatas.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((10.0)), // ?????????
              image: DecorationImage(
                image: NetworkImage(bannerDatas[index].imagePath),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        loop: false,
        autoplay: false,
        autoplayDelay: 3000,
        //???????????????????????????
        autoplayDisableOnInteraction: true,
        duration: 600,
        //??????????????????
//        control: SwiperControl(),
        controller: _swiperController,
        //???????????????
        pagination: SwiperPagination(
          // SwiperPagination.fraction ??????1/5????????????
          builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9),
        ),

        //???????????????????????????item??????????????????
        viewportFraction: 0.8,
        //??????item????????????
        scale: 0.9,

        onTap: (int index) {
          //???????????????????????????
          print("index-----" + index.toString());
        },
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListTile(
            leading: IconButton(
              icon: articleDatas[i].collect
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(Icons.favorite_border),
              tooltip: '??????',
              onPressed: () {
                if (articleDatas[i].collect) {
                  cancelCollect(articleDatas[i].id);
                } else {
                  addCollect(articleDatas[i].id);
                }
              },
            ),
            title: Text(
              articleDatas[i].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular((20.0)), // ?????????
                    ),
                    child: Text(
                      articleDatas[i].superChapterName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(articleDatas[i].author),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          )),
      onTap: () {
        if (0 == 1) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(
                title: articleDatas[i].title, url: articleDatas[i].link),
          ),
        );
      },
    );
  }

  Future addCollect(int id) async {
    var collectResponse = await HttpUtil().post(Api.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "????????????");
      getHttp();
    }
  }

  Future cancelCollect(int id) async {
    var collectResponse =
        await HttpUtil().post(Api.UN_COLLECT_ORIGIN_ID + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "????????????");
      getHttp();
    }
  }

  Future getMoreData() async {
    var response = await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json");
    Map map = json.decode(response.toString());
    var articleEntity = ArticleEntity.fromJson(map);
    setState(() {
      articleDatas.addAll(articleEntity.data.datas);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }
}
