import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/env.dart';
import 'dart:convert';
import 'package:flutter_project/SecondPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
        routes: {
    '/second': (context) => SecondPage()
    },
        home: MyHomePage(title: 'Projet flutter'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController where = new TextEditingController();
  TextEditingController what = new TextEditingController();
  List<TextEditingController> _controllers = new List();
  GlobalKey<FormState> _formKey  = GlobalKey<FormState>();

  String Recherche = "";
  String lieu = "";
  bool done = false;

  void inputSearch() {
    print(Recherche);
    lieu =where.text;
    print(lieu);
    QueryApi(lieu,Recherche);
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [
      TextFormField(
        controller: where,
        validator: (value) {
          if (value.isEmpty) {
            return 'Veuillez entrer du texte';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "Location",
            hintText: "Choisissez la localisation souhaitée"
        ),
      ),
      TextFormField(
        controller: what,
        validator: (value) {
          if (value.isEmpty) {
            return 'Veuillez entrer du texte';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "Recherche",
            hintText: "Que souhaitez-vous trouver?"
        ),
      ),
      RaisedButton(
        child: Container(
            child: Text("Rechercher")
        ),
        onPressed: (){
          if (_formKey.currentState.validate()){
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              done = true;
            });
          }
        },
      ),
    ];

    Expanded contain = new Expanded(
        child: FutureBuilder(
            future: QueryApi(where.text, what.text),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError) {
                  try{
                    SnackBar snack = new SnackBar(
                      content: Text('An erroné occured'),
                    );
                    Scaffold.of(context).showSnackBar(snack);
                  } catch( error ){
                    //do nothing
                  }
                  return Container();
                } else
                if(snapshot.error == null){
                  return Container(
                    color: Colors.grey[300],
                    child: _ResultRecherche(snapshot.data['venues']),
                  );
                } else if(snapshot.data['meta']['code'] == 400){
                  try{
                    SnackBar snack = new SnackBar(
                      content: Text('Cette ville n existe pas dans la base '),
                    );
                    Scaffold.of(context).showSnackBar(snack);
                  } catch( error ){
                    //do nothing
                  }
                  return Container();
                }
              } else
                return Scaffold(
                    appBar: null,
                    body: Container(
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new CircularProgressIndicator(),
                                Text("Waiting")
                              ]
                          )
                      ),
                    )
                );
            }
        )
    );

    if(done){
      widgets.add(contain);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              children: widgets,
            ),
          )
      ),
    );
  }


  static Future<Map<String, dynamic>> QueryApi(String dest, String search) async {
    String Query = "https://api.foursquare.com/v2/venues/search?client_id=$client&client_secret=$Secret"
        + "&near=$dest"
        + "&query=$search"
        + "&v=20200511";
    final Response = await http.get(Query);
    return json.decode(Response.body)['response'];
  }

  static Widget _ResultRecherche(List json) {
    {
        return ListView.builder(
          itemCount: json.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    '/second', arguments: json[index]);
              },
              child: new Card(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: <Widget>[

                      Image(

                          image: NetworkImage(
                              '${json[index]['name']}')),
                      Text(json[index]['name']),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        }
  }
}



