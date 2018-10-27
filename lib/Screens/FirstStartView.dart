import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/LocalUserInfoManager.dart';
import 'package:meetpoint/Models/TravelModes.dart';
import 'HomeView.dart';

class FirstStartView extends View<FirstStartController> {

  FirstStartView(c) : super(controller: c);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200.0,
                child: TextFormField(
                  validator: null,
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Container(
                width: 200.0,
                child: TextFormField(
                  validator: null,
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                ),
              ),
              /*
              DropdownButton(
                items: null,
                onChanged: null,
              ),
              */
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        child: Text('Save'),
        onPressed: null,
      ),
    );
  }
}

class FirstStartController extends Controller {

  //FirstStartController(m) : super(model: m);

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

}



class FirstStartUI extends StatefulWidget {
  @override
  _FirsStartUIState createState() => _FirsStartUIState();
}

class _FirsStartUIState extends State<FirstStartUI> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedTravelMode;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //make dropdown list
    List<DropdownMenuItem> dropDownList;
    TravelModes.list.forEach((String mode) {
      DropdownMenuItem item = DropdownMenuItem(
        value: mode,
        child: Text(mode),
      );
      dropDownList.add(item);
    });

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val.isEmpty) return 'Please fill in your name';
                  },
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  controller: addressController,
                  validator: (val) {
                    if (val.isEmpty) return 'Please fill in your name';
                  },
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Container(
                child: DropdownButton(
                  value: selectedTravelMode,
                  hint: Text('Preferred Travel Mode'),
                  items: dropDownList,
                  onChanged: (value){
                    setState(() {
                      selectedTravelMode = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        child: Text('Save'),
        onPressed: () {
          String name = nameController.text;
          String address = addressController.text;
          String travelMode = selectedTravelMode;
          //save data
          //if data can be saved, got to home view UI
          Navigator.pushNamed(
            context,
            '/',);
        },
      ),
    );
  }
}