import 'package:example/processable_state.dart';
import 'package:example/processable_widget_demo.dart';
import 'package:flutter/material.dart';
import 'example_state.dart';

import 'package:nexus/nexus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final state = ExampleState();
  final processableState = ProcessableState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text(state.counter.toString())],
              ),
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text(state.counter.toString())],
                );
              },
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...state.intList.map((element) => Text(element.toString()))
                  ]
                );
              },
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...state.stringList.map((element) => Text(element.toString()))
                  ]
                );
              },
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("John age: ${state.map['John']?['age']}"),
                        Text("John weight: ${state.map['John']?['weight']}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jim age: ${state.map['Jim']?['age']}"),
                        Text("Jim weight: ${state.map['Jim']?['weight']}"),
                      ],
                    ),
                  ]
                );
              },
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${state.fullName}")
                    ]
                );
              },
            ),
            NexusBuilder(
              controller: state,
              builder: (BuildContext context) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Reactive user: ${state.reactiveUser.name} - ${state.reactiveUser.weight}")
                    ]
                );
              },
            ),
            ProcessableWidgetDemo(controller: processableState)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () => state.increment(4),
        child: Icon(Icons.add),
      ),
    );
  }
}