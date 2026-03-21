import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

Future main() async{
  await initPolymer();
  await initPolymer();
  querySelector("#view_list").onClick.listen((e) => window.location.assign("item/index.html"));
  querySelector("#view_inline_list").onClick.listen((e) => window.location.assign("item/index.html?inlineEdit=true"));
}


