import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://rorsqdqrcnkaefbvddqg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJvcnNxZHFyY25rYWVmYnZkZHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MTIyMDksImV4cCI6MjA1MzQ4ODIwOX0.88ffYWPy_wCDOHrrTjuqgm97jtWEYPTJFlil0fAjB0I',
  );

  runApp(
    const ProviderScope(
      child: GoalQuestApp(),
    ),
  );
}