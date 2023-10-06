import 'dart:io';
// import 'package:dicobot/models/messages.dart';
import 'package:sembast/sembast.dart';
import 'package:dicobot/models/users.dart';
import 'dart:convert';
import 'dart:io';

String? toJSON(Map<String?,String?> msg){
  String? JSONString = jsonEncode(msg);
  return JSONString;

}

String? toMaptoJSON(String? username,String? msg,DateTime now){
  return toJSON({
      "sender":"${username}", 
      "message": "$msg",
      "Date and Time":"${now}"});
}

Map<String?,dynamic> toMap(json){
  Map<String?,dynamic> map= jsonDecode(json);
  return map;

}


void displayMsg(Map <String?,dynamic> map){
  stdout.write("Date and Time:");
  print(map['Date and Time']);
  stdout.write("Sender:       ");
  print(map['sender']);
  stdout.write("message :     ");
  print(map['message']);

}




class message {
  readDM(
      Database db1,
      StoreRef<String?, String?> user_store1,
      Database db2,
      StoreRef<String?, String?> personalStore,
      var dmQuery,
      User currUser) async {
    if (currUser.username == "0") {
      print("login first!!");
      return;
    }
// print("received messages!!");
//  var finder =Finder(filter: Filter.byKey(currUser.username));
//  var dms = await personalStore.find(db2,finder: finder);
// print(dmQuery);
    for (var dm in dmQuery) {
      if (await dm.key == currUser.username) {
        Map<String?, dynamic> map = toMap(dm.value);
        displayMsg(map);
      }
    }
  }

  sendDM(
      Database db1,
      StoreRef<String?, String?> user_store1,
      Database db2,
      StoreRef<String?, String?> personalStore,
      var dmQuery,
      User currUser) async {
    if (currUser.username == "0") {
      print("login first!!");
      return;
    }

    print("Enter receiver name");
    String? name = stdin.readLineSync();
    if (await FindUser(name, db1, user_store1)) {
      print("enter valid username of receiver");
      return;
    } else {
      print("Enter message");
      String? message = stdin.readLineSync();
      DateTime now = DateTime.now();

      String? msg = toMaptoJSON(currUser.username, message, now);

      await personalStore.record(name).put(db2, msg);
    }
  }
}
