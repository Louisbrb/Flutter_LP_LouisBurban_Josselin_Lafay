import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    Map args = ModalRoute.of(context).settings.arguments;
    List<Widget> elements = new List<Widget>();


    return Scaffold(
      appBar: AppBar(
        title: Text(args['name']),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
               Row(
                children: <Widget>[
                  Text('Nom : ' + args['name']+'\n')
                ]
                ),
                Row(
                    children: <Widget>[
                      Text('Adresse : ' + args['location']['address'] + '\n'),
                    ]
                ),
            Row(
                children: <Widget>[
                  Text('Code postal : ' + args['location']['postalCode'] + '\n'),
                ]

            ),
            Row(
                children: <Widget>[
                  Text('Ville : ' + args['location']['city'] + '\n'),
                ]

            ),

          ],
        ),
      ),
    );
  }

}

