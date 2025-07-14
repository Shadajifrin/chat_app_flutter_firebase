import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app_flutter_firebase/screens/login.dart';
import 'package:chat_app_flutter_firebase/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key? key}) : super(key: key);

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _authService = AuthService(); // ✅

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _gender;
  DateTime? _dob;

  XFile? _profileImage;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = imageBytes;
          _profileImage = pickedFile;
        });
      } else {
        setState(() {
          _profileImage = pickedFile;
        });
      }
    } else {
      _showSnackBar("No image selected");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        _gender == null ||
        _dob == null) {
      _showSnackBar("Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signupUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      gender: _gender!,
      dob: _dob!,
      profileImage: _profileImage,
      webImage: _webImage,
    );

    setState(() => _isLoading = false);

    if (error == null) {
      _showSnackBar("Signup successful!");
      Navigator.pop(context);
    } else {
      _showSnackBar("Error: $error");
    }
  }

  Future<void> _pickDateOfBirth() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _profileImage != null
                      ? (kIsWeb
                              ? MemoryImage(_webImage!)
                              : FileImage(File(_profileImage!.path)))
                          as ImageProvider
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(_nameController, 'Full Name', Icons.person),
              const SizedBox(height: 20),
              _buildTextField(_emailController, 'Email Address', Icons.email),
              const SizedBox(height: 20),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _gender,
                hint: const Text('Select Gender'),
                onChanged: (newValue) => setState(() => _gender = newValue),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickDateOfBirth,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: double.infinity,
                  child: Text(
                    _dob != null
                        ? 'DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}'
                        : 'Select Date of Birth',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 15),
              Text.rich(
                TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(color: Colors.grey[600]),
                  children: [
                    TextSpan(
                      text: ' Login',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color:Colors.teal),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}
