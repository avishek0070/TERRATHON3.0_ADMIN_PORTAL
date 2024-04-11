import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Student'),
        ),
        body: StudentForm(),
      ),
    );
  }
}

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _collegeIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _srnController = TextEditingController();
  final _teamNameController = TextEditingController();
  bool _checkIn = false;
  bool _snacks = false;
  bool _dinner = false;

  bool _snacks2 = false;
  bool _breakfast = false;
  bool _lunch = false;
  bool _snacks3 = false;

  @override
  void initState() {
    super.initState();
    _collegeIdController.addListener(_updateSRNFromCollegeId);
  }

  void _updateSRNFromCollegeId() {
    setState(() {
      _srnController.text = _collegeIdController.text;
    });
  }

  @override
  void dispose() {
    _collegeIdController.removeListener(_updateSRNFromCollegeId);
    _collegeIdController.dispose();
    _nameController.dispose();
    _srnController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  Future<void> addStudent(
      String collegeId,
      String name,
      String srn,
      String teamName,
      bool checkIn,
      bool snacks,
      bool dinner,
      bool snacks2,
      bool breakfast,
      bool lunch,
      bool snacks3) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(collegeId.toUpperCase())
          .set({
        'name': name.toUpperCase(),
        'srn': srn.toUpperCase(),
        'teamName': teamName.toUpperCase(),
        'checkIn': checkIn,
        'snacks': snacks,
        'dinner': dinner,
        'snacks2': snacks2,
        'breakfast': breakfast,
        'lunch': lunch,
        'checkout': snacks3,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Student ${name.toUpperCase()} added successfully')),
      );
      _collegeIdController.clear();
      _nameController.clear();
      _srnController.clear();
      _teamNameController.clear();
      setState(() {
        _checkIn = false;
        _snacks = false;
        _dinner = false;
        _snacks2 = false;
        _breakfast = false;
        _lunch = false;
        _snacks3 = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add student: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // To ensure the form is scrollable when the keyboard is visible
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _collegeIdController,
                decoration: const InputDecoration(labelText: 'College ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a college ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _srnController,
                decoration: const InputDecoration(labelText: 'SRN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an SRN';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Check-in'),
                value: _checkIn,
                onChanged: (bool value) {
                  setState(() {
                    _checkIn = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Snacks 1'),
                value: _snacks,
                onChanged: (bool value) {
                  setState(() {
                    _snacks = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Dinner'),
                value: _dinner,
                onChanged: (bool value) {
                  setState(() {
                    _dinner = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Snacks 2'),
                value: _snacks2,
                onChanged: (bool value) {
                  setState(() {
                    _snacks2 = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Breakfast'),
                value: _breakfast,
                onChanged: (bool value) {
                  setState(() {
                    _breakfast = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Lunch'),
                value: _lunch,
                onChanged: (bool value) {
                  setState(() {
                    _lunch = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('checkout'),
                value: _snacks3,
                onChanged: (bool value) {
                  setState(() {
                    _snacks3 = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addStudent(
                          _collegeIdController.text,
                          _nameController.text,
                          _srnController.text,
                          _teamNameController.text,
                          _checkIn,
                          _snacks,
                          _dinner,
                          _snacks2,
                          _breakfast,
                          _lunch,
                          _snacks3);
                    }
                  },
                  child: const Text('Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Inside _StudentFormState class
