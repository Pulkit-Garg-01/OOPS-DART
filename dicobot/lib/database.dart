import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class databaseFeatures{
late final db1;
late final db2;
late final db3;

late final db4;
late final db5;

late final user_store1;
late final personalStore;
late final serverStore;
late final channelStore;
late final channelDMStore;

late final records;
late final dmQuery;
late final serverQuery;



databaseFeatures.constructor1();
databaseFeatures(
  this.db1,
  this.db2,
  this.db3,
  this.db4,
  this.db5,
  
  this.user_store1,
  this.personalStore,
  this.serverStore,
  this.channelStore,
  this.channelDMStore,

  this.records,
  this.dmQuery,
  this.serverQuery
  );
  Future<List> connection() async {
    const path_users='/Users/pulkitgarg/Desktop/dicobot/lib/database/users.db';
    const path_personal ='/Users/pulkitgarg/Desktop/dicobot/lib/database/personal_dm.db';
    const path_server='/Users/pulkitgarg/Desktop/dicobot/lib/database/server.db';
    const path_channel='/Users/pulkitgarg/Desktop/dicobot/lib/database/channel.db';
    const path_channelDM='/Users/pulkitgarg/Desktop/dicobot/lib/database/channel_dm.db';

    final DatabaseFactory db_factory = databaseFactoryIo;


    Database db1 = await db_factory.openDatabase(path_users);  
    Database db2= await db_factory.openDatabase(path_personal);
    Database db3 =await db_factory.openDatabase(path_server);
    Database db4 =await db_factory.openDatabase(path_channel);
    Database db5 =await db_factory.openDatabase(path_channelDM);
    

    StoreRef<String?, String?> user_store1 = StoreRef<String?, String?>.main();
    StoreRef<String? , String?> personalStore = StoreRef<String? , String?>.main();
    StoreRef<dynamic,dynamic> serverStore= StoreRef<dynamic,dynamic>.main();
    StoreRef<String?,Map> channelStore = StoreRef<String?,Map>.main();
    StoreRef<Map,Map> channelDMStore = StoreRef<Map,Map>.main();


    var records = await user_store1.find(db1);
    var dmQuery = await personalStore.find(db2);
    var serverQuery = await serverStore.find(db3);

    databaseFeatures databaseObject = databaseFeatures(
     db1,
     db2,
     db3,
     db4,
     db5,
     user_store1, 
     personalStore,
     serverStore,
     channelStore,
     channelDMStore,
     records,
     dmQuery,
     serverQuery
     );

    return[
      databaseObject.db1,
      databaseObject.db2,
      databaseObject.db3,
      databaseObject.db4,
      databaseObject.db5,

      databaseObject.user_store1,
      databaseObject.personalStore,
      databaseObject.serverStore,
      databaseObject.channelStore,
      databaseObject.channelDMStore,

      databaseObject.records,
      databaseObject.dmQuery,
      databaseObject.serverQuery
      
    ];
  }
}

// void variables() async{
//   var st =databaseFeatures.constructor1();
//   List<dynamic> myList = await st.connection();
//   Database db1 = myList[0];

//   StoreRef<String?, String?> user_store1 = myList[1];

//    var records = myList[2];
   
// }




















