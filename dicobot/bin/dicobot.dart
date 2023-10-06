import 'package:dicobot/database.dart';
import 'package:dicobot/models/users.dart';
// import 'package:dicobot/deleted/register.dart';
import 'dart:io';
import 'package:sembast/sembast.dart';
// import '../lib/models/users.dart';
// import 'package:dicobot/ADMIN.dart';
// import 'package:dicobot/deleted/sendDM.dart';
import 'package:dicobot/models/DM.dart';
import 'package:dicobot/models/SERVERs.dart';
// import 'package:dicobot/deleted/joinserver.dart';
// import 'package:dicobot/deleted/addCategory.dart';
import 'package:dicobot/models/Channel.dart';
// import 'package:dicobot/deleted/sendChannelMsg.dart';
// import 'package:dicobot/deleted/readChannelMsg.dart';

void main(List<String> arguments) async {
  User currUser = User("0", "0");
  User regUser = User("0", "0");
  // User use=User();
  message mes = message();
  // Admin ad=Admin();
  Servers ser=Servers();
  Channel channel=Channel();

  var st = databaseFeatures.constructor1();
  List<dynamic> myList = await st.connection();
  Database db1 = myList[0];
  Database db2 = myList[1];
  Database db3 = myList[2];
  Database db4 = myList[3];
  Database db5 = myList[4];

  StoreRef<String?, String?> user_store1 = myList[5];
  StoreRef<String?, String?> personalStore = myList[6];
  StoreRef<dynamic, dynamic> serverStore = myList[7];
  StoreRef<String?, Map> channelStore = myList[8];
  StoreRef<Map, Map> channelDMStore = myList[9];

  var records = myList[10];
  var dmQuery = myList[11];
  var serverQuery = myList[12];

  bool running = true;
  while (running) {
    stdout.write('\n \$\$ ');
    var input = stdin.readLineSync() as String;
    switch (input) {
      case "register":
        await regUser.register(db1, user_store1, records, regUser);
        break;

      case "login":
        await regUser.login(db1, user_store1, records, currUser);
        break;

      case "sendDM":
        await mes.sendDM(db1, user_store1, db2, personalStore, dmQuery, currUser);
        break;

      case "readDM":
        await mes.readDM(db1, user_store1, db2, personalStore, dmQuery, currUser);
        break;

      case "logout":
        print("${currUser.username} logged out successfully!!");
        currUser.username = "0";
        break;

      case "create server":
        await ser.createServer(
            db1, user_store1, db3, serverStore, serverQuery, currUser);
        break;

      case "join server":
        await ser.joinServer(
            db1, user_store1, db3, serverStore, serverQuery, currUser);
        break;

      case "add category":
        await ser.addCategory(
            db1, user_store1, db3, serverStore, serverQuery, currUser);
        break;

      case "add channel":
        await channel.addChannel(db1, user_store1, db3, serverStore, serverQuery,
            currUser, db4, channelStore);
        break;

      case "send channel msg":
        await channel.sendChannelMsg(db1, db3, db4, db5, user_store1, serverStore,
            channelStore, channelDMStore, currUser);
        break;
      case "read channel msg":
        await channel.readChannelMsg(db1, db3, db4, db5, user_store1, serverStore,
            channelStore, channelDMStore, currUser);
        break;

      case "exit":
        print("Thanks for using Discord CLI !!");
        running = false;
        break;

      default:
        print("\nInvalid input");
        print("Try reading Docs!!");
    }
  }
  await db1.close();
  await db2.close();
  await db3.close();
  await db4.close();
  await db5.close();
}
