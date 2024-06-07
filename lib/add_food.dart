import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  final String mealType;

  AddFoodScreen({required this.mealType});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final List<TextEditingController> _kcalControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewEntry();
  }

  void _addNewEntry() {
    setState(() {
      _kcalControllers.add(TextEditingController());
    });
  }

  Widget _buildFoodEntry(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter Food Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Calories',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _kcalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._kcalControllers.map((controller) => _buildFoodEntry(controller)).toList(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _addNewEntry,
                    child: Text('Add More'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int totalKcal = _kcalControllers.fold(0, (sum, controller) {
                    return sum + (int.tryParse(controller.text) ?? 0);
                  });
                  Navigator.pop(context, totalKcal);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
