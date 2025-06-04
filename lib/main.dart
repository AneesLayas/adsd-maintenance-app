import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADSD Maintenance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2c3e50),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2c3e50),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADSD Maintenance'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build,
              size: 100,
              color: Color(0xFF2c3e50),
            ),
            SizedBox(height: 20),
            Text(
              'ADSD Maintenance App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2c3e50),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Offline Maintenance Reports',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.offline_bolt, color: Colors.green),
                      title: Text('Offline First'),
                      subtitle: Text('Work without internet connection'),
                    ),
                    ListTile(
                      leading: Icon(Icons.sync, color: Colors.blue),
                      title: Text('Auto Sync'),
                      subtitle: Text('Sync when connection is available'),
                    ),
                    ListTile(
                      leading: Icon(Icons.storage, color: Colors.orange),
                      title: Text('Local Storage'),
                      subtitle: Text('All data stored locally'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App is ready for development!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: const Color(0xFF2c3e50),
        child: const Icon(Icons.add),
      ),
    );
  }
} 