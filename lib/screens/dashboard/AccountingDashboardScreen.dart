
import 'package:family_accounting/AppThemeNotifier.dart';
import 'package:family_accounting/models/DashboardModel.dart';
import 'package:family_accounting/providers/APIProvider.dart';
import 'package:family_accounting/screens/profile/ProfileScreen.dart';
import 'package:family_accounting/utils/Generator.dart';
import 'package:family_accounting/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';

class AccountingDashboardScreen extends StatefulWidget {
  @override
  _AccountingDashboardScreenState createState() => _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends State<AccountingDashboardScreen> {
  final APIProvider _apiProvider = APIProvider();
  Future<DashboardModel> dashboardFuture;
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  String today = DateFormat("E d MMM, yyyy").format(DateTime.now());
  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    dashboardFuture = loadDashboard();
  }

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                body: Container(
              color: customAppTheme.bgLayer1,
              child: ListView(
                padding: Spacing.top(48),
                children: [
                  Container(
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
                                  "Accounting",
                                  style: AppTheme.getTextStyle(themeData.textTheme.headline5,
                                      fontSize: 24, fontWeight: 700, letterSpacing: -0.3, color: themeData.colorScheme.onBackground),
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
                  ),
                  _CardWidget(),
                  Container(
                    padding: EdgeInsets.only(left: MySize.size16, right: MySize.size16, top: MySize.size24),
                    child: Text(
                      "LAST TRANSACTION",
                      style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, color: themeData.colorScheme.onBackground.withAlpha(220)),
                    ),
                  ),
                  Container(
                    margin: Spacing.top(8),
                    padding: Spacing.vertical(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: Spacing.left(12),
                            child: singleCategory(title: "All", iconData: MdiIcons.ballotOutline, index: 0),
                          ),
                          singleCategory(title: "Birthday", iconData: MdiIcons.cakeVariant, index: 1),
                          singleCategory(title: "Party", iconData: MdiIcons.partyPopper, index: 2),
                          singleCategory(title: "Talks", iconData: MdiIcons.chatOutline, index: 3),
                          Container(
                            margin: Spacing.right(24),
                            child: singleCategory(title: "Food", iconData: MdiIcons.food, index: 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: MySize.size8, right: MySize.size8, top: MySize.size8),
                      child: Column(
                        children: <Widget>[
                          _TransactionWidget(name: "Liana Fitzgeraldl", date: "29 may 2020", amount: 177, isSend: false),
                          Divider(
                            height: 0,
                          ),
                          _TransactionWidget(name: "Natalia Dyer", date: "14 dec 2019", amount: 99, isSend: true),
                          Divider(
                            height: 0,
                          ),
                          _TransactionWidget(name: "Talia", date: "6 June 2019", amount: 100, isSend: true),
                          Divider(
                            height: 0,
                          ),
                          _TransactionWidget(name: "Shauna Mark", date: "29 dec 2019", amount: 160, isSend: true),
                          Divider(
                            height: 0,
                          ),
                          _TransactionWidget(name: "Natalia Dyer", date: "2 dec 2019", amount: 19, isSend: true),
                          Divider(
                            height: 0,
                          ),
                          _TransactionWidget(name: "Paul Rip", date: "4 dec 2019", amount: 62, isSend: true),
                          Container(
                            padding: EdgeInsets.only(top: MySize.size12, bottom: MySize.size16),
                            child: SizedBox(
                                width: MySize.size20,
                                height: MySize.size20,
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeData.colorScheme.primary), strokeWidth: 1.5)),
                          )
                        ],
                      ))
                ],
              ),
            )));
      },
    );
  }

  Widget singleCategory({IconData iconData, String title, int index}) {
    bool isSelected = (selectedCategory == index);
    return InkWell(
        onTap: () {
          if (!isSelected) {
            setState(() {
              selectedCategory = index;
            });
          }
        },
        child: Container(
          margin: Spacing.fromLTRB(12, 8, 0, 8),
          decoration: BoxDecoration(
              color: isSelected ? themeData.colorScheme.primary : customAppTheme.bgLayer1,
              border: Border.all(color: customAppTheme.bgLayer3, width: isSelected ? 0 : 0.8),
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
              boxShadow:
                  isSelected ? [BoxShadow(color: themeData.colorScheme.primary.withAlpha(80), blurRadius: MySize.size6, spreadRadius: 1, offset: Offset(0, MySize.size2))] : []),
          padding: Spacing.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: MySize.size22,
                color: isSelected ? themeData.colorScheme.onPrimary : themeData.colorScheme.onBackground,
              ),
              Container(
                margin: Spacing.left(8),
                child: Text(
                  title,
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText2, color: isSelected ? themeData.colorScheme.onPrimary : themeData.colorScheme.onBackground),
                ),
              )
            ],
          ),
        ));
  }

  Future<DashboardModel> loadDashboard() async {
    final response = await _apiProvider.sendRequest({}, {'method': 'GET', 'endPoint': '/dashboard?id=60a27a0f8b1e1d70ffbfef2e'});
    return DashboardModel.fromJson(response);
  }
}

class _CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      child: PageView(
        physics: ClampingScrollPhysics(),
        controller: PageController(initialPage: 1, viewportFraction: 0.9),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: MySize.size8, bottom: MySize.size24, right: MySize.size8),
            decoration: BoxDecoration(
              border: Border.all(width: 0.7, color: themeData.colorScheme.surface),
              color: Color(0xff8d95ac),
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
              boxShadow: [
                BoxShadow(
                  color: themeData.cardTheme.shadowColor.withAlpha(28),
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.only(left: MySize.size24, right: MySize.size24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Apr", style: AppTheme.getTextStyle(themeData.textTheme.headline5, fontWeight: 700, color: Colors.black)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("INCOMES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: Colors.black)),
                    Text("\$ 12,000", style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("EXPENSES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: Colors.black)),
                    Text("\$ 7,000", style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: Colors.black)),
                  ],
                ),
                Container(
                  margin: Spacing.top(8),
                  child: Row(
                    children: <Widget>[
                      Generator.buildProgress(
                          progress: 68.0,
                          activeColor: themeData.colorScheme.primary,
                          inactiveColor: themeData.colorScheme.onPrimary,
                          width: MediaQuery.of(context).size.width * 0.5),
                      Container(
                        margin: Spacing.left(16),
                        child: Text(
                          "68%",
                          style: AppTheme.getTextStyle(themeData.textTheme.caption, color: themeData.colorScheme.primary, muted: true, fontWeight: 600, letterSpacing: 0.5),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MySize.size8, bottom: MySize.size24, right: MySize.size8),
            decoration: BoxDecoration(
              border: Border.all(width: 0.7, color: themeData.colorScheme.surface),
              color: themeData.colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
              boxShadow: [
                BoxShadow(
                  color: themeData.cardTheme.shadowColor.withAlpha(28),
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.only(left: MySize.size24, right: MySize.size24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("May", style: AppTheme.getTextStyle(themeData.textTheme.headline5, fontWeight: 700, color: themeData.colorScheme.onBackground)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("INCOMES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: themeData.colorScheme.onBackground)),
                    Text("\$ 12,000", style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: themeData.colorScheme.onBackground)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("EXPENSES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: themeData.colorScheme.onBackground)),
                    Text("\$ 7,000", style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: themeData.colorScheme.onBackground)),
                  ],
                ),
                Container(
                  margin: Spacing.top(8),
                  child: Row(
                    children: <Widget>[
                      Generator.buildProgress(
                          progress: 68.0,
                          activeColor: themeData.colorScheme.primary,
                          inactiveColor: themeData.colorScheme.onPrimary,
                          width: MediaQuery.of(context).size.width * 0.5),
                      Container(
                        margin: Spacing.left(16),
                        child: Text(
                          "68%",
                          style: AppTheme.getTextStyle(themeData.textTheme.caption, color: themeData.colorScheme.primary, muted: true, fontWeight: 600, letterSpacing: 0.5),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MySize.size8, bottom: MySize.size24, left: MySize.size8),
            decoration: BoxDecoration(
              border: Border.all(width: 0.7, color: themeData.colorScheme.surface),
              color: themeData.colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
              boxShadow: [
                BoxShadow(
                  color: themeData.cardTheme.shadowColor.withAlpha(28),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.plus,
                      color: themeData.colorScheme.onPrimary,
                    ),
                    SizedBox(
                      width: MySize.size8,
                    ),
                    Text("Add card".toUpperCase(),
                        style: AppTheme.getTextStyle(themeData.textTheme.subtitle1, letterSpacing: 0.8, fontWeight: 700, color: themeData.colorScheme.onPrimary)),
                  ],
                ),
              ],
            ),
          ),
        ],
        onPageChanged: (page) {
          print(page);
        },
      ),
    );
  }
}

class _TransactionWidget extends StatefulWidget {
  final bool isSend;
  final String name, date;
  final int amount;

  _TransactionWidget({Key key, this.isSend = false, @required this.name, @required this.date, @required this.amount}) : super(key: key);

  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<_TransactionWidget> {
  ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: MySize.size4, bottom: MySize.size4),
      child: Container(
        padding: EdgeInsets.only(left: MySize.size16, right: MySize.size16, top: MySize.size8, bottom: MySize.size8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: MySize.size8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.name, style: AppTheme.getTextStyle(themeData.textTheme.subtitle1, fontWeight: 600, letterSpacing: 0)),
                    Text(widget.date, style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 500)),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Text(widget.isSend ? "- " : "+ ", style: AppTheme.getTextStyle(themeData.textTheme.subtitle1)),
                Text("\$ " + widget.amount.toString(), style: AppTheme.getTextStyle(themeData.textTheme.subtitle1, fontWeight: 600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
