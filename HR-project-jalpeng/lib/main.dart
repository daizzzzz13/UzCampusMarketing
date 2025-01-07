import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart'; // Login screen
import 'screens/register_screen.dart'; // Register screen
import 'screens/admin_home_screen.dart'; // Admin dashboard screen
import 'screens/employee_screen.dart'; // Employee screen
import 'screens/interview_screen.dart'; // Interview screen
import 'screens/job_listings_screen.dart'; // Job listings screen
import 'screens/job_list_screen.dart'; // Job list screen
import 'screens/forms_screen.dart'; // Forms screen
import 'screens/user_dashboard.dart';
import 'screens/joblist_user_screen.dart';
import 'package:dashboard/screens/requirements_user_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project URL and Anon Key
  await Supabase.initialize(
    url: 'https://xzcajqfiqnkfatfyhcgk.supabase.co', // Your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2FqcWZpcW5rZmF0ZnloY2drIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3NjgxMjcsImV4cCI6MjA1MTM0NDEyN30.Uj05jQH1UAF3hVHixIum3h9pmfSMx21UFi9kEBuu68U', // Your Supabase Anon Key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set the initial route to Login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin_dashboard': (context) => const AdminHomeScreen(),
        '/employees': (context) => const EmployeeScreen(),
        '/interview': (context) => const InterviewScreen(),
        '/jobs': (context) => const JobListingsScreen(),
        '/forms': (context) => const FormsScreen(),
        '/lists': (context) => const JobListScreen(),
        '/user_dashboard': (context) => const UserDashboard(),
        '/joblist_user_screen': (context) => const JobListUserScreen(),
        '/requirements_user_screen': (context) => const RequirementsScreen(),
        
        
      },
    );
  }
}
