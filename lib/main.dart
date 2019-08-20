import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage( ),
    );
  }
}
class MyHomePage extends StatefulWidget {

  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
  String cep;
  final _formKey = new GlobalKey<FormState>();
  var data;
  int status = 0;
  /*
  0 => inicial(vazio);
  1 => carregando;
  2 => ok;
  3 => erro;
  */

  void submit() async{

    if(_formKey.currentState.validate()){
      setState(() {
        status = 1;
      });
      _formKey.currentState.save();

      var response = await http.get('http://api.postmon.com.br/v1/cep/$cep');
      //var response = await http.get('http://api.postmon.com.br/v1/cep/' + cep);

      if(response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          status = 2;
        });
      }
        else
        setState(() {
          status = 3;
        });
      }
    }

    Widget responseWidget() => status == 0 ?
  SizedBox()
      : status == 1
      ? Center(
        child: CircularProgressIndicator(),
      )
      :status == 2
      ? Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.home),
            data['logradouro'] != null
             ? Text(data['logradoro'])
                :Text(data['cidade'])
          ],
        ),
      )
      : Center(
    child: Column(
      children: <Widget>[Icon( Icons.close ),
      Text('Erro no CEP'),],
    ),
  );


  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
        title: Text('CEPeador'),
        centerTitle: true,

      ),

      body: Column(
        children: <Widget>[
         Form(
           key: _formKey,
           child: Padding(
             padding: EdgeInsets.all(20),
             child: TextFormField(

               validator: (inputText){
                 if(inputText.isEmpty) return 'Digite algo';
                 if(inputText.length < 8) return 'Digite um cep valido';
                 return null;
               },

               onSaved: (inputText){
                 cep = inputText;
               },

               maxLength: 8,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                 border: OutlineInputBorder(), hintText: 'Digite o cep',
           ),
             ),
           ),
         ),
          Center(
            child: FlatButton(

                child: Text('Buscar'),
                onPressed: () => submit(),

            ),
          ),
          SizedBox(
        height: 50,
    ),
        responseWidget()
        ],
      ),
    );
  }
}

