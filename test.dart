import 'dart:io';

class User {
  String username;
  String password;

  User(this.username, this.password);
}

class UserAuthenticator {
  List<User> registeredUsers;

  UserAuthenticator() : registeredUsers = [];

  void registerUser(String username, String password) {
    User newUser = User(username, password);
    registeredUsers.add(newUser);
    print('User registered successfully!');
  }

  bool authenticateUser(String username, String password) {
    for (var user in registeredUsers) {
      if (user.username == username && user.password == password) {
        return true;
      }
    }
    return false;
  }
}

void main() {
  UserAuthenticator authenticator = UserAuthenticator();

  bool isRunning = true;

  while (isRunning) {
    print('1. Register a new user');
    print('2. Login');
    print('3. Exit');

    stdout.write('Enter your choice (1-3): ');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        stdout.write('Enter username: ');
        String username = stdin.readLineSync()!;
        stdout.write('Enter password: ');
        String password = stdin.readLineSync()!;
        authenticator.registerUser(username, password);
        break;
      case '2':
        stdout.write('Enter username: ');
        String username = stdin.readLineSync()!;
        stdout.write('Enter password: ');
        String password = stdin.readLineSync()!;
        bool isAuthenticated = authenticator.authenticateUser(username, password);
        if (isAuthenticated) {
          print('Login successful!');
        } else {
          print('Login failed. Invalid username or password.');
        }
        break;
      case '3':
        isRunning = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.');
    }

    print('');
  }
}
