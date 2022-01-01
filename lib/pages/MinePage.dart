import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/res/colors.dart';
class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor
      ),
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColorDark
            ]
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: getBodyView(),
        ),
      ),
    );
  }

  Widget getBodyView(){

    return ListView(
      children: [
        SizedBox(height: 80),
        Stack(alignment: Alignment.topCenter,children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.all(40),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person_outline),
                          labelText: '请输入账号',
                        ),
                        validator:(value){
                          if(value.isEmpty){
                            return "账号不能为空";
                          }
                          return null;
                        },
                        onSaved: (text){
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          labelText: '请输入密码'
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return '密码为空';
                          }
                          return null;
                        },
                        onSaved: (text){
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 20,),
                      Offstage(
                        offstage: true,
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline),
                                labelText: '请确认密码'
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return '密码为空';
                                }
                                return null;
                              },
                              onSaved: (text){

                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 40,
              left: MediaQuery.of(context).size.width / 2 - 35,
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("lib/res/images/ic_logo.png"),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,0),
                        color: Colors.grey,
                        blurRadius: 8,
                        spreadRadius: 1
                      ),
                    ],
                  ),
                ),

          )),
          Positioned(
              bottom: 20,
              left: 130,
              right: 130,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                elevation: 5,
                highlightElevation: 10,
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "登录",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPressed: (){

                  setState(() {

                  });

                }
              ),
          ),
        ]),
        GestureDetector(
          child: Text(
            "没有账号？注册",
            style: TextStyle(color: YColors.color_fff),
            textAlign: TextAlign.center,
          ),
          onTap: (){
            setState(() {

            });
          },
        )
      ],
    );
  }

}