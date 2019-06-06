import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './pages/ulip_qf.dart';
import './pages/ulip_rp.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch');
        print(message);
      },
      onMessage: (Map<String, dynamic> message) {
        print('onMessage');
        print(message);
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume');
        print(message);
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      print("+++++++++++FCM TOKEN++++++++++");
      print(token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple),
      // home: AuthPage(),
      routes: {
        '/': (BuildContext context) => _Home(UlipQf()),
        '/ulipQf': (BuildContext context) => _Home(UlipQf()),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'ulipRp') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => UlipRp(pathElements[2]),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => _Home(Container(
                  child: Text('Invalid Page. Please Go Back.'),
                )));
      },
    );
  }
}

class _Home extends StatelessWidget {
  final Widget _widget;

  _Home(this._widget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Coverfox'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Investment'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ulipQf');
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Car'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/carQf');
              },
            ),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text('Bike'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/bikeQf');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Coverfox'),
      ),
      body: Container(
        child: _widget,
      ),
    );
  }
}
