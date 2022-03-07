import 'package:flutter/material.dart';

class DesignSelect extends StatefulWidget {
  const DesignSelect({Key? key}) : super(key: key);

  @override
  _DesignSelectState createState() => _DesignSelectState();
}

class _DesignSelectState extends State<DesignSelect> {
  bool border1 = false;
  bool border2 = false;
  bool border3 = false;
  bool border4 = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  border1 == false
                      ? () {
                          border1 = true;
                          border2 = false;
                          border3 = false;
                          border4 = false;
                        }()
                      : border1 = false;
                });
              },
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: border1
                      ? const BorderSide(width: 5, color: Colors.green)
                      : BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.primary),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: cardText(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  border2 == false
                      ? () {
                          border2 = true;
                          border1 = false;
                          border3 = false;
                          border4 = false;
                        }()
                      : border2 = false;
                });
              },
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: border2
                      ? const BorderSide(width: 5, color: Colors.green)
                      : BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.primary),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: cardText(),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  border3 == false
                      ? () {
                          border3 = true;
                          border1 = false;
                          border2 = false;
                          border4 = false;
                        }()
                      : border3 = false;
                });
              },
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: border3
                      ? const BorderSide(width: 5, color: Colors.green)
                      : BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.primary),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: cardText(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  border4 == false
                      ? () {
                          border4 = true;
                          border1 = false;
                          border2 = false;
                          border3 = false;
                        }()
                      : border4 = false;
                });
              },
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: border4
                      ? const BorderSide(width: 5, color: Colors.green)
                      : BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.primary),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: cardText(),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget cardText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Reisetitel',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
    );
  }
}
