import 'package:flutter/material.dart';
import 'package:trainee_restaurantapp/core/datasources/shared_preference.dart';

class MyAppStateObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    //if the application latest state is detached then it's terminated
    //will be used in background handler for fcm
    (await SpUtil.instance).putString("state", "$state");
    // Handle state changes (resumed, inactive, paused, etc.)
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
    } else if (state == AppLifecycleState.inactive) {
      // App is in an inactive state
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
    }
  }
}
