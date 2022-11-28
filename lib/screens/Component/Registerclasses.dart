import 'package:minorproject/screens/About/About.dart';
import 'package:minorproject/screens/Profile/Profile.dart';
import 'package:minorproject/screens/Setting/Setting.dart';

import '../home/home.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<AboutScreen>(() => AboutScreen());
    register<HomeScreen>(() => HomeScreen());
    register<SettingScreen>(() => SettingScreen());
    register<ProfileScreen>(() => ProfileScreen());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}
