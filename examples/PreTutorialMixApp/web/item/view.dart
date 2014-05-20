import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert' show JSON;
import '../../lib/paths.dart';
import 'package:params/client.dart';

DivElement content = querySelector("#content");

/*
 * void main()
 * 
 * requests object from db if id is provided 
 * in location search string.
 * then calls displayItem with response
*/
void main() {
  querySelector("#warning").remove();
  initPolymer().run(() {
    initParams();
    querySelector("#view_items").onClick.listen((e) => window.location.assign(itemsUrl));
    querySelector("#home").onClick.listen((e) => window.location.assign(homeUrl));
    if(params['id'] != null){
      String id = params['id'];
      print("requesting item with $id");
      var url = "http://127.0.0.1:8090/$itemLoadUrl/$id";
      var request = HttpRequest.getString(url).then(displayItem);
    }
    else{
      content.text="no item id available";
    }
  });
}

/*
 * void displayItem(responseText)
*/
void displayItem(String responseText) {
  Map item = JSON.decode(responseText);
  Element polyItem = new Element.tag('custom-item');
  polyItem.object = toObservable(item);
  polyItem.apperance = "view";
  polyItem.pagination = true;
  content.append(polyItem);
}