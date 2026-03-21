import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;
import '../paths.dart';
import '../poly/item.dart';
import 'package:params/client.dart';

DivElement content = querySelector("#content");

/*
 * void main()
 * 
 * requests object from db if id is provided 
 * in location search string.
 * then calls displayItem with response
*/
Future main() async {
    querySelector("#warning").remove();

    initParams();
    querySelector("#home").onClick.listen((e) => window.location.assign(homeUrl));

    querySelector("#create").onClick.listen((e) {
        if (params["inlineEdit"] == "true") {
            appendAsyncEmptyItem();
        } else {
            window.location.assign(itemCreateUrl);
        }
    });
    print(window.location.runtimeType);

    print("Request List");
    var url = "http://127.0.0.1:8090/$itemsLoadUrl";
    var request = HttpRequest.getString(url).then(displayList);
}

/*
 * void displayItem(responseText)
 * 
 * transforms the json response into a map,
 * passing it to the created poly object
*/
void displayList(responseText) {
    List items = JSON.decode(responseText);
    Item polyItemHeader = new Element.tag('custom-item');
    //polyItemHeader.set("apperance" , "header");
    polyItemHeader.set("apperance","header");
    if (params["inlineEdit"] == "true") {
        polyItemHeader.set("inlineEdit", true);
    }
    content.append(polyItemHeader);
    appendItems(items);
}

Element setAsyncEditOption(polyItem) {
    polyItem.set('inlineEdit', true);
    polyItem.onClick.listen((event) {
        if (polyItem.getAttribute("apperance") == "index") {
            polyItem.set('apperance', "edit");
            polyItem.set('title', "click to edit");

        }
    });
    return polyItem;
}

void appendAsyncEmptyItem() {
    var polyItem = document.createElement('custom-item');
    polyItem.set("apperance ", "create");
    polyItem = setAsyncEditOption(polyItem);
    content.append(polyItem);
}

void appendItems(List items) {
    items.forEach((item) {
        Item polyItem = document.createElement('custom-item');
        polyItem.set('object', item);
        polyItem.set('apperance', "index");

        if (params["inlineEdit"] == "true") {
            polyItem = setAsyncEditOption(polyItem);
        }
        content.append(polyItem);
    });
}