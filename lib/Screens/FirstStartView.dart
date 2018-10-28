import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/LocalInfoManagers/LocalUserInfoManager.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'HomeView.dart';

class FirstStartView extends View<FirstStartController> {

  FirstStartView(c) : super(controller: c);

  bool r = true;

  @override
  Widget build(BuildContext context) {
    if (r) controller.model.loadTiles();
    r = false;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0,),
                child: Text(
                  'Your Default Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0,),
                child: TextFormField(
                  validator: controller.validate,
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0,),
                child: TextFormField(
                  validator: controller.validate,
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0,),
                child: DropdownButton(
                  value: controller.model.dropdownButtonValue,
                  items: controller.model.items,
                  onChanged: controller.updatePreference,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        child: Text('Save'),
        onPressed: () => controller.save(context),
      ),
    );
  }
}

class FirstStartController extends Controller<FirstStartModel> {

  FirstStartController(m) : super(model: m);

  //controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  //key to access from
  final formKey = GlobalKey<FormState>();

  //validator for text fields
  String validate (val) {
    if (val.isEmpty) return 'This field is required';
  }

  //updates the value in the dropdown button
  updatePreference (val) {
    model.updateDropdownValue(val);
  }

  //saves the current inputs
  save (context) {

    if (formKey.currentState.validate()) {

      LocalUserInfoManager.localUser = UserDetails(
        name: nameController.text,
        prefStartCoords: Location(
          name: addressController.text,
          type: null,
          address: addressController.text,
        ),
        prefTravelMode: model.dropdownButtonValue,
      );

      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => HomeView(HomeController(HomeModel())),
      );
      Navigator.pushReplacement(context, route);

    }
  }
}

class FirstStartModel extends Model {
  
  String dropdownButtonValue = TravelModes.list[0];
  List<DropdownMenuItem> items = [];
  
  loadTiles() {
    for (String mode in TravelModes.list) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(mode,),
        value: mode,
      );
      items.add(item);
    }
  }
  
  updateDropdownValue(val) {
    setViewState(() => dropdownButtonValue = val);
  }
}