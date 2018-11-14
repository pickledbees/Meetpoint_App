import 'package:flutter/material.dart';

//View abstract class
abstract class View<C extends Controller> extends StatefulWidget {
  View({this.controller, Key key,}) : super(key: key);

  final C controller;

  //pass reference of state object created to the controller and model
  //to allow access to state object
  @override
  _ViewState createState() {
    _ViewState state = _ViewState(this);
    controller?._widget = this;
    controller?._state = state;
    controller?.model?._state = state;
    return state;
  }

  //allows the view to be reloaded
  void setState(VoidCallback fn) {
    controller?.setViewState(fn);
  }

  //abstract method to be implemented, is used by the state class to rebuild
  Widget build(BuildContext context);
}

//_ViewState class: dependency class for View class
class _ViewState extends State<View> {
  _ViewState(this._view);

  final View _view;

  //allows outside classes to use the private class method 'setState()'
  void reState(VoidCallback fn) {
    setState(fn);
  }

  void reDispose() {
    super.dispose();
  }

  void reDeactivate() {
    super.deactivate();
  }

  void reInitState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _view.build(context);
  }
}

//Controller class
class Controller<M extends Model> {
  Controller({this.model});

  Widget _widget;
  _ViewState _state;
  M model;

  //to check if state object is loaded
  bool get mounted => _state?.mounted;

  //getter for reference to associated view widget, makes it available for subclasses
  Widget get widget => _widget;

  //allows controller to reload the view
  void setViewState(VoidCallback fn) {
    _state.reState(fn);
  }
}

//Model class
class Model {
  _ViewState _state;

  //to check if state object is loaded
  bool get mounted => _state?.mounted;

  //allows model to reload the view
  void setViewState(VoidCallback fn) {
    _state.reState(fn);
  }
}

















//Usage
class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterUI(CounterController(CounterModel())),
    );
  }
}

//view class extension
class CounterUI extends View<CounterController> {
  CounterUI(c) : super (controller: c); //pass controller up

  //controller instance member below comes from Controller superclass
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          controller.model._count.toString(),
          textScaleFactor: 1.5,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.doSomething(), //request to controller
      ),
    );
  }
}

//controller class extension
class CounterController extends Controller<CounterModel> {
  CounterController(m) : super(model: m); //pass model up

  //model instance member below comes from Model superclass

  //method to manipulate data
  void doSomething() {
    model.increment();
    model.multiply();
    model.subtract();
  }
}

//model class extension
class CounterModel extends Model {
  //data goes here
  int _count = 0;

  //notice how each model method reflects changes in data by calling setViewState()
  void increment() {
    setViewState(() => _count++);
  }

  void multiply() {
    setViewState(() => _count*=2);
  }

  void subtract() {
    setViewState(() => _count-=100);
  }
}

