import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  final String userId;

  MyProfileScreen({required this.userId});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, phone, gender, profileImage;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Male'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final user = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          name = user['name'] ?? '';
          email = user['email'] ?? '';
          phone = user['phone'] ?? '';
          gender = user['gender'] ?? '';
          profileImage =
              user['profileImage'] ?? 'https://via.placeholder.com/150';

          _nameController.text = name;
          _emailController.text = email;
          _phoneController.text = phone;
          _selectedGender =
              gender.isNotEmpty ? gender : 'Male'; // Default to 'Male' if empty

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  SizedBox(height: 16),
                  _buildProfileTextField(
                    _nameController,
                    'Full Name',
                    Icons.person,
                  ),
                  SizedBox(height: 8),
                  _buildProfileTextField(
                    _emailController,
                    'Email Address',
                    Icons.email,
                  ),
                  SizedBox(height: 8),
                  _buildProfileTextField(
                    _phoneController,
                    'Phone Number',
                    Icons.phone,
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        ['Male', 'Female', 'Other'].map((genderOption) {
                          return DropdownMenuItem(
                            value: genderOption,
                            child: Text(genderOption),
                          );
                        }).toList(),
                    onChanged:
                        _isEditing
                            ? (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            }
                            : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
              'name': _nameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'gender': _selectedGender,
              'profileImage': profileImage,
            });

        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        print("Error updating profile: $e");
      }
    }
  }
}
