// import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:dicobot/models/users.dart';

// enum Role { amateur, mod, creator }

class server {
  String? serverName;
  String? Creator;
  // late Role role;

}

Future<bool> serverAlreadyExist(
    String? name, Database db3, StoreRef<dynamic, dynamic> serverStore) async {
  var server_record = await serverStore.find(db3);
  for (var rec in server_record) {
    if (rec.key == name) {
      print("Server already exists. Please choose a different servername.");
      return true;
    }
  }
  return false;
}

Future<bool> noServerExist(
    String? name, Database db3, StoreRef<dynamic, dynamic> serverStore) async {
  bool flag = false;
  var serverrec = await serverStore.find(db3);
  for (var rec in serverrec) {
    if (rec.key == name) {
      flag = true;
    }
  }
  if (!flag) {
    print("No such servername exists");
    return true;
  }
  return false;
}

Future<bool> userInServer(String? name, Database db3,
    StoreRef<dynamic, dynamic> serverStore, User currUser) async {
  var records = await serverStore.find(db3);
  bool user_in_server = false;
  for (var rec in records) {
    if (rec.key == name) {
      for (var user in rec.value['mem_list']) {
        if (user['name'] == currUser.username) {
          user_in_server = true;
        }
      }
    }
  }
  if (!user_in_server) {
    print("User is not in this server");
    return false;
  }
  return true;
}

Future<bool> cat_exist_in_server(String? cat_name, String? servername,
    Database db3, StoreRef<dynamic, dynamic> serverStore) async {
  bool cat = false;

  Map rec = await serverStore.record(servername).get(db3) as Map;
  for (var r in rec['cat_list']) {
    if (r['name'] == cat_name) {
      cat = true;
      break;
    }
  }
  if (!cat) {
    return false;
  }
  return true;
}

Future<bool> userInChannel(Database db4,String? channelName, StoreRef<String?,Map> channelStore, User currUser)async{
  Map? map = await channelStore.record(channelName).get(db4) as Map?;
  for(var user in map!['mem_list']){
    if(user==currUser.username){
    return true;
    
    }
  }
  return false;
}

Future<bool> checkIfnewbie(Database db3,StoreRef<dynamic,dynamic> serverStore,User currUser,String? serverName) async{
  Map? map = await serverStore.record(serverName).get(db3) as Map?;
  for(var user in map!['mem_list'] ){
    if(user['name']==currUser.username && user['role']=="newbie"){
      return true;
    }
  }
  return false;
}