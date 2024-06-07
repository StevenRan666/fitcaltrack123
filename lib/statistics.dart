import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Random _random = Random();

  double _weightGoalProgress = 0.0;
  int _currentWeight = 180;
  int _goalWeight = 160;

  Map<String, int> _dietRecords = {
    'Kcal': 170,
    'Carbs': 170,
    'Proteins': 170,
    'Fats': 70,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentWeight = prefs.getInt('currentWeight') ?? 180;
      _goalWeight = prefs.getInt('goalWeight') ?? 160;
      _dietRecords['Kcal'] = prefs.getInt('Kcal') ?? 170;
      _dietRecords['Carbs'] = prefs.getInt('Carbs') ?? 170;
      _dietRecords['Proteins'] = prefs.getInt('Proteins') ?? 170;
      _dietRecords['Fats'] = prefs.getInt('Fats') ?? 70;
      _updateWeightGoalProgress();
    });
  }

  void _updateWeightGoalProgress() {
    setState(() {
      _weightGoalProgress = (_currentWeight - _goalWeight).abs() / (_goalWeight - 180).abs();
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _currentWeight = _random.nextInt(21) + 160; // 随机生成 160 到 180 之间的体重
      _dietRecords['Kcal'] = _random.nextInt(61) + 170; // 随机生成 170 到 230 之间的 Kcal
      _dietRecords['Carbs'] = _random.nextInt(61) + 170;
      _dietRecords['Proteins'] = _random.nextInt(61) + 170;
      _dietRecords['Fats'] = _random.nextInt(61) + 70;
      _updateWeightGoalProgress();
      _saveData();
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentWeight', _currentWeight);
    await prefs.setInt('goalWeight', _goalWeight);
    await prefs.setInt('Kcal', _dietRecords['Kcal']!);
    await prefs.setInt('Carbs', _dietRecords['Carbs']!);
    await prefs.setInt('Proteins', _dietRecords['Proteins']!);
    await prefs.setInt('Fats', _dietRecords['Fats']!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight Goal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('${_currentWeight} Pounds'),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: _weightGoalProgress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 5),
                    Text('${_goalWeight} Pounds'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diet Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDietRecordItem('Kcal', _dietRecords['Kcal']!, 230),
                    _buildDietRecordItem('Carbs', _dietRecords['Carbs']!, 230),
                    _buildDietRecordItem('Proteins', _dietRecords['Proteins']!, 230),
                    _buildDietRecordItem('Fats', _dietRecords['Fats']!, 130),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietRecordItem(String nutrient, int consumed, int goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$nutrient',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '$consumed/$goal',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
