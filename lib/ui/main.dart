import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wanandroid_flutter/provider/user.dart';
import 'package:wanandroid_flutter/ui/page_main.dart';
import 'package:wanandroid_flutter/utils/constants.dart';
import 'package:wanandroid_flutter/utils/error_handle.dart';
import 'package:wanandroid_flutter/utils/log_utils.dart';

import '../network/request_util.dart';

//将main函数转为异步方法，使得可以在方法中使用await
Future<void> main() async {
  //是能够抛出异常
  handleError(() async {
    //允许app运行之前与Flutter Engine 进行通信
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化mmkv
    final rootDir = await MMKV.initialize();
    LogUtils.i("mmkv rootDir: ${rootDir}");

    // 加载本地用户信息
    User().loadFromLocal();
    // 初始化dio
    configDio(baseUrl: Constant.baseUrl);
    //设置配置URL策略
    setPathUrlStrategy();

    runApp(ChangeNotifierProvider(create:(context) => User(), child: const MyApp()));
  });
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'WanAndroidFlutter'),
    );
  }
}
