import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'session.dart';
import '/model/customerFetch.dart';



class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Session session = new Session();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Please sign in to continue',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              SizedBox(height: 32.0),
              _buildTextField(Icons.email, 'Email', false, _emailController),
              SizedBox(height: 16.0),
              _buildTextField(Icons.lock, 'Password', true, _passwordController),
              SizedBox(height: 32.0),
              _buildLoginButton(context),
              SizedBox(height: 16.0),
              _buildSignUpText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText, bool isPassword, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _login(context,_emailController.text,_passwordController.text);
          print("tes");
        },
        child: Text('Login'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context,email, password) async {
  // final email = _emailController.text;
  // final password = _passwordController.text;
  //print("tes error");

  try {
    
    http.Response response = await http.post(
      Uri.parse("https://reqres.in/api/login"),
      body: {'email': email, 'password': password},
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['token']);
      print("Login successful");
      session.saveSession('email');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerCardScreen()),
      );
    } else {
      final data = jsonDecode(response.body);
      final errorMessage = data['error'];
      print("Login failed: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    print("Exception: $e");
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error $e")),
    );
  }
}


  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            // Handle sign up navigation
          },
          child: Text('Sign Up'),
        ),
      ],
    );
  }
}
