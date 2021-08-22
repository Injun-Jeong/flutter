import 'dart:async';
import 'dart:convert';    // 인라인에서 JSON 직렬화를 위한, jsonDecode() 함수를 가진 라이브러리

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<User> fetchUser() async {
  final response = await http.get(Uri.parse('http://158.247.203.166:3000/users/ns165'));

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

// json 형태로 넘어오는 데이터를 받기 위한 객체 생성
class User {
  final String userId;
  final String account;
  final String firstName;
  final String lastName;
  final String nation;
  final String pw;
  final String rippleAccount;

  User({required this.userId,
    required this.account,
    required this.firstName,
    required this.lastName,
    required this.nation,
    required this.pw,
    required this.rippleAccount});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      account: json['account'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      nation: json['nation'],
      pw: json['pw'],
      rippleAccount: json['rippleAccount'],
    );
  }
}



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.firstName);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

