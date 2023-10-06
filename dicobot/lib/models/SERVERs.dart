import 'dart:io';

import 'package:dicobot/models/comm_func.dart';
import 'package:dicobot/models/users.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

class Servers {
  String? serverName;
  String? Creator;
  List? mem_list;
  List? cat_list;

  Future<void> createServer(
      Database db1,
      StoreRef<String?, String?> user_store1,
      Database db3,
      StoreRef<dynamic, dynamic> serverStore,
      var serverQuery,
      User currUser) async {
    if (currUser.username == "0") {
      print("login first!!");
      return;
    }
    server serverObj = server();
    print("Enter server name:");
    serverObj.serverName = stdin.readLineSync();

    if (await serverAlreadyExist(serverObj.serverName, db3, serverStore)) {
      return;
    }
    serverObj.Creator = currUser.username;

    Map serverProp = {
      'chan_list': [],
      'cat_list': [],
      'mem_list': [],
    };
    Map entry = {
      'name': currUser.username,
      'role': "Creator",
    };
    serverProp['mem_list'].add(entry);
    await serverStore.record(serverObj.serverName).put(db3, serverProp);
  }

  Future<void> joinServer(
      Database db1,
      StoreRef<String?, String?> user_store1,
      Database db3,
      StoreRef<dynamic, dynamic> serverStore,
      var serverQuery,
      User currUser) async {
    if (currUser.username == "0") {
      print("login first!!");
      return;
    }
    server serverObj = server();
    print("Enter server name:");
    serverObj.serverName = stdin.readLineSync();

    if (await noServerExist(serverObj.serverName, db3, serverStore)) {
      return;
    }
    //function to see if user already in server

    if (await userInServer(serverObj.serverName, db3, serverStore, currUser)) {
      print("user already in server!!");
      return;
    }

    print("Enter ur role [amateur/mod]");
    String? userRole = stdin.readLineSync();
    var user_role;
    switch (userRole) {
      case "mod":
        user_role = userRole;
        break;

      case "amateur":
        user_role = userRole;
        break;

      default:
        print("Enter valid Role!!");
        return;
    }

    Map userInfo = {
      'name': currUser.username,
      'role': user_role,
    };

    Map<dynamic, dynamic> oldInfo =
        await serverStore.record(serverObj.serverName).get(db3);
    oldInfo = cloneMap(oldInfo);
    oldInfo['mem_list'].add(userInfo);

    await serverStore.record(serverObj.serverName).delete(db3);
    await serverStore.record(serverObj.serverName!).put(db3, oldInfo);

    print(
        "User ${currUser.username} successfully registered in ${serverObj.serverName} as ${user_role}");
  }

  addCategory(
      Database db1,
      StoreRef<String?, String?> user_store1,
      Database db3,
      StoreRef<dynamic, dynamic> serverStore,
      var serverQuery,
      User currUser) async {
    if (currUser.username == "0") {
      print("login first!!");
      return;
    }
    // server serverObj = server();
    stdout.write('Enter server name : ');
    final String? serverName = stdin.readLineSync();

    if (await noServerExist(serverName, db3, serverStore)) {
      return;
    }

    // var serverrec = await serverStore.find(db3);
    for (var query in serverQuery) {
      if (await query.key == serverName) {
        /////////////////////////////////////////////////////////
        // print(serverQuery);
        /////////////////////////////////////////////////////////
        for (var mem in query.value['mem_list']) {
          if (mem['name'] == currUser.username &&
              (mem['role'] == "mod" || mem['role'] == "Creator")) {
            stdout.write('Enter category name: ');
            String? catName = stdin.readLineSync();
            Map<String, dynamic> cat = {'name': catName, 'chan_list': []};
            Map<String, dynamic> oldInfo = await serverStore
                .record(serverName)
                .get(db3) as Map<String, dynamic>;
            oldInfo['cat_list'].add(cat);
            Map<String, dynamic> newInfo = oldInfo;
            await serverStore.record(serverName).delete(db3);
            await serverStore.record(serverName).put(db3, newInfo);
            print("category added successfully");
            return;
          } else {
            print(
                "Permission denied!!You need to be an mod or Creator in the server");
          }
        }
      }
    }
  }
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