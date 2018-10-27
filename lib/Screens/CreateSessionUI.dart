import 'package:flutter/material.dart';
import 'SessionViewUI.dart';

class CreateSessionUI extends StatefulWidget {
  @override
  _CreateSessionUIState createState() => _CreateSessionUIState();
}

class _CreateSessionUIState extends State<CreateSessionUI> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController tFieldController = TextEditingController();
  String buttonText = 'Create';

  @override
  void dispose() {
    tFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session'),),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: tFieldController,
                  decoration: InputDecoration(
                    hintText: 'Session Title',
                  ),
                  validator: (val) {
                    if (val.isEmpty) return 'Please fill in session title';
                  },
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text(buttonText),
                  onPressed: submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {

    if (!_formKey.currentState.validate()) return;

    setState(() => buttonText = 'Creating Session...');

    //request for update via controller
    //get update via model
    String sessionId; //= await createSession(tFieldController.text);

    //if can create, send to SessionViewUI
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SessionViewUI(sessionId),),
    );

    //else,
    setState(() => buttonText = 'Create');
    //show error dialog
  }
}