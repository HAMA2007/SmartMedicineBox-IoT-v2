import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './DashBoard.dart';
import 'RegsiterHub.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

///
class _SignInPageState extends State<SignInPage> {
  bool passwordVisible = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Login 함수
  Future<String> login(String _email, String _password) async {
    http.Response response = await http.post(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'userId': _email,
          'password': _password,
        }));

    if (response.statusCode == 200) {
      return "로그인 성공";
    } else if (response.statusCode == 400) {
      return "올바르지 않은 아이디 및 패스워드";
    } else {
      return "존재하지 않는 아이디 이거나 비밀번호가 불일치 합니다.";
    }
  }

  //Get Bottle List 함수
  Future<String> getHubList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response =
        await http.get(Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'));
    if (response.statusCode == 200) {
      return "get완료";
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mqData = MediaQuery.of(context);
    final mqDataScale = mqData.copyWith(textScaleFactor: 1.0);

    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          //Navigator.pop(context);
          Navigator.of(context).pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 18, right: 18),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text('로그인',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 34,
                                    fontFamily: 'Noto',
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: new Column(
                              children: <Widget>[
                                MediaQuery(
                                  data: mqDataScale,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: '이메일',
                                      helperText: '이메일 주소를 입력해주세요.',
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      errorText: _validateEmail
                                          ? '등록되지 않은 아이디입니다.'
                                          : null,
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000)),
                                      helperStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffb2b2b2)),
                                      // Here is key idea
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: new Column(
                              children: <Widget>[
                                MediaQuery(
                                  data: mqDataScale,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    obscureText:
                                        !passwordVisible, //This will obscure text dynamically
                                    decoration: InputDecoration(
                                      labelText: '비밀번호',
                                      helperText: '비밀번호를 입력해 주세요.',
                                      errorText: _validatePassword
                                          ? '비밀번호가 일치하지 않습니다.'
                                          : null,
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000)),
                                      helperStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffb2b2b2)),
                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color(0xff2c2c2c),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.8,
                                height: 46,
                                child: RaisedButton(
                                  color: Color(0xff1674f6),
                                  child: Text("로그인",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Noto',
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    String saveMessage = await login(
                                        emailController.text,
                                        passwordController.text);
                                    if (emailController.text.isEmpty ||
                                        passwordController.text.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text('이메일 & 비밀번호'),
                                              content: new Text(
                                                  '이메일과 비밀번호를 입력해주세요.'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                    child: new Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            );
                                          });
                                    } else {
                                      saveMessage = "로그인 성공";
                                      if (saveMessage == "로그인 성공") {
                                        var result = await getHubList();
                                        print(result);
                                        if (result == "Not Found") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        RegsiterHub(),
                                              ));
                                        } else if (result == "get완료") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    DashBoard(pageNumber: 1),
                                              ));
                                        } else {}
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
