import 'package:flutter/material.dart';
import 'package:efox_flutter/lang/index.dart' show AppLocalizations;
import 'package:efox_flutter/store/index.dart' show Store;
import 'package:efox_flutter/controller/index.dart' as Controller;
import 'package:efox_flutter/config/theme.dart' show AppTheme;
import 'component/tabs.dart' as TabIndex;
import 'mine/index.dart' as MyIndex;
import 'app-login/index.dart' as LoginIndex;

import 'package:efox_flutter/utils/appVersion.dart' show AppVersion;

class Index extends StatefulWidget {
  @override
  _IndexState createState() => new _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  PageController _pageController;
  dynamic model;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Controller.initState();
    AppVersion().check(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _bottomNavigationBar(model) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            title: Text(AppLocalizations.$t('title_component')),
            icon: Icon(Icons.dashboard)),
        BottomNavigationBarItem(
            title: Text(AppLocalizations.$t('title_my')),
            icon: Icon(Icons.person_outline)),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (int index) {
        _pageController.jumpToPage(index);
      },
    );
  }

  renderDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Color(AppTheme.mainColor),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/imgs/avatar.png",
                      width: 80,
                    ),
                  ),
                ),
                Text(
                  this.model.user.state.name ?? 'Guest',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(AppLocalizations.$t('common.login')),
                  onTap: () {
                    this.model.dispatch('user', 'setUser', {'name': 'Guest'});
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return LoginIndex.Index(model: this.model,);
                    }));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Store.connect(
      builder: (context, child, model) {
        this.model = model;
        return Scaffold(
          drawer: renderDrawer(),
          bottomNavigationBar: _bottomNavigationBar(model),
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: <Widget>[
              TabIndex.Index(model: model),
              MyIndex.Index(model: model),
            ],
          ),
        );
      },
    );
  }
}
