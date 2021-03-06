import 'package:family_accounting/AppThemeNotifier.dart';
import 'package:family_accounting/ServiceLocator.dart';
import 'package:family_accounting/models/UserModel.dart';
import 'package:family_accounting/screens/SelectThemeDialog.dart';
import 'package:family_accounting/screens/auth/LoginScreen.dart';
import 'package:family_accounting/services/LocalStorageService.dart';
import 'package:family_accounting/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class TextIconItem {
  String key;
  String text;
  IconData iconData;

  TextIconItem(this.key, this.text, this.iconData);
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _passwordVisible = false;
  ThemeData themeData;
  User _userDetails;

  @override
  void initState() {
    super.initState();
    var storageService = locator.get<LocalStorageService>();
    setState(() {
      _userDetails = storageService.getUser();
    });
  }

  List<TextIconItem> _textIconChoice = [
    TextIconItem("select_theme", "Select theme", Icons.image_rounded),
    TextIconItem("logout", "Logout", Icons.logout),
  ];

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                body: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          MdiIcons.chevronLeft,
                          color: themeData.colorScheme.onBackground,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: MySize.size16),
                      child: PopupMenuButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: themeData.colorScheme.onBackground,
                        ),
                        onSelected: (value) {
                          switch(value) {
                            case 'select_theme': {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => SelectThemeDialog());
                              break;
                            }
                            case 'logout': {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen()));
                              break;
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return _textIconChoice
                              .map((TextIconItem choice) {
                            return PopupMenuItem(
                              textStyle: TextStyle(color: themeData.colorScheme.onBackground),
                              value: choice.key,
                              child: Row(
                                children: <Widget>[
                                  Icon(choice.iconData,
                                      size: 18,
                                      color: themeData.popupMenuTheme
                                          .textStyle.color),
                                  Padding(
                                    padding: EdgeInsets.only(left: MySize.size8),
                                    child: Text(choice.text),
                                  )
                                ],
                              ),
                            );
                          }).toList();
                        },
                        color: themeData.backgroundColor,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: MySize.size24),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: MySize.size16),
                            width: MySize.getScaledSizeHeight(140),
                            height: MySize.getScaledSizeHeight(140),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image:  DecorationImage(
                                  image: AssetImage(
                                      "./assets/images/avatar-1.jpg"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Positioned(
                            bottom: MySize.size12,
                            right: MySize.size8,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: themeData.scaffoldBackgroundColor,
                                    width: 2,
                                    style: BorderStyle.solid),
                                color: themeData.colorScheme.primary,
                              ),
                              child: Padding(
                                padding:  EdgeInsets.all(MySize.size6),
                                child: Icon(
                                  MdiIcons.pencil,
                                  size: MySize.size20,
                                  color: themeData.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(_userDetails.fullName,
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.headline6,
                              fontWeight:600,
                              letterSpacing: 0)),
                      Text("UI Designer",
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: 500)),
                    ],
                  ),
                ),
                Container(
                  padding:
                       EdgeInsets.only(top: MySize.size36, left: MySize.size24, right: MySize.size24),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: MySize.size16),
                        child: TextFormField(
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText1,
                              letterSpacing: 0.1,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 500),
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            border:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: themeData.colorScheme.background,
                            prefixIcon: Icon(
                              MdiIcons.accountOutline,
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                          controller:
                              TextEditingController(text: _userDetails.fullName),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MySize.size16),
                        child: TextFormField(
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText1,
                              letterSpacing: 0.1,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 500),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            border:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: themeData.colorScheme.background,
                            prefixIcon: Icon(
                              MdiIcons.emailOutline,
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller:
                              TextEditingController(text: _userDetails.email),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MySize.size16),
                        child: TextFormField(
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText1,
                              letterSpacing: 0.1,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 500),
                          decoration: InputDecoration(
                            hintText: "Change Password",
                            hintStyle: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            border:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: themeData.colorScheme.background,
                            prefixIcon: Icon(
                              MdiIcons.lockOutline,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? MdiIcons.eyeOutline
                                    : MdiIcons.eyeOffOutline,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          obscureText: _passwordVisible,
                        ),
                      ),
                      Container(
                        margin:  EdgeInsets.only(top: MySize.size24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  themeData.colorScheme.primary.withAlpha(20),
                              blurRadius: 3,
                              offset:
                                  Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(Spacing.xy(16, 0))
                            ),
                            onPressed: () {},
                            child: Text("UPDATE",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.button,
                                    fontWeight: 600,
                                    color: themeData.colorScheme.onPrimary,letterSpacing: 0.3))),
                      ),
                    ],
                  ),
                ),
              ],
            )));
      },
    );
  }
}
