import 'package:flutter/material.dart';
import 'package:crud_flutter_sqlite/core/db_provider.dart';
import 'package:crud_flutter_sqlite/core/user_model.dart';

class AddEditUser extends StatefulWidget {
  final bool edit;
  final UserModel User;

  AddEditUser(this.edit, {this.User})
      : assert(edit == true || User ==null);

  @override
  _AddEditClientState createState() => _AddEditClientState();
}

class _AddEditClientState extends State<AddEditUser> {

  TextEditingController first_nameEditingController = TextEditingController();
  TextEditingController last_nameEditingController  = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(widget.edit == true){
      first_nameEditingController.text = widget.User.first_name;
      last_nameEditingController.text = widget.User.last_name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.edit ? "Edit Usuario" : "Add Usuario"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                textFormField(first_nameEditingController, "Nombre", "Enter Nombre",
                    Icons.person, widget.edit ? widget.User.first_name : "Nombre"),
                textFormField(last_nameEditingController, "Apellido", "Enter Apellido",
                  Icons.person, widget.edit ? widget.User.last_name : "Apellido",),

                RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Save',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()){

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data'))
                      );

                    }else if (widget.edit == true) {

                      await DBProvider.db.update(new UserModel(
                         first_name : first_nameEditingController.text,
                          last_name: last_nameEditingController.text,
                          userId: widget.User.userId ));
                      Navigator.pop(context);
                    }else {

                      await DBProvider.db.save(UserModel(
                          first_name: first_nameEditingController.text,
                          last_name: last_nameEditingController.text
                      ));

                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFormField(TextEditingController t, String label, String hint, IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        validator: (value){
          if (value.isEmpty) {
            return 'requerido';
          }
        },
        controller: t,
        //keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
      ),
    );
  }
}