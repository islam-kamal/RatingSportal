import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reviewers/UI/ComplainOrReview.dart';
import 'package:reviewers/UI/Doctors.dart';

class Departments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DepartmentsState();
  }
}

class _DepartmentsState extends State<Departments> {
  final data = [
    ['images/hr.png', 'HR '],
    ['images/selling.png', 'selling'],
    ['images/callcenter.png', 'Call Center'],
    ['images/responist.png', 'Receptionist'],
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          padding: EdgeInsets.only(top: 10.0),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: Card(
              margin: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      // use to make all cells of grid view in same size
                      aspectRatio: 18.0 / 13.0,
                      child: Image(
                        image: AssetImage(data[index][0]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index][1], textAlign: TextAlign.center),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ComplainOrReview()));
            },
          ),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        ),

      ),
    );
  }
}
