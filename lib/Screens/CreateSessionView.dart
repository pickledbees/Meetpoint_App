import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'SessionView.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';

///Represents the [View] portion of the Create Session View.
class CreateSessionView extends View<CreateSessionController> {
  CreateSessionView(c) : super(controller: c);
  static BuildContext viewContext;

  ///Builds up [Widget] tree of view.
  @override
  Widget build(BuildContext context) {
    viewContext = context;

    return Scaffold(
      appBar: AppBar(title: Text('Create Session'),),
      body: Center(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  controller.model.headerText,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: 200.0,
                child: TextFormField(
                  maxLength: 20,
                  maxLengthEnforced: true,
                  textAlign: TextAlign.center,
                  validator: controller.validate,
                  controller: controller.fieldController,
                  decoration: InputDecoration(
                    hintText: 'Session Title',
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Create'),
                onPressed: () => controller.createSessionAndNavigateToSession(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Represents the [Controller] portion of the Create Session View.
class CreateSessionController extends Controller<CreateSessionModel> {
  CreateSessionController(m) : super(model: m);
  TextEditingController fieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ///Checks if the 'Session Title' text field is empty.
  String validate(val) {
    if (val.isEmpty) return 'Please fill in session title';
  }

  ///Requests through [SessionManager_Client] to request for a session creation on the server side.
  ///Navigates user to [SessionView] of created session on success.
  createSessionAndNavigateToSession(BuildContext context) async {
    if (formKey.currentState.validate()) {
      try {
        //show loading text
        model.setHeaderTextTo('Creating your session...');
        //create session
        String sessionId =
        await SessionManager_Client.createSession(sessionTitle: fieldController.text);
        //navigate to view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => SessionView(SessionController(SessionModel(sessionId))),
        );
        Navigator.pushReplacement(context, route);
      } catch (e) {
        //show error
        model.showErrorDialog(e);
        model.setHeaderTextTo('Failed to create session, try again.');
      }
    }
  }

}

///Represents the [Model] portion of the Create Session View.
class CreateSessionModel extends Model {
  String headerText = 'Title your session below';

  ///Changes text prompt above the 'Session Title' text field.
  setHeaderTextTo(String text) {
    setViewState(() => headerText = text);
  }

  ///Shows error dialog box.
  showErrorDialog(error) {
    showDialog(
        context: CreateSessionView.viewContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        }
    );
  }
}