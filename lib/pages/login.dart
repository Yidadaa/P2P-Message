import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/api.dart';
import '../utils/navigate.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  bool isLogin = true;
  bool isProcessing = false;
  TextEditingController userController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  TextEditingController pwdConfirmController = new TextEditingController();

  List<Widget> buildForm() {
    final errorStyle = new TextStyle(
      fontSize: 12.0,
      color: Colors.blueGrey
    );


    TextFormField user = new TextFormField(
      validator: (v) {
        if (v.isEmpty) {
          return "用户名不能为空";
        }
      },
      controller: userController,
      decoration: new InputDecoration(
        hintText: "您的用户名",
        labelText: "用户名",
        errorStyle: errorStyle,
        prefixIcon: new Icon(
          Icons.person,
          size: 30.0,
        ),
      ),
    );
    TextFormField pwd = new TextFormField(
      obscureText: true,
      controller: pwdController,
      validator: (v) {
        if (v.length < 5 || v.length > 20) {
          return "密码为长度5-20的字符";
        }
      },
      decoration: new InputDecoration(
        hintText: "在这里输入密码",
        labelText: "密码",
        errorStyle: errorStyle,
        prefixIcon: new Icon(
          Icons.security,
          size: 30.0,
        ),
      ),
    );
    TextFormField pwdConfirm = new TextFormField(
      obscureText: true,
      controller: pwdConfirmController,
      validator: (v) {
        if (v != pwdController.text) {
          return "请保证两次输入的密码一致";
        }
      },
      decoration: new InputDecoration(
        hintText: "重复您的密码",
        labelText: "确认密码",
        errorStyle: errorStyle,
        prefixIcon: new Icon(
          Icons.verified_user,
          size: 30.0,
        ),
      ),
    );

    return isLogin ? [user, pwd] : [user, pwd, pwdConfirm];
  }

  void toggleFormType() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void setProcessing(bool status) {
    setState(() {
      isProcessing = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blueGrey,
    ));
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new ListView(
        children: <Widget>[
          new Container(
              height: 300.0,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white, Colors.blueGrey]
                ),
              ),
              child: new Column(
                children: <Widget>[
                  new Container(
                      width: 400.0,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 180.0, left: 20.0),
                        child: new DefaultTextStyle(
                          style: new TextStyle(
                              fontSize: 35.0, color: Colors.blueGrey),
                          child: new Text("欢迎，\n开始您的新旅程吧"),
                        ),
                      ))
                ],
              )),
          new Container(
            child: new Padding(
              padding: EdgeInsets.all(15.0),
              child: new Form(
                key: formKey,
                child: new Column(children: buildForm()),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
            child: new RaisedButton(
              onPressed: () async {
                if(formKey.currentState.validate() && !isProcessing) {
                  setProcessing(true);
                  var res;
                  if(isLogin) {
                    res = await login(userController.text, pwdController.text);
                  } else {
                    res = await signin(userController.text, pwdController.text);
                  }
                  print(res);
                  if (res['success']) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('user', jsonEncode(res));
                    redirectTo(context, '/home', res);
                  }
                  setProcessing(false);
                }
              },
              color: Colors.blueGrey,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: new DefaultTextStyle(
                    style: new TextStyle(fontSize: 18.0),
                    child: new Padding(
                      padding: EdgeInsets.all(15.0),
                      child: isProcessing
                          ? new Center(
                              child: new SizedBox(
                                height: 24.0,
                                width: 24.0,
                              child: new CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ))
                          : new Text("确认" + (isLogin ? "登录" : "注册"),
                              textAlign: TextAlign.center),
                    ),
                  )),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: new RaisedButton(
              onPressed: () {
                // 切换登录页的类型
                toggleFormType();
                setProcessing(false);
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: new DefaultTextStyle(
                    style:
                        new TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                    child: new Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new Text(isLogin ? "注册新账号" : "已有账号，直接登录",
                          textAlign: TextAlign.center),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
