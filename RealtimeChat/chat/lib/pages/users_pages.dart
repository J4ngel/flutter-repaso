import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final users = [
    User(online: true, email: 'Iguano@123', name: 'Iguano', uid: '1'),
    User(online: false, email: 'Rosamel@123', name: 'Rosendo', uid: '2'),
    User(online: true, email: 'andres@123', name: 'Jaime', uid: '3'),
    User(online: false, email: 'Felipe@123', name: 'Felipe', uid: '4'),
    User(online: false, email: 'J0han@123', name: 'Johan', uid: '5'),
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              )),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
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
    );
  }

  _loadUsers() async {
    //Trae la info de un endpoint
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
