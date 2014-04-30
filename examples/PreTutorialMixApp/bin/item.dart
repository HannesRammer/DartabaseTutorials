part of example.server ;
class Item {
  num id;
  String text;
  bool done;
  DateTime created_at;
  DateTime updated_at;
  
  String toString() => "Item id=$id:text=$text:done=$done:created_at:$created_at:updated_at:$updated_at";

  //return all items
  static loadItems(HttpResponse res){
    print("implement loadItems");
    res.write(JSON.encode([{'text':'implement loadItems'}]));
    res.close();
  }
  
  //return item by id
  static loadItem(HttpResponse res,id){
    print("implement loadItem");
    res.write(JSON.encode({'text':'implement loadItem'}));
    res.close();
  }
  
  //save item
  static saveItem(HttpRequest req,HttpResponse res)
  {
    req.listen((List<int> buffer) {
      Map postDataMap = JSON.decode(new String.fromCharCodes(buffer));
      print("implement saveItem");
      res.write(JSON.encode({'text':'implement saveItem'}));
      res.close();
    }, onError: printError);
  }
  
  //delete item
  static deleteItem(HttpRequest req,HttpResponse res)
  {
    req.listen((List<int> buffer) {
      print("implement deleteItem");
      res.write(JSON.encode({'text':'implement deleteItem'}));
      res.close();
    }, onError: printError);
  }
}