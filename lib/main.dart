import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as dev;

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

void main() => runApp(MaterialApp(
      title: 'Google Login',
      home: SigninDemo(),
    ));

class SigninDemo extends StatefulWidget {
  @override
  _SigninDemoState createState() => _SigninDemoState();
}

class _SigninDemoState extends State<SigninDemo> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event;
      });


    });

    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Signin'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text(_currentUser.displayName),
            subtitle: Text(_currentUser.email),
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
          ),
          RaisedButton(
              child: Text('Signout'),
              onPressed: () {
                _handleSignOut();
                dev.debugger();
              })
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You are not signed in..'),
          RaisedButton(
              child: Text('Signin'),
              onPressed: () {
                _handleSignIn();
                dev.debugger();
              })
        ],
      );
    }
  }
}

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> _handleSignOut() async {
  _googleSignIn.disconnect();
}
