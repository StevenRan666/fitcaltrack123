import 'package:flutter/material.dart';
import 'user_info.dart';

class PersonalScreen extends StatefulWidget {
  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String _name = "Bryant";
  int _currentWeight = 150;
  int _targetWeight = 120;
  int _age = 22;
  int _height = 180;
  bool _isDarkMode = false;

  void _updateUserInfo(Map<String, dynamic> newInfo) {
    setState(() {
      _name = newInfo['name'];
      _currentWeight = newInfo['currentWeight'];
      _targetWeight = newInfo['targetWeight'];
      _age = newInfo['age'];
      _height = newInfo['height'];
    });
  }

  void _showUnderConstructionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feature under construction')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with the actual image URL
              ),
              SizedBox(height: 20),
              Text(
                _name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Weight',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '$_currentWeight',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '$_age',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        'Height',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '$_height',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildSettingsSection('General Settings', [
                _buildSettingsItem(context, Icons.person, 'User Info', () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen(
                        name: _name,
                        currentWeight: _currentWeight,
                        targetWeight: _targetWeight,
                        age: _age,
                        height: _height,
                      ),
                    ),
                  );
                  if (result != null) {
                    _updateUserInfo(result);
                  }
                }),
                _buildSettingsItem(context, Icons.settings, 'Preferences', () {
                  _showUnderConstructionMessage(context);
                }),
              ]),
              SizedBox(height: 20),
              _buildSettingsSection('Accessibility', [
                _buildSettingsItem(context, Icons.language, 'Languages', () {
                  _showUnderConstructionMessage(context);
                }),
                _buildSettingsItem(context, Icons.dark_mode, 'Dark Mode', () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                }, trailing: Switch(value: _isDarkMode, onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                })),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
        SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {Widget? trailing}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
