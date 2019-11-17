import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    Map args = ModalRoute.of(context).settings.arguments;
    List<Widget> elements = new List<Widget>();

    for(var tmp in args['venue']['location']['formattedAddress']){
      elements.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(tmp),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args['venue']['name']),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            args['venue']['location']['address']!=null?Card(
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.blue,
                    onPressed: (){},
                    icon: Icon(Icons.room),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: elements,
                  )
                ],
              ),
            ):Text('Pas d adresse valide'),
          ],
        ),
      ),
    );
  }

}

