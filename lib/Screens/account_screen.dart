import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Rounak",
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                child: Center(
                  child: CircleAvatar(
                    child: Icon(
                      Icons.person,

                    ),
                  ),
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
