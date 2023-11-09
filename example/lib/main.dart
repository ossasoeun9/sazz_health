import 'package:flutter/material.dart';
import 'package:sazz_health/sazz_health.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<NumberOfFallModel> numOfFalls = [];

  void getFalls() async {
    try {
      var hasPermission = await SazzHealthFactory.requestAuthorization();
      if (hasPermission ?? false) {
        var now = DateTime.now();
        numOfFalls = await SazzHealthFactory.readNumberOfFallen(
          now.subtract(const Duration(days: 365)),
          now,
        );
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    getFalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fall"),
        ),
        body: ListView.builder(
          itemCount: numOfFalls.length,
          itemBuilder: (context, index) {
            var numOfFall = numOfFalls[index];
            return ListTile(
              title: Text(numOfFall.dateTime.toString()),
              subtitle: Text(numOfFall.value.toString()),
            );
          },
        ),
      ),
    );
  }
}
