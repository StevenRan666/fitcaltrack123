import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'add_food.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> dietRecords = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Snacks': 0,
  };
  int totalKcal = 2102;
  int exerciseGoal = 450;
  int exerciseBurned = 343;

  @override
  void initState() {
    super.initState();
    _loadDietRecords();
  }

  Future<void> _loadDietRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dietRecords['Breakfast'] = prefs.getInt('Breakfast') ?? 0;
      dietRecords['Lunch'] = prefs.getInt('Lunch') ?? 0;
      dietRecords['Dinner'] = prefs.getInt('Dinner') ?? 0;
      dietRecords['Snacks'] = prefs.getInt('Snacks') ?? 0;
    });
  }

  Future<void> _updateKcal(String mealType, int kcal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dietRecords[mealType] = kcal;
    });
    await prefs.setInt(mealType, kcal);
  }

  int _calculateRemainingKcal() {
    int consumedKcal = dietRecords.values.reduce((a, b) => a + b);
    return totalKcal - consumedKcal;
  }

  int _calculateTotalIntake() {
    return dietRecords.values.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    int remainingKcal = _calculateRemainingKcal();
    double percentDiet = (totalKcal - remainingKcal) / totalKcal;
    double percentExercise = exerciseBurned / exerciseGoal;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Good Morning!\nBryant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Diet Records',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: percentDiet > 1.0 ? 1.0 : percentDiet,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${remainingKcal} Kcal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Remaining',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Total 2102 Kcal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue,
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildDietRecordItem(context, 'Breakfast', 'Recommend 447-626 Kcal', dietRecords['Breakfast']!),
                  _buildDietRecordItem(context, 'Lunch', 'Recommend 626-805 Kcal', dietRecords['Lunch']!),
                  _buildDietRecordItem(context, 'Dinner', 'Recommend 447-626 Kcal', dietRecords['Dinner']!),
                  _buildDietRecordItem(context, 'Snacks', 'Recommend 0-179 Kcal', dietRecords['Snacks']!),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 400,
              width: 400,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Exercise Records',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: percentExercise > 1.0 ? 1.0 : percentExercise,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${exerciseGoal - exerciseBurned} Kcal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Goal 450 Kcal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Burned: $exerciseBurned Kcal',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Time: 45 mins',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Steps Taken: 10,303',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Feature under construction')),
                      );
                    },
                    child: Text('Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietRecordItem(BuildContext context, String mealType, String recommendation, int calories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealType,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                recommendation,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$calories Kcal',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color.fromARGB(200, 4, 129, 132)),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFoodScreen(mealType: mealType)),
                  );
                  if (result != null) {
                    _updateKcal(mealType, dietRecords[mealType]! + (result as int));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
