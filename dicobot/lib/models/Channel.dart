import 'dart:io';
// import 'package:dicobot/SERVER.dart';
import 'package:dicobot/models/comm_func.dart';
import 'package:dicobot/models/users.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

enum ChannelType { text, voice, announcements }
class Channel{
  String? serverName;
  String category="0";
  List? mem_list;
  List? msg_list;


  addChannel(
    Database db1,
    StoreRef<String?, String?> user_store1,
    Database db3,
    StoreRef<dynamic, dynamic> serverStore,
    var serverQuery,
    User currUser,
    Database db4,
    StoreRef<String?, Map> channelStore) async {
  if (currUser.username == "0") {
    print("login first!!");
    return;
  }
  print("Server in which you want to add Channel:");
  String? serverName = stdin.readLineSync();
  if (await noServerExist(serverName, db3, serverStore)) {
    return;
  }
  if (!(await userInServer(serverName, db3, serverStore, currUser))) {
    print("First join the server!!");
    return;
  }
  print(
      "You want to add the channel directly or under some Category[direct/category]");
  String? place = stdin.readLineSync();
   var cat_name;
  switch (place) {
    case "category":
      print('Category in which u want to add channel: ');
      String? cat_name = stdin.readLineSync();
      break;
    case "direct":
      break;
    default:
      print("Invalid Input!!");
      return;
  }
  if (place == "category") {
    if (!(await cat_exist_in_server(cat_name, serverName, db3, serverStore))) {
      print("Category doesnt exist!!");
      return;
    }
  }
  print("Enter Channel name: ");
  String? channelName = stdin.readLineSync();

  var c_record = await channelStore.find(db4);
  for (var rec in c_record) {
    //checking if this is the channel of the correct type and in the correct server  (shannel name making unique in a server)
    if (rec.key == channelName && rec.value['server name'] == serverName) {
      //hence checking if the current user is already in the channel
      for (var user in rec.value['mem_list']) {
        if (user == currUser.username) {
          print("User is already in the channel");
          return;
        }
      }

      // Map po = await channel_store.record(c_name).get(db3) as Map;
      //     po = cloneMap(po); //Create a copy of the map
      //     po['mem_list'].add(c_user1.username);
      //     await channel_store.record(c_name).delete(db3);
      //     await channel_store.record(c_name).put(db3, po);
      //     print("\x1B[32mChannel added successfully\x1B[0m");
      //     return;
    }
  }
  print("Channel Type:[text/voice/announcement]: ");
  String? channelType = stdin.readLineSync();
  switch (channelType) {
    case 'text':
      break;
    case 'voice':
      break;

    case 'announcement':
      break;

    default:
      print("Invalid input");
      return;
  }
  var userRole;
  Map s_record = await serverStore.record(serverName).get(db3);
  for (var a in s_record['mem_list']) {
    if (a['name'] == currUser.username) {
      userRole = a['role'];
    }
  }

  if (userRole == "amateur") {
    print("Only Creator and mod users can create new channels");
    return;
  }
  Map<String, dynamic> Info = {
    'server name': serverName,
    'category name': cat_name,
    'mem_list': [currUser.username],
    'type': channelType,
  };
  await channelStore.record(channelName).put(db4, Info);

  if (place == "direct") {
    Map map = await serverStore.record(serverName).get(db3);
    map = cloneMap(map);
    map['chan_list'].add(channelName);
    await serverStore.record(serverName).delete(db3);
    await serverStore.record(serverName).put(db3, map);
    print('User added to the channel successfully');
  }
  if (place == "category") {
    Map aa = await serverStore.record(serverName).get(db3);

    aa = cloneMap(aa);
    for (var a in aa['cat_list']) {
      if (a['name'] == cat_name) {
        a['chan_list'].add(channelName);
        break;
      }
    }
    await serverStore.record(serverName).delete(db3);
    await serverStore.record(serverName).put(db3, aa);
  }
}


readChannelMsg(
    Database db1,
    Database db3,
    Database db4,
    Database db5,
    StoreRef<String?, String?> user_store1,
    StoreRef<dynamic, dynamic> serverStore,
    StoreRef<String?, Map> channelStore,
    StoreRef<Map, Map> channelDMStore,
    User currUser) async {
  if (currUser.username == "0") {
    print("login first!!");
    return;
  }
  print("name the server whose messages you want to read:");
  String? serverName = stdin.readLineSync();
  Map? info = await serverStore.record(serverName).get(db3);
  if (info == null) {
    print("Server does not exist");
    return;
  }
  if (userInServer(serverName, db3, serverStore, currUser) == false) {
    print("User is not in the Server");
    return;
  }
  print("Enter channel Name:");
  String? channelName = stdin.readLineSync();

  Map? po = await channelStore.record(channelName).get(db4);
  if (po == null) {
    print("Channel does not exist");
    return;
  }

  Map? key ={
    "channel_name":channelName,
    "server_name":serverName};
    Map? map = await channelDMStore.record(key).get(db5);

  var record = await channelDMStore.find(db5);
    for(var rec in record){
      // print("1");
      // if(rec.key==key){
        print("User: ${rec.value['user']}");
        print("Message :${rec.value['message']}");
        print("\n");

      // }
    }
}

sendChannelMsg(
    Database db1,
    Database db3,
    Database db4,
    Database db5,
    StoreRef<String?, String?> user_store1,
    StoreRef<dynamic, dynamic> serverStore,
    StoreRef<String?, Map> channelStore,
    StoreRef<Map, Map> channelDMStore,
    User currUser) async {
  if (currUser.username == "0") {
    print("login first!!");
    return;
  }
  print("server in which  you want to message: ");
  String? serverName = stdin.readLineSync();
  Map? info = await serverStore.record(serverName).get(db3);
  if (info == null) {
    print("Server does not exist");
    return;
  }

  if (userInServer(serverName, db3, serverStore, currUser) == false) {
    print("User is not in the Server");
    return;
  }
  print("In which channel do you want to message: ");
  String? channelName = stdin.readLineSync();

  Map? channelCheck = await channelStore.record(channelName).get(db4);
  if (channelCheck == null) {
    print("Channel does not exist");
    return;
  }
  // if (await userInChannel(db4, channelName, channelStore, currUser) == false) {
  //   print("User not in channel!!");
  //   return;
  // }

  if(await checkIfnewbie(db3,serverStore,currUser,serverName)){
    print("you need to be a mod or Creator to put messages");
    return;
  }

  print("Enter the message: ");
  String message = stdin.readLineSync() as String;
  Map messageKey = {'channel_name': channelName, 'server_name': serverName};
  Map messageValue = {'user': currUser.username, 'message': message};
  await channelDMStore.record(messageKey).put(db5, messageValue);
  print("Message sent successfully!!");

}

}
