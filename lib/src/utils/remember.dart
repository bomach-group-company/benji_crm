import 'package:benji_aggregator/main.dart';

const String userBalance = 'userBalance';

bool rememberBalance() {
  bool remember = prefs.getBool(userBalance) ?? true;
  return remember;
}

void setRememberBalance(bool show) {
  prefs.setBool(userBalance, show);
}
