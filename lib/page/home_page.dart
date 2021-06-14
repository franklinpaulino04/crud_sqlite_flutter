import 'package:crud_flutter_sqlite/core/db_provider.dart';
import 'package:crud_flutter_sqlite/core/user_model.dart';
import 'package:crud_flutter_sqlite/page/add_edit_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sqlite CRUD'),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: (){
              DBProvider.db.deleteAll();
              setState(() {

              });
            },
            child: Text('Delete All',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: DBProvider.db.listData(),
        builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
               UserModel user = snapshot.data[index];

               return Dismissible(
                 key: UniqueKey(),
                 background: Container(color: Colors.red),
                 onDismissed: (diretion){
                   DBProvider.db.delete(user.userId);
                 },
                 child: ListTile(
                   title: Text(user.first_name),
                   subtitle: Text(user.last_name),
                   leading: CircleAvatar(child: Text(user.userId.toString()
                      ),
                   ),
                   onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                       builder: (context) => AddEditUser(
                         true,
                         User: user
                       )
                     ));
                   },
                 ),
               );
              },
            );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditUser(false)));
        },
      ),
    );
  }
}
