import 'package:flutter/material.dart';

///Super class for all view classes. Represents the 'view' portion of the application
abstract class View<C extends Controller> extends StatefulWidget {
  View({this.controller, Key key,}) : super(key: key);

  ///Controller of View
  final C controller;

  ///Creates the [State] object upon instantiation and addition to [Widget] tree.
  @override
  _ViewState createState() {
    _ViewState state = _ViewState(this);
    controller?._widget = this;
    controller?._state = state;
    controller?.model?._state = state;
    return state;
  }

  ///Reloads the [View], updating it.
  void setState(VoidCallback fn) {
    controller?.setViewState(fn);
  }

  ///Abstract method to be implemented, builds the [Widget] tree of the view.
  Widget build(BuildContext context);
}

///Represents the state of the view. [Controller] and [Model] classes interact with the [View] class through this class
class _ViewState extends State<View> {
  _ViewState(this._view);

  final View _view;

  ///Visually updates the associated [View] object.
  void reState(VoidCallback fn) {
    setState(fn);
  }

  ///Disposes of visual elements in the [Widget] tree the associated [View] object.
  void reDispose() {
    super.dispose();
  }

  ///Permanently removes a [Widget] in the [Widget] tree of the associated [View] object.
  void reDeactivate() {
    super.deactivate();
  }

  ///Sets up its own initial state.
  void reInitState() {
    super.initState();
  }

  ///Calls on its associated [View] to build its [Widget] tree.
  @override
  Widget build(BuildContext context) {
    return _view.build(context);
  }
}

///Super class for all controller classes. Represents the 'controller' portion of the application
abstract class Controller<M extends Model> {
  Controller({this.model});

  Widget _widget;
  _ViewState _state;
  M model;

  //to check if state object is loaded
  bool get mounted => _state?.mounted;

  //getter for reference to associated view widget, makes it available for subclasses.
  Widget get widget => _widget;

  ///Visually updates the associated [View] of this [Controller].
  void setViewState(VoidCallback fn) {
    _state.reState(fn);
  }
}

///Super class for all model classes. Represents the 'model' portion of the application
abstract class Model {
  _ViewState _state;

  //to check if state object is loaded
  bool get mounted => _state?.mounted;

  ///Visually updates the associated [View] of this [Model].
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

