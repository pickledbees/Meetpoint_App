import 'package:flutter/material.dart';
import 'SessionViewUI.dart';

class JoinSessionUI extends StatefulWidget {
  @override
  _JoinSessionUIState createState() => _JoinSessionUIState();
}

class _JoinSessionUIState extends State<JoinSessionUI> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController tFieldController = TextEditingController();
  String buttonText = 'Join';

  @override
  void dispose() {
    tFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join'),),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: tFieldController,
                  decoration: InputDecoration(
                    hintText: 'Session ID',
                  ),
                  validator: (val) {
                    if (val.isEmpty) return 'Please fill in session ID';
                  },
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text('Join Session'),
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

    setState(() => buttonText = 'Joining Session...');

    String sessionId; //await createSession(tFieldController.text);

    //if can create, send to SessionViewUI
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SessionViewUI(sessionId),),
    );

    //else,
    setState(() => buttonText = 'Join');
    //show error dialog
  }
}