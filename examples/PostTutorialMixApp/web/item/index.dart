import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert' show JSON;
import '../paths.dart';
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
    querySelector("#home").onClick.listen((e) => window.location.assign(homeUrl));
    
    querySelector("#create").onClick.listen((e){ 
      if(params["inlineEdit"]=="true"){
        appendAsyncEmptyItem();
      }else{
        window.location.assign(itemCreateUrl);
      }
    });
    print(window.location.runtimeType);
      
    print("Request List");
    var url = "http://127.0.0.1:8090/$itemsLoadUrl";
    var request = HttpRequest.getString(url).then(displayList);
  });
}

/*
 * void displayItem(responseText)
 * 
 * transforms the json response into a map,
 * passing it to the created poly object
*/
void displayList(responseText) {
  List items = JSON.decode(responseText);
  Element polyItemHeader = new Element.tag('custom-item');
  polyItemHeader.apperance = "header";
  if(params["inlineEdit"] == "true"){
    polyItemHeader.inlineEdit = true;
  }
  content.append(polyItemHeader);
  appendItems(items);
}

Element setAsyncEditOption(polyItem){
  polyItem.inlineEdit = true;
  polyItem.onClick.listen((event){ 
    if(polyItem.apperance == "index"){
      polyItem.apperance = "edit";
      polyItem.title="click to edit!";  
    }
  });
  return polyItem;
}

void appendAsyncEmptyItem(){
  Element polyItem = new Element.tag('custom-item');
  polyItem.apperance = "create";
  polyItem = setAsyncEditOption(polyItem);
  content.append(polyItem);
}

void appendItems(List items){
  items.forEach((item){
      Element polyItem = new Element.tag('custom-item');
      polyItem.object = item;
      polyItem.apperance = "index";
      if(params["inlineEdit"] == "true"){
        polyItem = setAsyncEditOption(polyItem);
      }
      content.append(polyItem);
    });
}