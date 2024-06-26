import 'package:crimson/Homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSummaryApp extends StatelessWidget {
  final String userId;

  const ProfileSummaryApp({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Summary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 24, 24, 24),
      ),
      home:
          ProfileSummaryScreen(userId: userId), // Pass the actual user ID here
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileSummaryScreen extends StatelessWidget {
  final String userId;

  const ProfileSummaryScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        userId: userId,
                      )),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text(
          'Profile summary',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error loading profile',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'No profile found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileCard(
                    Icons.person,
                    "Full Name",
                    userData['full_name'] ?? '',
                  ),
                  buildProfileCard(
                    Icons.email,
                    "Email",
                    userData['email_address'] ?? '',
                  ),
                  buildProfileCard(
                    Icons.phone,
                    "Phone Number",
                    userData['phone_number'] ?? '',
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'images/logo.jpg',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'CRIMSON +',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileCard(IconData icon, String title, String detail) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
