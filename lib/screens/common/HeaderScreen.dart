import 'package:family_accounting/AppTheme.dart';
import 'package:family_accounting/AppThemeNotifier.dart';
import 'package:family_accounting/screens/profile/ProfileScreen.dart';
import 'package:family_accounting/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class HeaderScreen extends StatefulWidget {
  final String title;

  HeaderScreen({Key key, @required this.title}) : super(key: key);

  @override
  HeaderScreenState createState() => HeaderScreenState();
}

class HeaderScreenState extends State<HeaderScreen> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  String today = DateFormat("E d MMM, yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(builder: (BuildContext context, AppThemeNotifier value, Widget child) {
      customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
      return Container(
        margin: Spacing.fromLTRB(24, 0, 24, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    today,
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText2, fontWeight: 400, letterSpacing: 0, color: themeData.colorScheme.onBackground),
                  ),
                  Container(
                    child: Text(
                      widget.title,
                      style: AppTheme.getTextStyle(themeData.textTheme.headline5, fontSize: 24, fontWeight: 700, letterSpacing: -0.3, color: themeData.colorScheme.onBackground),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  padding: Spacing.all(10),
                  decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
                      boxShadow: [BoxShadow(color: customAppTheme.shadowColor, blurRadius: MySize.size4)]),
                  child: Icon(
                    MdiIcons.bell,
                    size: MySize.size18,
                    color: themeData.colorScheme.onBackground.withAlpha(160),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: MySize.size6,
                    height: MySize.size6,
                    decoration: BoxDecoration(color: customAppTheme.colorError, shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Container(
                margin: Spacing.left(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
                  child: Image(
                    image: AssetImage('./assets/images/avatar-1.jpg'),
                    width: MySize.size36,
                    height: MySize.size36,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
