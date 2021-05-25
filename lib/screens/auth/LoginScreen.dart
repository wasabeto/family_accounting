import 'package:family_accounting/AppThemeNotifier.dart';
import 'package:family_accounting/ServiceLocator.dart';
import 'package:family_accounting/models/UserModel.dart';
import 'package:family_accounting/screens/auth/ForgotPasswordScreen.dart';
import 'package:family_accounting/screens/auth/RegisterScreen.dart';
import 'package:family_accounting/screens/tabs/FamilyAccountingFullApp.dart';
import 'package:family_accounting/providers/APIProvider.dart';
import 'package:family_accounting/services/LocalStorageService.dart';
import 'package:family_accounting/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppTheme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeData themeData;
  bool _passwordVisible = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final APIProvider _apiProvider = APIProvider();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                backgroundColor: themeData.scaffoldBackgroundColor,
                body: Container(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Text(
                              "Welcome!",
                              style: AppTheme.getTextStyle(themeData.textTheme.headline6, fontWeight: 600),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: TextFormField(
                            controller: _emailController,
                            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1, letterSpacing: 0.1, color: themeData.colorScheme.onBackground, fontWeight: 500),
                            decoration: InputDecoration(
                              hintText: "Email address",
                              hintStyle: AppTheme.getTextStyle(themeData.textTheme.subtitle2, letterSpacing: 0.1, color: themeData.colorScheme.onBackground, fontWeight: 500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: themeData.colorScheme.background,
                              prefixIcon: Icon(
                                MdiIcons.emailOutline,
                                size: MySize.size22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: TextFormField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: _passwordVisible,
                            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1, letterSpacing: 0.1, color: themeData.colorScheme.onBackground, fontWeight: 500),
                            decoration: InputDecoration(
                              hintStyle: AppTheme.getTextStyle(themeData.textTheme.subtitle2, letterSpacing: 0.1, color: themeData.colorScheme.onBackground, fontWeight: 500),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: themeData.colorScheme.background,
                              prefixIcon: Icon(
                                MdiIcons.lockOutline,
                                size: MySize.size22,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(
                                  _passwordVisible ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                                  size: MySize.size22,
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2, fontWeight: 500),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(MySize.size28)),
                            boxShadow: [
                              BoxShadow(
                                color: themeData.primaryColor.withAlpha(24),
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: ElevatedButton(
                            style: ButtonStyle(padding: MaterialStateProperty.all(Spacing.xy(16, 0))),
                            onPressed: () {
                              _apiProvider.sendRequest(
                                {'username': _emailController.value.text, 'password': _passwordController.value.text},
                                {'method': 'POST', 'endPoint': '/auth/login'},
                              ).then((response) {
                                var storageService = locator.get<LocalStorageService>();
                                storageService.setUser(new User(
                                  id: response['user']['id'],
                                  email: response['user']['email'],
                                  fullName: response['user']['fullName'],
                                ));
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyAccountingFullApp()));
                              });
                            },
                            child: Text(
                              "Sign in",
                              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2, fontWeight: 600).merge(TextStyle(color: themeData.colorScheme.onPrimary)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                              },
                              child: Text(
                                "I haven't an account",
                                style: AppTheme.getTextStyle(themeData.textTheme.bodyText2, decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  storeLoginDetails(loginResponse) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("accessToken", loginResponse['accessToken']['token']);
    sharedPreferences.setInt("expireIn", loginResponse['accessToken']['expireIn']);
    sharedPreferences.setString("userId", loginResponse['user']['id']);
    sharedPreferences.setString("userName", loginResponse['user']['fullName']);
    sharedPreferences.setString("userEmail", loginResponse['user']['email']);
  }
}
