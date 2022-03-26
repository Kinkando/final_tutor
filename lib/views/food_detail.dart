import 'package:final_tutor/models/food.dart';
import 'package:final_tutor/services/api.dart';
import 'package:flutter/material.dart';

class FoodDetail extends StatefulWidget {
  const FoodDetail({Key? key}) : super(key: key);

  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  int index = 0;
  List<Food>? _foodList;
  bool loading = true;

  List<String> option = ['ธรรมดา', 'พิเศษ', 'ใส่ไข่', "ไม่เอาผัก"];

  @override
  void initState() {
    super.initState();
    _fetchFood();
  }

  void _fetchFood() async {
    List list = await Api().fetch('foods');
    setState(() {
      _foodList = list.map((item) => Food.fromJson(item)).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _foodList != null ? Text(_foodList![index].name) : const Text(''),
      ),
      body: Stack(
        children: [
          _buildFood(),
          _buildPagination()
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return _foodList != null ? Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _previous(),
            Text('เมนู ${index+1}/${_foodList!.length}'),
            _next(),
          ],
        ),
      ),
    ) : const SizedBox.shrink();
  }

  void _handleClickButton(int page) {
    setState(() {
      index += page;
    });
  }

  Widget _previous() {
    return index > 0 ? Container(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: () => _handleClickButton(-1),
        label: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('ก่อนหน้า'),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_left,
          color: Colors.white,
        ),
      ),
    ) : const SizedBox(width: 150.0, height: 10.0,);
  }

  Widget _next() {
    return index < _foodList!.length-1 ? Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 150.0,
        child: ElevatedButton.icon(
          onPressed: () => _handleClickButton(1),
          label: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('ถัดไป'),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
        ),
      ),
    ) : Container(
      width: 150.0,
      child: ElevatedButton(
        onPressed: (){},
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Submit'),
        ),
      ),
    );
  }

  Widget _buildFood() {
    return loading ? const Center(child: CircularProgressIndicator())
    : _foodList != null
      ? ListView(
          children: [
            _buildFoodDetail(_foodList![index]),
            const SizedBox(height: 65.0, width: 10.0),
          ],
        ) : _buildTryAgainButton();
  }

  Center _buildTryAgainButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('ผิดพลาด'),
          ElevatedButton(
            onPressed: () => _fetchFood(),
            child: const Text('ลองใหม่'),
          ),
        ],
      ),
    );
  }

  Column _buildFoodDetail(Food food) {
    return Column(
      children: [
        Image.network(food.image, fit: BoxFit.cover),
        Center(child: Text(food.name)),
        Center(child: Text('${food.price} บาท')),
        for(int i=0; i<option.length; i+=2)
          _buildRadioOption(i),
      ],
    );
  }

  Widget _buildRadioOption(int optionIndex) {
    return Row(
      children: [
        for(int i=optionIndex; i<optionIndex+2; i++)
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: option[i],
                  groupValue: _foodList![index].option,
                  onChanged: (value){
                    setState(() {
                      _foodList![index].option = value.toString();
                    });
                  },
                ),
                Text(option[i]),
              ],
            ),
          ),
      ],
    );
  }
}
