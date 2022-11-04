// Local Import
import 'package:firebase_core/firebase_core.dart';
import 'package:my_meds/screens/more.dart';

import 'utilities/notification_services.dart';

// Screens
import 'package:my_meds/LanguageTranslator.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:my_meds/screens/reminders.dart';
import 'package:my_meds/utilities/db_helper.dart';
import 'package:my_meds/widgets/themes.dart';

import 'screens/home.dart';
import 'screens/pharmContact/pharm_contact.dart';

// Library Import
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'scheduled_group',
            channelKey: 'scheduled',
            channelName: 'Medications and Activities',
            channelDescription: 'Notification channel for medications and activities',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'schedule_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<
      NavigatorState>();

  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LanguageMapping(),
      locale: const Locale('en', 'US'),
      title: 'TO be named',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        // // primarySwatch: MaterialColor(0x003C91E6),
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   background: const  Color(0x00bfd2bf),
        //   primary: const Color(0x0056494E),
        //   secondary: const Color(0x003C91E6),
        //
        //   // secondary:,
        // ),
        // fontFamily: 'Roboto',
      ),
      home: const NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int navigationIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _notificationController = Get.put(NotificationController());

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController
            .onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController
            .onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController
            .onDismissActionReceivedMethod
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: navigationIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.event_outlined, size: 30.0),
          Icon(Icons.map, size: 30),
          Icon(Icons.more, size: 30.0),
        ],

         color: const Color(0xFF088F6F),
        buttonBackgroundColor: const Color(0x00BFD2BF),
        backgroundColor: const Color(0x00D1B490),
        animationCurve: Curves.easeInSine,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            navigationIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: const Color(0x0056494E),
        height: double.infinity,
        width: double.infinity,
        child: primaryFeature(index: navigationIndex),
      ),
    );
  }

  Widget primaryFeature({required int index}) {
    switch (index) {
      case 1:
        return Reminder(); // Ashmit

      case 2:
        return const PharmContactScreen(); //Rujal

      case 3:
        return const More();

      default:
        return const HomeScreen();
    }
  }
//
// class LocaleString extends Translations {
// @override
// Map<String, Map<String, String>> get keys =>
// {
// 'en_US': {
// 'medicine': 'Medicine',
// 'namaste': 'namaste'
// },
// 'ne_NP': {
// 'medicine': 'औषधि',
// 'namaste': 'नमस्ते',
// }
// };
//   >>>>>>> Stashed changes
//   }
//
//   void main() {
//   runApp(MyApp());
//   }
//
//   class MyApp extends StatelessWidget {
// // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//   return GetMaterialApp(
//   debugShowCheckedModeBanner: false,
//   translations: LocaleString(),
//   locale: Locale('en','US'),
//   title: 'Flutter Demo',
//   theme: ThemeData(
//   primarySwatch: Colors.blue,
//   ),
//   home: HomePage(),
//   );
//   }
//   }
//
//
//   class HomePage extends StatelessWidget {
//   final List locale = [
//   {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
//   {'name': 'नेपाली', 'locale': Locale('ne', 'NP')},
//   ];
//   updateLanguage(Locale locale) {
//   Get.back();
//   Get.updateLocale(locale);
//   }
// //ChangeLanguageAlertDialog Start
//   ChangeLanguageAlertDialog(BuildContext context) {
// // set up the button
//   Widget okButton = TextButton(
//   child: Text("OK"),
//   onPressed: () {},
//   );
// // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//   title: const Text('Choose Your Language'),
//   content: Container(
//   width: double.maxFinite,
//   child: ListView.separated(
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//   return Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: GestureDetector(
//   child: Text(locale[index]['name']),
//   onTap: () {
// // print(locale[index]['name']);
//   updateLanguage(locale[index]['locale']);
//   },
//   ),
//   );
//   },
//   separatorBuilder: (context, index) {
//   return Divider(
//   color: Colors.blue,
//   );
//   },
//   itemCount: locale.length)),
//   );
// // show the dialog
//   showDialog(
//   context: context,
//   builder: (BuildContext context) {
//   return alert;
//   },
//   );
//   }
// //ChangeLanguageAlertDialog End
//   @override
//   Widget build(BuildContext context) {
//   return Scaffold(
//   appBar: AppBar(
//   title: Text('title'),
//   ),
//   body: Column(
//
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//   Text(
//
//   ' ${'medicine'.tr} ${'namaste'.tr}',
//   style: TextStyle(fontSize: 15),
//   ),
//   SizedBox(
//   height: 10,
//   ),
//   Text(
//   'message'.tr,
//   style: TextStyle(fontSize: 20),
//   ),
//   SizedBox(
//   height: 10,
//   ),
//   Text(
//   'subscribe'.tr,
//   style: TextStyle(fontSize: 20),
//   ),
//   ElevatedButton(
//   onPressed: () {
//   ChangeLanguageAlertDialog(context);
//   },
//   child: Text('changelang'.tr)),
//   ],
//   ));
//   }
//   }
//
//
// // import 'package:my_meds/LanguageChange.dart';
// // import 'package:my_meds/screens/reminders.dart';
// // import 'package:my_meds/utilities/db_helper.dart';
// //
// // import 'generated/l10n.dart';
// // import 'screens/home.dart';
// // import 'screens/pharm_contact.dart';
// //
// // // Library Import
// // import 'package:flutter/material.dart';
// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// // import 'package:get/get.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:my_meds/screens/more.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:provider/provider.dart';
// //
// //
// // Future main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await DBHelper.initDb();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// //
// // something()  async {
// // }
// //
// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider<LanguageChangeProvider>(
// //       create: (context) =>  LanguageChangeProvider(),
// //       child: Builder(
// //         builder: (context) =>
// //             GetMaterialApp(
// //               locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
// //               localizationsDelegates: [
// //                 S.delegate,
// //                 GlobalMaterialLocalizations.delegate,
// //                 GlobalWidgetsLocalizations.delegate,
// //                 GlobalCupertinoLocalizations.delegate,
// //               ],
// //               supportedLocales: S.delegate.supportedLocales,
// //               title: 'Flutter Demo',
// //               theme: ThemeData(
// //                 // This is the theme of your application.
// //                 //
// //                 // Try running your application with "flutter run". You'll see the
// //                 // application has a blue toolbar. Then, without quitting the app, try
// //                 // changing the primarySwatch below to Colors.green and then invoke
// //                 // "hot reload" (press "r" in the console where you ran "flutter run",
// //                 // or simply save your changes to "hot reload" in a Flutter IDE).
// //                 // Notice that the counter didn't reset back to zero; the application
// //                 // is not restarted.
// //                 primarySwatch: Colors.blue,
// //               ),
// //               home: MyHomePage(title: 'Flutter Demo Home Page'),
// //             ),
// //       ),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key? key, required this.title}) : super(key: key);
// //
// //   // This widget is the home page of your application. It is stateful, meaning
// //   // that it has a State object (defined below) that contains fields that affect
// //   // how it looks.
// //
// //   // This class is the configuration for the state. It holds the values (in this
// //   // case the title) provided by the parent (in this case the App widget) and
// //   // used by the build method of the State. Fields in a Widget subclass are
// //   // always marked "final".
// //
// //   final String title;
// //
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   int _counter = 0;
// //
// //   void _incrementCounter() {
// //     setState(() {
// //       // This call to setState tells the Flutter framework that something has
// //       // changed in this State, which causes it to rerun the build method below
// //       // so that the display can reflect the updated values. If we changed
// //       // _counter without calling setState(), then the build method would not be
// //       // called again, and so nothing would appear to happen.
// //       _counter++;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // This method is rerun every time setState is called, for instance as done
// //     // by the _incrementCounter method above.
// //     //
// //     // The Flutter framework has been optimized to make rerunning build methods
// //     // fast, so that you can just rebuild anything that needs updating rather
// //     // than having to individually change instances of widgets.
// //     return Scaffold(
// //       appBar: AppBar(
// //         // Here we take the value from the MyHomePage object that was created by
// //         // the App.build method, and use it to set our appbar title.
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         // Center is a layout widget. It takes a single child and positions it
// //         // in the middle of the parent.
// //         child: Column(
// //           // Column is also a layout widget. It takes a list of children and
// //           // arranges them vertically. By default, it sizes itself to fit its
// //           // children horizontally, and tries to be as tall as its parent.
// //           //
// //           // Invoke "debug painting" (press "p" in the console, choose the
// //           // "Toggle Debug Paint" action from the Flutter Inspector in Android
// //           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// //           // to see the wireframe for each widget.
// //           //
// //           // Column has various properties to control how it sizes itself and
// //           // how it positions its children. Here we use mainAxisAlignment to
// //           // center the children vertically; the main axis here is the vertical
// //           // axis because Columns are vertical (the cross axis would be
// //           // horizontal).
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(S.of(context).medicine),
// //             Text(
// //               'You have pushed the button this many times:',
// //             ),
// //             Text(
// //               '$_counter',
// //               style: Theme.of(context).textTheme.headline4,
// //             ),
// //             ElevatedButton(onPressed: (){
// //               context.read<LanguageChangeProvider>().changeLocale("hi");
// //             }, child: Text("Hindi")),
// //             ElevatedButton(onPressed: (){
// //               context.read<LanguageChangeProvider>().changeLocale("en");
// //             }, child: Text("English")),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _incrementCounter,
// //         tooltip: 'Increment',
// //         child: Icon(Icons.add),
// //       ), // This trailing comma makes auto-formatting nicer for build methods.
// //     );
// //   }
// // }
}
