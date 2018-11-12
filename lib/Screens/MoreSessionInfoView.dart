import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';

class MoreSessionInfoView extends View<MoreSessionInfoController>{
  MoreSessionInfoView(c) : super(controller: c);
  static BuildContext viewContext;

  @override
  Widget build(BuildContext context) {
    viewContext = context;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                height: 200.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.network(Uri.encodeFull(controller.model.meetpoint.routeImage)),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Image.network(Uri.encodeFull(controller.model.meetpoint.routeImage2)),
                    ),
                  ],
                )
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
          ),
        ),
      ),
    );
  }
}

class MoreSessionInfoController extends Controller<MoreSessionInfoModel> {
  MoreSessionInfoController(m) : super(model: m);

  openInMaps() async {
    final List<double> coords = model.meetpoint.coordinates;
    double lat = coords[0];
    double lon = coords[1];
    final String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      model.showErrorDialog('Could not open ${model.meetpoint.name} in maps');
    }
  }

  searchOnGoogle() async {
    final String searchTerm = '${model.meetpoint.name}';
    final String url = 'https://www.google.com/search?q=${Uri.encodeFull(
        searchTerm)}';
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

  showErrorDialog(error) {
    showDialog(
        context: MoreSessionInfoView.viewContext,
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