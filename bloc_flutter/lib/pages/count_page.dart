import 'package:bloc_flutter/pages/count_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountPage extends StatelessWidget {
  CountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                context.bloc<CountPageBloc>().add(CountPageMinusEvent());
              },
              child: Text("Test"),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CountPageBloc, int>(
              buildWhen: (int previous, int current) {
                return previous != current;
              },
              builder: (context, state) {
                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            BlocBuilder<CountPageBloc, int>(
              buildWhen: (int previous, int current) {
                return previous != current;
              },
              builder: (context, state) {
                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
            BlocListener<CountPageBloc, int>(
              listener: (BuildContext context, int state) {
                if (state == 10) {
                  // Make Toast
                }
              },
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.bloc<CountPageBloc>().add(CountPageAddEvent());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
