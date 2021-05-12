import 'package:flutter/material.dart';
import 'package:image_cloud_server/general_widgets/button.dart';
import 'package:image_cloud_server/general_widgets/icon.dart';
import 'package:image_cloud_server/providers/auth_provider.dart';
import 'package:image_cloud_server/utils/design.dart';
import 'package:image_cloud_server/utils/text.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthProvider? authProvider;

  String type = 'Login';
  String errorText = '';
  LoadState loadState = LoadState.idle;

  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();
  var usernameCon = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              Container(
                height: 200,
                alignment: Alignment.centerLeft,
                child: AppIcon(iconSize: AppIconSize.big),
              ),
              logRegText(),
              (type == 'Login')
                  ? Container()
                  : textField('Username', usernameCon),
              textField('Email', emailCon),
              textField('Password', passwordCon, hide: true),
              forgotPassword(),
              loader(),
              SizedBox(height: 15),
              LButton(
                text: type.toUpperCase(),
                onPressed: logOrReg,
                color: (type == 'Login') ? Design.kRed : Design.kYellow,
              )
            ],
          ),
        ),
      ),
    );
  }

  logOrReg() async {
    setLoadState(state: LoadState.loading);

    String email = emailCon.text;
    String password = passwordCon.text;
    String username = usernameCon.text;

    print('$email, $password, $username');

    if (email == '' || password == '') {
      setLoadState(
        state: LoadState.failed,
        errorText: 'Invalid email and password',
      );
      return;
    }

    bool? success;
    if (type == 'Login') {
      success = await authProvider?.login(
        email: email,
        password: password,
      );
    } else {
      if (username == '') {
        setLoadState(
          state: LoadState.failed,
          errorText: 'Invalid account details',
        );

        return;
      }

      success = await authProvider?.register(
        username: username,
        email: email,
        password: password,
      );
    }

    if (success ?? false) {
      setLoadState(state: LoadState.success);

      Navigator.pushNamed(context, '/home');
      return;
    }

    setLoadState(
      state: LoadState.failed,
      errorText: 'An Error Occured',
    );
  }

  setLoadState({LoadState? state, String? errorText}) {
    print(errorText);
    if (mounted) {
      setState(() {
        loadState = state ?? LoadState.idle;
        this.errorText = errorText ?? '';
      });
    }
  }

  Widget logRegText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textHead('Login', Design.kRed),
        textHead('SignUp', Design.kYellow),
      ],
    );
  }

  Widget textHead(
    String type,
    Color color,
  ) {
    Widget? child;

    if (this.type == type) {
      child = Text(
        type,
        style: TextDesign.bigBold(),
      );
    } else {
      child = Text(
        type,
        style: TextDesign.normal(color: color),
      );
    }

    return GestureDetector(
      onTap: () {
        this.type = type;
        setState(() {});
      },
      child: child,
    );
  }

  Widget forgotPassword() {
    if (type == 'Login')
      return Container(
        alignment: Alignment.centerRight,
        height: 100,
        child: Text(
          'Forgot password?',
          style: TextDesign.normal(),
        ),
      );

    return Container(height: 60);
  }

  Widget loader() {
    switch (loadState) {
      case LoadState.loading:
        return Container(
          width: 100,
          child: LinearProgressIndicator(
            backgroundColor: Design.textField,
            valueColor: AlwaysStoppedAnimation(Design.kRed),
          ),
        );

      case LoadState.failed:
        return Text(
          errorText,
          style: TextDesign.normal(color: Colors.redAccent),
        );

      default:
        return Container();
    }
  }

  Widget textField(String text, TextEditingController con, {bool? hide}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 38, 0, 0),
      child: TextField(
        controller: con,
        obscureText: hide ?? false,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextDesign.textField(),
          enabledBorder: FieldBorder.border(),
          focusedBorder: FieldBorder.border(),
          filled: true,
          fillColor: Design.textField,
        ),
      ),
    );
  }
}
