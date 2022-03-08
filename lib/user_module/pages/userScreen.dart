import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'editUserScreen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final double titleImageHeight = 200;
  final double profileImageHeight = 120;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Profil'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const EditUserScreen()));
            },
          )
        ],
      ),
        body: Consumer<ApplicationState>(
          builder: (context, state, _) {
            return new Container(
                padding: EdgeInsets.all(10),
                child: new Column(
                  children: <Widget>[
                    picturesTop(),
                    nameAndUserName(state.currentUser!.customData!.fullName, state.currentUser!.customData!.nickname),
                    SizedBox(height: 30),
                    statisticInfo(),
                    SizedBox(height: 10),
                    const Divider(color: Colors.blueGrey, thickness: 0.8,),
                    SizedBox(height: 10),
                    about(),
                    SizedBox(height: 30),
                    logout()
                  ],
                )
            );
          }
        )
    );
  }

  Widget picturesTop() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileImageHeight / 2 + 10),
          child: backgroundImage(),
        ),
        Positioned(
            top: titleImageHeight - (profileImageHeight / 2),
            child: profileImage())
      ],
    );
  }

  Widget backgroundImage() {
    return Container(
        color: Colors.grey,
        child: Image.asset("assets/milan.jpg",
            width:  MediaQuery.of(context).size.width,
            height: titleImageHeight,
            fit: BoxFit.cover)
    );
  }

  Widget profileImage() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: profileImageHeight / 2 + 5,
      child: CircleAvatar(
        radius: profileImageHeight / 2,
        backgroundImage: AssetImage(
          "assets/ph_profile.png",
        ),
      )
    );
  }

  Widget nameAndUserName(String name, String username) {
    return Column(
      children: [
        Text(
            name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
            "@$username",
          style: TextStyle(
            color: Colors.lightBlue
          ),
        )
      ],
    );
  }

  Widget statisticInfo() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
              children: [
                Text(
                    "7",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    )
                ),
                Text("Reisen")
              ]
          )
        ),
        Expanded(
          flex: 3,
          child: Column(
              children: [
                Text(
                    "36",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    )
                ),
                Text("Tage")
              ]
          )
        ),
        Expanded(
            flex: 3,
            child: Column(
                children: [
                  Text(
                      "152",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                      )
                  ),
                  Text("Aktivitäten")
                ]
            )
        ),
      ],
    );
  }

  Widget about() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Hier sollte ein Text stehen.\n"
              "Dies könnte ein Spruch sein oder sonstiges.\n"
              "Eventuell auch eine dritte Zeile..."
        )
      ],
    );
  }

  Widget logout() {
    return Text(
      "Abmelden",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: 15
      ),
    );
  }
}

