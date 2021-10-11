import 'package:bloc_flutter/easy_refresh.dart';
import 'package:flutter/material.dart';

class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh"),
      ),
      body: EasyRefresh.custom(
        onRefresh: () async {},
        slivers: [
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Text(
                "列表项 $index",
                style: TextStyle(
                  fontSize: 20,
                ),
              );
            }, childCount: 10),
          ),
        ],
      ),
    );
  }
}
