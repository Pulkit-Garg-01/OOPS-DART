import 'package:sembast/sembast.dart';
import 'dart:io';
import 'package:crypt/crypt.dart';

class User {
  String? username = "0";
  String? password = "0";

  User(this.username, this.password);

  register(Database db1, StoreRef<String?, String?> user_store1, var records,
      User currUser) async {
    bool comp = true;

    stdout.write("\nEnter username : ");

    currUser.username = stdin.readLineSync();

    if (await FindUser(currUser.username, db1, user_store1)) {
      while (comp) {
        stdout.write("\nEnter Password : ");
        currUser.password = stdin.readLineSync();

        String? hash1 = hashpwd(currUser.password);
        stdout.write("\nRe-Enter Password : ");
        String? password2 = stdin.readLineSync();
        //  String hash2= hashpwd(password2);
        if (currUser.password == password2) {
          await user_store1.record(currUser.username).put(db1, hash1);

          stdout.write("\nUser registered Successfully!!");

          comp = false;
        } else {
          stdout.write("\npasswords dont match!!!");
        }
      }
    } else {
      print("User already registered. Try using different username!!");
    }
  }

  login(Database db1, StoreRef<String?, String?> user_store1, var records,
      User currUser) async {
    // print(currUser.username);
    if (currUser.username != "0") {
      var a = currUser.username;
      print("user $a already logged in!!");
      return;
    }

    print("Enter Username : ");
    currUser.username = stdin.readLineSync();
    if (await FindUser(currUser.username, db1, user_store1) == true) {
      print("User must be registered first!!");
      print("Follow the protocoals..");
    } else {
      print("Enter password for ${currUser.username} :");
      currUser.password = stdin.readLineSync();
      var hash_pwd =
          await user_store1.record(currUser.username).get(db1) as String;
      if (comparePwd(currUser.password!, hash_pwd)) {
        //User someUser = new User(username! , password);
        print("User ${currUser.username} logged in successfully!:)");
      } else {
        print("Incorrect password.");
        print("Try Login again!");
      }
    }
  }
}

Future<bool> FindUser(String? username, Database db, StoreRef storename) async {
  var record = await storename.find(db);
  for (var rec in record) {
    if (rec.key == username) {
      return false;
    }
  }
  return true;
}

hashpwd(String? pass) {
  return Crypt.sha256(pass!, rounds: 1000).toString();
}

bool comparePwd(String enteredPassword, String hash_pwd) {
  final hashedPwd = Crypt(hash_pwd);
  return hashedPwd.match(enteredPassword);
}
