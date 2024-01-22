import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalyticsHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> testEvent(_value) async {
    await analytics
        .logEvent(name: '${_value}_click', parameters: {'Value': _value});
    print('Send Event');
  }

  Future<void> testsetUserId(_value) async {
    await analytics.setUserId(id: '$_value');
    print('setUserId');
  }

  Future<void> testSetUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
    print('setUserProperty');
  }
}
