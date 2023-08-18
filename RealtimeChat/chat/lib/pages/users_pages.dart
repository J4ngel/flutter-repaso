import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final usersService = UsersService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final users = [
  //   User(online: true, email: 'Iguano@123', name: 'Iguano', uid: '1'),
  //   User(online: false, email: 'Rosamel@123', name: 'Rosendo', uid: '2'),
  //   User(online: true, email: 'andres@123', name: 'Jaime', uid: '3'),
  //   User(online: false, email: 'Felipe@123', name: 'Felipe', uid: '4'),
  //   User(online: false, email: 'J0han@123', name: 'Johan', uid: '5'),
  // ];
  List<User> users = [];

  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
        appBar: AppBar(
          title: Text(user!.name, style: TextStyle(color: Colors.black)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                //Desconectarse del socket server
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
                socketService.disconnect();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              )),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.red[600],
                    ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _loadUsers,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.green,
            ),
            waterDropColor: Colors.green,
          ),
          child: _usersListView(),
        ));
  }

  ListView _usersListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    //Trae la info de un endpoint
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    this.users = await usersService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}
