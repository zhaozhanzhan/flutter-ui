import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';
//首页
import 'package:efox_flutter/page/home.dart';
import 'package:efox_flutter/widget/index.dart' as WidgetConfig;
import 'handles.dart';

class FluroRouter {
  static Router router;

  static Router initRouter() {
    FluroRouter.router = Router();
    router.define(
      '/',
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return HomePage();
        },
      ),
    );

    router.define('/webview', handler: webviewHandler);
    
    // 组件
    WidgetConfig.getAllWidgets().forEach((widgetListInfo) {
      widgetListInfo.widgetList.forEach((widgetInfo) {
        router.define(
          widgetInfo.routerName,
          handler: Handler(
              handlerFunc: (BuildContext context, Map<String, List> params) {
            return widgetInfo.widget;
          }),
        );
      });
    });
    return router;
  }
}