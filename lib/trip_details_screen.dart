import 'package:flutter/material.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("New York City"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("+ Aktivität", style: TextStyle(color: Colors.white),),
          ),
        ],
        //toolbarHeight: MediaQuery.of(context).size.height * 0.001,
      ),

    );
  }
}
