import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import '../paths.dart';
import '../poly/item.dart';
import 'package:params/client.dart';

DivElement content = querySelector("#content");

/*
 * void main()
 *
 * displays form to create a new object
*/
Future main() async {
  querySelector("#warning").remove();

  initParams();
  querySelector("#view_items").onClick.listen((e) => window.location.assign(itemsUrl));
  querySelector("#home").onClick.listen((e) => window.location.assign(homeUrl));
  //Item item = querySelector("custom-item");
  //Item polyItem = querySelector("create-item");

  var polyItem = document.createElement('custom-item');
  polyItem.apperance="create";
  //polyItem.set('apperance', "create");

  content.append(polyItem);
}

