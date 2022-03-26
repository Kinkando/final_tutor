import 'package:final_tutor/models/food.dart';
import 'package:final_tutor/services/api.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Food>> _futureFood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter food"),
      ),
      body: _buildFutureBuilder(),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureFood = _fetchFood();
  }

  Future<List<Food>> _fetchFood() async {
    List list = await Api().fetch('foods');
    return list.map((item) => Food.fromJson(item)).toList();
  }

  FutureBuilder<List<Food>> _buildFutureBuilder() {
    return FutureBuilder<List<Food>>(
      future: _futureFood,
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasData) {
          var foodList = snapshot.data;

          return ListView.builder(
            itemCount: foodList!.length,
            itemBuilder: (BuildContext context, int index) {
              var food = foodList[index];

              return Card(
                child: InkWell(
                  onTap: (){
                    
                  },
                  child: Row(
                    children: [
                      Image.network(food.image, height: 80.0, fit: BoxFit.cover),
                      Column(
                        children: [
                          Text(food.name),
                          Text('ราคา ${food.price} บาท')
                        ],
                      )
                    ],
                  )
                )
              );
            }
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureFood = _fetchFood();
                    });
                  },
                  child: const Text('ลองใหม่'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      }
    );
  }
}
