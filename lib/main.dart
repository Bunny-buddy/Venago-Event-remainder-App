import 'dart:html';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey:"AIzaSyBnfFhsRa4sUvGladZnxV7DnSHpzZTHjzo",
        projectId:"submit-3ee0c",
        appId: "101981676505",
        messagingSenderId:"1:101981676505:android:4264910f90cf2f8f75efc8",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                  await _auth.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  print('User logged in: ${userCredential.user?.email}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderApp()),
                  );
                } on FirebaseAuthException catch (e) {
                  print('Login Error: $e');
                  showSnackBar(
                      context, 'Login failed. ${getFirebaseAuthErrorMessage(e)}');
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                  await _auth.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  print('User registered: ${userCredential.user?.email}');
                  // You can automatically log in the user here or redirect to the login screen.
                } on FirebaseAuthException catch (e) {
                  print('Registration Error: $e');
                  showSnackBar(context,
                      'Registration failed. ${getFirebaseAuthErrorMessage(e)}');
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'An error occurred while processing your request.';
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}

class ReminderApp extends StatefulWidget {
  @override
  _ReminderAppState createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Event> eventsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 1000.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_auth.currentUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetEventScreen(
                                eventsList: eventsList,
                                currentUserUID: _auth.currentUser?.uid ?? "",
                              ),
                            ),
                          );
                        } else {
                          print('User not logged in. Redirect to login screen.');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                      },
                      child: Text(
                        'Get Event',
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 1000.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateEventScreen(
                              onSave: (event) {
                                setState(() {
                                  eventsList.add(event);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Create Event',
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 200.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                print('User logged out.');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                side: BorderSide.none,
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GetEventScreen extends StatefulWidget {
  final List<Event> eventsList;
  final String currentUserUID;

  GetEventScreen({required this.eventsList, required this.currentUserUID});

  @override
  _GetEventScreenState createState() => _GetEventScreenState();
}

class _GetEventScreenState extends State<GetEventScreen> {
  DateTime? selectedDate;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL: "https://submit-3ee0c-default-rtdb.firebaseio.com/",
  ).reference().child('events');

  void _deleteEvent(String? eventKey) {
    if (eventKey != null) {
      _databaseReference.child(eventKey).remove();
      setState(() {
        widget.eventsList.removeWhere((event) => event.eventKey == eventKey);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _databaseReference.onChildAdded.listen((event) {
      Map<dynamic, dynamic>? eventData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (eventData != null) {
        Event newEvent = Event(
          description: eventData['description'],
          dateTime: DateTime.fromMillisecondsSinceEpoch(eventData['timestamp']),
          createdBy: eventData['createdBy'],
          eventKey: event.snapshot.key,
        );

        if (newEvent.createdBy == widget.currentUserUID &&
            !widget.eventsList.any((event) => event.eventKey == newEvent.eventKey)) {
          setState(() {
            widget.eventsList.add(newEvent);
          });
        }
      }
    });
  }


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Allow selecting dates from any time in the past
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Check if there are events for the selected date
      bool eventsFound = widget.eventsList.any((event) =>
      event.dateTime.year == picked.year &&
          event.dateTime.month == picked.month &&
          event.dateTime.day == picked.day);

      if (!eventsFound) {
        // Show "No Data Found" popup message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Data Found'),
              content: Text('No events found for the selected date.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }



  void _editEvent(Event event) {
    print('Edit event: ${event.description}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Event'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Select Date',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.eventsList.length,
              itemBuilder: (context, index) {
                final event = widget.eventsList[index];

                if (selectedDate != null &&
                    event.dateTime.year == selectedDate!.year &&
                    event.dateTime.month == selectedDate!.month &&
                    event.dateTime.day == selectedDate!.day) {
                  return ListTile(
                    title: Text(event.description),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(event.dateTime),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(event.eventKey),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateEventScreen extends StatefulWidget {
  final Function(Event) onSave;

  CreateEventScreen({required this.onSave});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL: "https://submit-3ee0c-default-rtdb.firebaseio.com/",
  ).reference().child('events');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveEventToFirebase(Event event) {
    if (event.description.trim().isEmpty) {
      _showErrorDialog('Enter event description.');
      return;
    }

    int timestamp = event.dateTime.millisecondsSinceEpoch;

    Map<String, dynamic> eventData = {
      'description': event.description,
      'timestamp': timestamp,
      'createdBy': FirebaseAuth.instance.currentUser?.uid,
    };

    DatabaseReference newEventRef = _databaseReference.push();
    newEventRef.set(eventData);

    event = event.copyWith(eventKey: newEventRef.key!);
    widget.onSave(event);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Event saved successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ),
                Container(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              width: 200.0,
              height: 100.0,
              child: ElevatedButton(
                onPressed: () {
                  final event = Event(
                    description: descriptionController.text,
                    dateTime: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
                  );
                  _saveEventToFirebase(event);
                },
                child: Text('Save Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Event {
  final String description;
  final DateTime dateTime;
  final String createdBy;
  final String? eventKey;

  Event({
    required this.description,
    required this.dateTime,
    required this.createdBy,
    this.eventKey,
  });

  Event copyWith({
    String? description,
    DateTime? dateTime,
    String? createdBy,
    String? eventKey,
  }) {
    return Event(
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      createdBy: createdBy ?? this.createdBy,
      eventKey: eventKey ?? this.eventKey,
    );
  }
}

