import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            width: 300.0,
            height: 400.0,
            color: Colors.white, // Set background color to white
            child: WhiteContainer(
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  final Widget child;

  const WhiteContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyTextField(label: 'Username'),
        SizedBox(height: 20.0),
        MyPasswordField(
          label: 'Password',
          isPasswordVisible: _isPasswordVisible,
          togglePasswordVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        SizedBox(height: 20.0),
        MyLoginButton(
          onPressed: () => _handleLogin(context),
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () {
            // Add your "Forgot Password" logic here
            print('Forgot Password pressed');
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        MyCreateAccountButton(
          onPressed: () => _navigateToCreateAccount(context),
        ),
        SizedBox(height: 10.0),
        Text(
          'Additional Information',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  void _handleLogin(BuildContext context) {
    // Add your login logic here
    print('Login button pressed');
    // Navigate to the 'Venago' page on successful login
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VenagoPage()),
    );
  }

  void _navigateToCreateAccount(BuildContext context) {
    // Add your logic to navigate to the 'CreateAccount' page
    print('Create Account button pressed');
  }
}

class MyTextField extends StatelessWidget {
  final String label;

  const MyTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class MyPasswordField extends StatelessWidget {
  final String label;
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;

  const MyPasswordField({
    required this.label,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: TextField(
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: togglePasswordVisibility,
          ),
        ),
      ),
    );
  }
}

class MyLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text('Log in'),
      ),
    );
  }
}

class MyCreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyCreateAccountButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text('Create a New Account'),
      ),
    );
  }
}

class VenagoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venago Page'),
      ),
      body: Center(
        child: Text('Welcome to Venago Page!'),
      ),
    );
  }
}
