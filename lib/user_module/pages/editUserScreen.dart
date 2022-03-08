import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/custom_user_data.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final double titleImageHeight = 200;
  final double profileImageHeight = 120;

  @override
  Widget build(BuildContext context) {
    //final dataService = context.read<UserDataService>();
    //dataService.updateUserProfileAsync(CustomUserData(nickname, fullName, photoUrl, biography, trips));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
          title: Text('Profil'),
        ),
        body: new Container(
            padding: EdgeInsets.all(10),
            child: new Column(
              children: <Widget>[
                picturesTop(),
                SizedBox(height: 30),
                changeInfo()
              ],
            )
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

  Widget changeInfo() {
    return Column(
      children: [
        editProfileName()
      ],
    );
  }

  Widget editProfileName() {
    return TextFormField(
      initialValue: "Max Mustermann",
    );
  }

}