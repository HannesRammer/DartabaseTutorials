@HtmlImport('item.html')
library dartabase.poly.item;

import "dart:convert" show JSON;
import "dart:html";
import "dart:async";

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

import '../paths.dart';

@PolymerRegister('custom-item')
class Item extends PolymerElement {
    @Property(notify: true)
    Map object = {};
    @Property(notify: true)
    bool pagination = false;
    @Property(notify: true)
    bool inlineEdit = false;
    @Property(notify: true)
    String apperance = "view";

    Item.created() : super.created();


    @reflectable
    void view() {
        if (object != null && object['id'] != null) {
            window.location.assign("$itemViewUrl?id=${object['id']}");
        }
    }

    @reflectable
    void edit() {
        if (object != null && object['id'] != null) {
            window.location.assign("$itemEditUrl?id=${object['id']}");
        }
    }

    @reflectable
    void next() {
        if (object != null && object['id'] != null) {
            window.location.assign("$itemViewUrl?id=${object['id'] + 1}");
        }
    }

    @reflectable
    void prev() {
        if (object != null && object['id'] != null) {
            window.location.assign("$itemViewUrl?id=${object['id'] - 1}");
        }
    }

    @reflectable
    void save() {
        print("Saving structured data");
        // Setup the request
        var request = new HttpRequest();
        request.onReadyStateChange.listen((_) {
            if (request.readyState == HttpRequest.DONE &&
                    (request.status == 200 || request.status == 0)) {
                // data saved OK.
                print(" Data saved successfully");
                // update the UI
                var jsonString = request.responseText;
                //querySelector("#content").appendText(jsonString);
                if (inlineEdit) {
                    this.object = JSON.decode(jsonString);
                    this.apperance = "index";
                } else {
                    window.location.assign(itemsUrl);
                }
            }
        });
        request.open("POST", "http://127.0.0.1:8090/$itemSaveUrl");
        request.send(JSON.encode(object));
    }

    @reflectable
    void delete() {
        if (object != null && object['id'] != null) {
            print("Delete object with id ${object['id']}");
            // Setup the request
            var request = new HttpRequest();
            request.onReadyStateChange.listen((_) {
                if (request.readyState == HttpRequest.DONE &&
                        (request.status == 200 || request.status == 0)) {
                    // item deleted OK.
                    print("Item deleted successfully");
                    // update the UI
                    var jsonString = request.responseText;
                    querySelector("#content").appendText("done $jsonString");
                    if (this.inlineEdit) {
                        this.remove();
                    } else {
                        window.location.assign(itemsUrl);
                    }
                }
            });
            request.open("POST", "http://127.0.0.1:8090/$itemDeleteUrl");
            request.send(JSON.encode(object));
        }
    }

    @reflectable
    isHeader(style) {
        bool val = false;
        if (style == "header") {
            val = true;
        }
        return val;
    }

    @reflectable
    isInlineEdit(style) {
        bool val = false;
        if (style == true) {
            val = true;
        }
        return val;
    }

    @reflectable
    isIndex(style) {
        bool val = false;
        if (style == "index") {
            val = true;
        }
        return val;
    }

    @reflectable
    isView(style) {
        bool val = false;
        if (style == "view") {
            val = true;
        }
        return val;
    }

    @reflectable
    isPagination(style) {
        bool val = false;
        if (style == true) {
            val = true;
        }
        return val;
    }

    @reflectable
    isEdit(style) {
        bool val = false;
        if (style == "edit") {
            val = true;
        }
        return val;
    }

    @reflectable
    isCreate(style) {
        bool val = false;
        if (style == "edit") {
            val = true;
        }
        return val;
    }
}