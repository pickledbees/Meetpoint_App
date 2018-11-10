import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreSessionInfoView extends View<MoreSessionInfoController>{
  MoreSessionInfoView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.model.meetpoint.name} - ${controller.model.session.title}',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                controller.model.meetpoint.name,
                textScaleFactor: 1.3,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              height: 300.0,
              child: Image.network(Uri.encodeFull(controller.model.meetpoint.routeImage),),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Open in Maps'),
                  onPressed: () => controller.openInMaps(),
                ),
                RaisedButton(
                  child: Text('See it on Google'),
                  onPressed: () => controller.searchOnGoogle(),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}

class MoreSessionInfoController extends Controller<MoreSessionInfoModel> {
  MoreSessionInfoController(m) : super(model: m);

  openInMaps() async {
    List<double> coords = model.meetpoint.coordinates;
    print(coords[0] + coords[1]);
  } //TODO: implement--------------------------------------------------------------

  searchOnGoogle() async {
    String searchTerm = '${model.meetpoint.name}';
    String url = "https://www.google.com/search?q=${Uri.encodeFull(
        searchTerm)}";
    if (await canLaunch(url)) {
      launch(url);
    } else {
      model.showErrorDialog('Could not launch $url');
    }
  }
}

class MoreSessionInfoModel extends Model {
  MoreSessionInfoModel(int meetpointIndex) {
    session = SessionManager_Client.getLoadedSession;
    meetpoint = session.meetpoints[meetpointIndex];
  }
  Session_Client session;
  Meetpoint_Client meetpoint;

  showErrorDialog(String errorMsg) {}
  //TODO: implement-----------------------------------------
}