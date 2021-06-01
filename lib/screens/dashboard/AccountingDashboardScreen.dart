import 'dart:async';

import 'package:family_accounting/AppTheme.dart';
import 'package:family_accounting/AppThemeNotifier.dart';
import 'package:family_accounting/models/AccountingModel.dart';
import 'package:family_accounting/models/CategoryModel.dart';
import 'package:family_accounting/models/DashboardModel.dart';
import 'package:family_accounting/models/IncomeExpenseModel.dart';
import 'package:family_accounting/providers/APIProvider.dart';
import 'package:family_accounting/screens/common/HeaderScreen.dart';
import 'package:family_accounting/utils/Generator.dart';
import 'package:family_accounting/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

StreamController<AccountingModel> accountingController = StreamController<AccountingModel>.broadcast();
StreamController<List<IncomeExpenseModel>> incomeExpenseController = StreamController<List<IncomeExpenseModel>>.broadcast();

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
  Stream accountingStream = accountingController.stream;
  Stream incomeExpenseStream = incomeExpenseController.stream;
  String selectedCategory = 'all';

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
                  child: FutureBuilder(
                    future: dashboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final DashboardModel dashboardModel = snapshot.data;
                        return ListView(
                          padding: Spacing.top(48),
                          children: [
                            HeaderScreen(title: 'Accounting'),
                            _CarouselCardAccounting(accountingList: dashboardModel.accounting, selectedCategory: this.selectedCategory),
                            Container(
                              padding: EdgeInsets.only(left: MySize.size24, right: MySize.size16, top: MySize.size24),
                              child: Text(
                                "LAST TRANSACTIONS",
                                style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, color: themeData.colorScheme.onBackground.withAlpha(220)),
                              ),
                            ),
                            Container(
                              margin: Spacing.top(8),
                              padding: Spacing.vertical(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: StreamBuilder<AccountingModel>(
                                    stream: accountingStream,
                                    initialData: dashboardModel.accounting.last,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        AccountingModel acc = snapshot.data;
                                        List<CategoryModel> categories = acc.getCategories();
                                        List<Widget> widgetCategoryList = [];
                                        if (categories.length > 1) {
                                          widgetCategoryList.add(Container(
                                            margin: Spacing.left(12),
                                            child: singleCategory(title: "All", iconData: MdiIcons.ballotOutline, index: 'all', accounting: acc),
                                          ));
                                        }
                                        categories.asMap().forEach((i, c) {
                                          if (i == categories.length - 1) {
                                            widgetCategoryList.add(Container(
                                              margin: Spacing.right(24),
                                              child: singleCategory(title: c.name, iconData: c.getIcon(), index: c.id, accounting: acc),
                                            ));
                                          } else {
                                            widgetCategoryList.add(singleCategory(title: c.name, iconData: c.getIcon(), index: c.id, accounting: acc));
                                          }
                                        });
                                        return Row(
                                          children: widgetCategoryList,
                                        );
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.only(left: MySize.size8, right: MySize.size8, top: MySize.size8),
                                          child: Center(
                                            child: Text('No transactions for this accounting'),
                                          ),
                                        );
                                      }
                                    }
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: MySize.size8, right: MySize.size8, top: MySize.size8),
                                child: StreamBuilder<List<IncomeExpenseModel>>(
                                    stream: incomeExpenseStream,
                                    initialData: dashboardModel.accounting.last.getIncomeExpenseByCategory(this.selectedCategory),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<IncomeExpenseModel> incomeExpenses = snapshot.data;
                                        if (incomeExpenses.length > 0) {
                                          final List<Widget> transactionList = [];
                                          incomeExpenses.toList().forEach((ie) {
                                            transactionList.add(_TransactionWidget(incomeExpense: ie));
                                            transactionList.add(Divider(
                                              height: 0,
                                            ));
                                          });
                                          return Column(
                                            children: transactionList,
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    }))
                          ],
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  themeData.colorScheme.primary,
                                )),
                          ),
                        );
                      }
                    },
                  ),
                )));
      },
    );
  }

  Widget singleCategory({IconData iconData, String title, String index, AccountingModel accounting}) {
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

class _CarouselCardAccounting extends StatefulWidget {
  final List<AccountingModel> accountingList;
  final String selectedCategory;

  _CarouselCardAccounting({Key key, @required this.accountingList, this.selectedCategory}) : super(key: key);

  @override
  _CarouselCardAccountingState createState() => _CarouselCardAccountingState();
}

class _CarouselCardAccountingState extends State<_CarouselCardAccounting> {
  ThemeData themeData;

  @override
  void didUpdateWidget(_CarouselCardAccounting oldWidget) {
    super.didUpdateWidget(oldWidget);
    AccountingModel accounting = widget.accountingList.last;
    accountingController.add(accounting);
    incomeExpenseController.add(accounting.getIncomeExpenseByCategory(widget.selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.28,
      child: PageView.builder(
        physics: ClampingScrollPhysics(),
        controller: PageController(initialPage: widget.accountingList.length - 1, viewportFraction: 0.9),
        itemCount: widget.accountingList.length,
        itemBuilder: (context, position) {
          return renderCard(widget.accountingList[position]);
        },
        onPageChanged: (page) {
          AccountingModel accounting = widget.accountingList[page];
          accountingController.add(accounting);
          incomeExpenseController.add(accounting.incomeExpenses);
        },
      ),
    );
  }

  Widget renderCard(AccountingModel acc) {
    final month = DateFormat("MMM").format(DateTime.parse(acc.startDate));
    return Container(
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
          Text(month, style: AppTheme.getTextStyle(themeData.textTheme.headline5, fontWeight: 700, color: Colors.black)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("INCOMES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: Colors.black)),
              Text(acc.getTotalIncomesAmount().toStringAsFixed(2),
                  style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: Colors.black)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("EXPENSES", style: AppTheme.getTextStyle(themeData.textTheme.overline, color: Colors.black)),
              Text(acc.getTotalExpensesAmount().toStringAsFixed(2),
                  style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 700, letterSpacing: 0.3, color: Colors.black)),
            ],
          ),
          Container(
            margin: Spacing.top(8),
            child: Row(
              children: <Widget>[
                Generator.buildProgress(
                    progress: acc.getBalance(),
                    activeColor: themeData.colorScheme.primary,
                    inactiveColor: themeData.colorScheme.onPrimary,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5),
                Container(
                  margin: Spacing.left(16),
                  child: Text(
                    acc.getBalance().toString() + '%',
                    style: AppTheme.getTextStyle(themeData.textTheme.caption, color: themeData.colorScheme.primary, muted: true, fontWeight: 600, letterSpacing: 0.5),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TransactionWidget extends StatefulWidget {
  final IncomeExpenseModel incomeExpense;

  _TransactionWidget({Key key, @required this.incomeExpense}) : super(key: key);

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
                    Text(widget.incomeExpense.alias, style: AppTheme.getTextStyle(themeData.textTheme.subtitle1, fontWeight: 600, letterSpacing: 0)),
                    Text(DateFormat("MMM d").format(DateTime.parse(widget.incomeExpense.date)), style: AppTheme.getTextStyle(themeData.textTheme.caption, fontWeight: 500)),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Text(widget.incomeExpense.type == 'income' ? "+ " : "- ", style: AppTheme.getTextStyle(themeData.textTheme.subtitle1)),
                Text("\$ " + widget.incomeExpense.amount.toString(), style: AppTheme.getTextStyle(themeData.textTheme.subtitle1, fontWeight: 600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
