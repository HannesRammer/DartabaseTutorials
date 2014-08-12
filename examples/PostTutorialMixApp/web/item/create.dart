import 'package:polymer/polymer.dart';
import 'dart:html';
import '../paths.dart';
import 'package:params/client.dart';

DivElement content = querySelector("#content");
  
/*
 * void main()
 * 
 * displays form to create a new object
*/
void main() {
  querySelector("#warning").remove();
  initPolymer().run(() {
    initParams();
    querySelector("#view_items").onClick.listen((e) => window.location.assign(itemsUrl));
    querySelector("#home").onClick.listen((e) => window.location.assign(homeUrl));
    Element polyItem = new Element.tag('custom-item');
    polyItem.apperance = "create";
    content.append(polyItem);
  });
}

