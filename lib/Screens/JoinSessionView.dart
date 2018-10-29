import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'SessionView.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';

class JoinSessionView extends View<JoinSessionController> {

  JoinSessionView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JoinSession'),),
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
                  textAlign: TextAlign.center,
                  validator: controller.validate,
                  controller: controller.fieldController,
                  decoration: InputDecoration(
                    hintText: 'Session ID',
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Join'),
                onPressed: () => controller.joinSessionAndNavigateToSession(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JoinSessionController extends Controller<JoinSessionModel> {

  JoinSessionController(m) : super(model: m);

  TextEditingController fieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String validate(val) {
    if (val.isEmpty) return 'Please fill in session title';
  }

  joinSessionAndNavigateToSession(BuildContext context) async {

    if (formKey.currentState.validate()) {

      try {
        //show loading text
        model.setHeaderTextTo('Attempting to join session...');

        //join session
        await LocalSessionManager.joinSession(sessionId: fieldController.text);

        //navigate to view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => SessionView(SessionController(SessionModel(fieldController.text))),
        );
        Navigator.pushReplacement(context, route);

      } catch (e) {
        //show error
        model.setHeaderTextTo('Failed to join session, try again\nError:\n$e');

      }
    }
  }

}

class JoinSessionModel extends Model {

  String headerText = 'Key in session ID below';

  setHeaderTextTo(String text) {
    setViewState(() => headerText = text);
  }
}