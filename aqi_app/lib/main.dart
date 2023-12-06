// ignore_for_file: unused_local_variable, unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Gabarito',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Air Quality Prediction',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double? p1;
  double? p2;
  double? p3;
  double? p4;
  String? place;
  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  DateTime dat = DateTime.now().add(Duration(days: 2));
  DateTime dadat = DateTime.now().add(Duration(days: 3));

  LocationData? _currentPosition;
  Location location = Location();

  Future getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentPosition = await location.getLocation();
  }

  // Future<Map<String, dynamic>>
  fetchData() async {
    await getLoc();
    print(_currentPosition!.latitude);
    print(_currentPosition!.longitude);
    String url =
        'http://10.0.2.2:5000/api?query=${_currentPosition!.latitude}|${_currentPosition!.longitude}';
    // String url1 =
    //     "http://api.weatherapi.com/v1/current.json?key=ef67efc7ab6d48cd89540707230204&q=${_currentPosition!.latitude},${_currentPosition!.longitude}&aqi=no";
    // String url2 =
    //     "https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&appid=168f350bf1717adf4a0541d23934e2c1";
    // String url3 =
    //     "http://api.openweathermap.org/data/2.5/forecast?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&appid=168f350bf1717adf4a0541d23934e2c1";

    // final response1 = await http.get(Uri.parse(url));
    // final response2 = await http.get(Uri.parse(url2));
    // final response3 = await http.get(Uri.parse(url3));

    try {
      final res = await http.get(Uri.parse(url));
      print(jsonDecode(res.body));
      p1 = jsonDecode(res.body)[0][0];
      p2 = jsonDecode(res.body)[1][0];
      p3 = jsonDecode(res.body)[2][0];
      p4 = jsonDecode(res.body)[3][0];
      place = jsonDecode(res.body)[4];
    } catch (e) {
      print(e);
    }

    // if (response1.statusCode == 200
    //     //  &&
    //     // response2.statusCode == 200 &&
    //     // response3.statusCode == 200
    //     ) {
    //   print(jsonDecode(response1.body));
    //   return jsonDecode(response1.body);
    // } else {
    //   throw Exception('Failed to load data');
    // }
    print(url);
  }

  late TabController? tabController;
  late List<ChartData> chartData;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  'Hold your breath while I predict air quality...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SfRadialGauge(
                      axes: [
                        RadialAxis(
                          minimum: 20,
                          maximum: 200,
                          interval: 10,
                          ranges: [
                            GaugeRange(
                              startWidth: 5,
                              endWidth: 10,
                              startValue: 20,
                              endValue: 80,
                              color: Color(0xFF79AC78),
                            ),
                            GaugeRange(
                              startWidth: 10,
                              endWidth: 15,
                              startValue: 80,
                              endValue: 160,
                              color: Color(0xFfF4E869),
                            ),
                            GaugeRange(
                              startWidth: 15,
                              endWidth: 15,
                              startValue: 160,
                              endValue: 200,
                              color: Color(0xFFFF6969),
                            ),
                            //   ranges: [
                            //   GaugeRange(
                            //     startWidth: 5,
                            //     endWidth: 10,
                            //     startValue: 20,
                            //     endValue: 60,
                            //     color: Color(0xFFa1dc60),
                            //   ),
                            //   GaugeRange(
                            //     startWidth: 10,
                            //     endWidth: 15,
                            //     startValue: 61,
                            //     endValue: 100,
                            //     color: Color(0xFFfbd650),
                            //   ),
                            //   GaugeRange(
                            //     startWidth: 15,
                            //     endWidth: 15,
                            //     startValue: 100,
                            //     endValue: 150,
                            //     color: Color(0xFFff9b56),
                            //   ),
                            //   GaugeRange(
                            //     startWidth: 15,
                            //     endWidth: 15,
                            //     startValue: 150,
                            //     endValue: 200,
                            //     color: Color(0xFFff6a6f),
                            //   ),
                            //   GaugeRange(
                            //     startWidth: 15,
                            //     endWidth: 15,
                            //     startValue: 200,
                            //     endValue: 300,
                            //     color: Color(0xFFab7cbc),
                            //   ),
                            //   GaugeRange(
                            //     startWidth: 15,
                            //     endWidth: 15,
                            //     startValue: 300,
                            //     endValue: 500,
                            //     color: Color(0xFF9b5974),
                            //   ),
                            // ],
                          ],
                          pointers: [
                            WidgetPointer(
                                value: p1!,
                                enableAnimation: true,
                                child: Image(
                                  width: 30,
                                  image: AssetImage('assets/images/air.png'),
                                ))
                            // const NeedlePointer(

                            //   value: 60,
                            //   enableAnimation: true,
                            // )
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    p1!.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.cloud,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        p1! <= 50
                                            ? ' Good'
                                            : p1! <= 100
                                                ? ' Moderate'
                                                : p1! <= 150
                                                    ? ' Sensitive'
                                                    : p1! <= 200
                                                        ? ' Unhealthy'
                                                        : p1! <= 300
                                                            ? 'Very Unhealthy'
                                                            : 'Hazardous',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.location_solid,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        place!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Image(
                                  //       width: 30,
                                  //       image: AssetImage(
                                  //           'assets/images/sunny.png'),
                                  //     ),
                                  //     // Text(
                                  //     //   '28oC',
                                  //     //   style: TextStyle(
                                  //     //     color: Colors.white,
                                  //     //   ),
                                  //     // )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'AQI Forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 84, 84, 84),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: TabBar(
                            controller: tabController,
                            labelColor: Colors.black,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            tabs: [
                              Tab(
                                child: Text(
                                  '12',
                                  style: TextStyle(
                                    fontSize: 7,
                                  ),
                                ),
                              ),
                              Tab(
                                child: FaIcon(
                                  FontAwesomeIcons.chartArea,
                                  size: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 320,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Column(
                          children: [
                            PredictionBox(
                              color: const Color(0xFFf9d26b),
                              p: p1!,
                              df: DateFormat.MMMEd().format(
                                  DateTime.now().add(Duration(days: 1))),
                              name: 'Tomorrow',
                            ),
                            PredictionBox(
                              color: const Color(0xFFc19ff8),
                              p: p2!,
                              df: DateFormat.MMMEd().format(
                                  DateTime.now().add(Duration(days: 2))),
                              name: 'Day after Tomorrow',
                            ),
                            PredictionBox(
                              color: const Color(0xFF57bf9c),
                              p: p3!,
                              df: DateFormat.MMMEd().format(
                                  DateTime.now().add(Duration(days: 3))),
                              name: 'Day after',
                            ),
                          ],
                        ),
                        Image(
                          image: AssetImage('assets/images/chart.jpg'),
                        )
                        // SfCartesianChart(
                        //   borderColor: Colors.black,
                        //   primaryXAxis: CategoryAxis(),
                        //   series: <ChartSeries>[
                        //     AreaSeries<ChartData, String>(
                        //         dataSource: [
                        //           ChartData(DateFormat.E().format(today), p1!),
                        //           ChartData(
                        //               DateFormat.E().format(tomorrow), p2!),
                        //           ChartData(DateFormat.E().format(dat), p3!),
                        //           ChartData(DateFormat.E().format(dadat), p4!),
                        //         ],
                        //         xValueMapper: (ChartData data, _) => data.x,
                        //         yValueMapper: (ChartData data, _) => data.y)
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class PredictionBox extends StatelessWidget {
  PredictionBox(
      {super.key,
      required this.color,
      required this.p,
      required this.df,
      required this.name});

  Color color;
  double p;
  String df;
  String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(CupertinoIcons.calendar),
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    df,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                p.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
