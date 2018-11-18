import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/Managers/LocalUserInfoManager.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'HomeView.dart';

///Represents the [View] portion of the First Start View.
class FirstStartView extends View<FirstStartController> {
  FirstStartView(c) : super(controller: c);
  static bool r = true;

  ///Builds up [Widget] tree of view.
  @override
  Widget build(BuildContext context) {

    if (r) controller.model.loadTiles();
    r = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: LocalUserInfoManager.getLocalUser == null ? null : () => controller.navigateToHome(context),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0,),
                child: Text(
                  'Your Default Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromRGBO(11, 143, 160, 1.0),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0,),
                child: TextFormField(
                  validator: controller.validate,
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: LocalUserInfoManager.getLocalUser == null ? 'Name' : 'Name - ' + LocalUserInfoManager.getLocalUser.name,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0,),
                child: TextFormField(
                  validator: controller.validate,
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    hintText: LocalUserInfoManager.getLocalUser == null ? 'Address' : 'Address - ' + LocalUserInfoManager.getLocalUser.prefStartCoords.name,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0,),
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

///Represents the [Controller] portion of the First Start View.
class FirstStartController extends Controller<FirstStartModel> {
  FirstStartController(m) : super(model: m);
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ///Checks if fields are empty.
  String validate (val) {
    if (val.isEmpty) return 'This field is required';
  }

  ///Updates the value in the dropdown button for preferred travel mode.
  updatePreference (val) {
    model.updateDropdownValue(val);
  }

  ///Requests for a save of the user details on the server side, as well as calling on [LocalUserInfoManager] to save the user.
  save (context) async {
    //validate if empty
    if (formKey.currentState.validate()) {
      //set local user (may want to change to setter)
      UserDetails_Client user = UserDetails_Client(
        name: nameController.text,
        prefStartCoords: Location_Client(
          name: addressController.text,
          type: null,
          address: addressController.text,
        ),
        prefTravelMode: model.dropdownButtonValue,
      );

      try {
        bool success = await LocalUserInfoManager.saveUser(user);
        if (success) {
          navigateToHome(context);
        } else {
          throw 'Save failed, try again later';
        }
      } catch (error) {
        print(error);
      }
    }
  }
  //goes to homepage
  navigateToHome(BuildContext context) {
    HomeView.refresh = true;
    //navigate to page
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => HomeView(HomeController(HomeModel())),
    );
    Navigator.pushReplacement(context, route);
  }
}

///Represents the [Model] portion of the First Start View.
class FirstStartModel extends Model {
  String dropdownButtonValue = LocalUserInfoManager.getLocalUser == null ? TravelModes.getList[0] : LocalUserInfoManager.getLocalUser.prefTravelMode;
  List<DropdownMenuItem> items = [];

  ///Renders data required for the dropdown menu.
  loadTiles() {
    for (String mode in TravelModes.getList) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(mode,),
        value: mode,
      );
      items.add(item);
    }
  }

  ///visually update focus for the dropdown menu
  updateDropdownValue(val) {
    setViewState(() => dropdownButtonValue = val);
  }
}