import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  final String name;
  final int currentWeight;
  final int targetWeight;
  final int age;
  final int height;

  UserInfoScreen({
    required this.name,
    required this.currentWeight,
    required this.targetWeight,
    required this.age,
    required this.height,
  });

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _currentWeightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _currentWeightController = TextEditingController(text: widget.currentWeight.toString());
    _targetWeightController = TextEditingController(text: widget.targetWeight.toString());
    _ageController = TextEditingController(text: widget.age.toString());
    _heightController = TextEditingController(text: widget.height.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Name", _nameController),
            SizedBox(height: 20),
            _buildTextField("Current Weight", _currentWeightController, isNumber: true),
            SizedBox(height: 20),
            _buildTextField("Target Weight", _targetWeightController, isNumber: true),
            SizedBox(height: 20),
            _buildTextField("Age", _ageController, isNumber: true),
            SizedBox(height: 20),
            _buildTextField("Height(cm)", _heightController, isNumber: true),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'currentWeight': int.parse(_currentWeightController.text),
                    'targetWeight': int.parse(_targetWeightController.text),
                    'age': int.parse(_ageController.text),
                    'height': int.parse(_heightController.text),
                  });
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
