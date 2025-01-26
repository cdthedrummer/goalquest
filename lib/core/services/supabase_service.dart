import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Quiz Results
  Future<void> saveQuizResults({
    required int strength,
    required int dexterity,
    required int constitution,
    required int intelligence,
    required int wisdom,
    required int charisma,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase.from('quiz_results').insert({
      'user_id': user.id,
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
    });
  }

  // Goals
  Future<List<Map<String, dynamic>>> getUserGoals() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('goals')
        .select()
        .eq('user_id', user.id)
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createGoal({
    required String title,
    required String description,
    required String category,
    required int difficulty,
    String? targetValue,
    DateTime? targetDate,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase.from('goals').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'target_value': targetValue,
      'target_date': targetDate?.toIso8601String(),
    });
  }

  Future<void> updateGoalProgress({
    required String goalId,
    required double newValue,
    String? notes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Get current value
    final goal = await _supabase
        .from('goals')
        .select('current_value')
        .eq('id', goalId)
        .single();

    // Start a transaction
    await _supabase.rpc('update_goal_progress', params: {
      'p_goal_id': goalId,
      'p_previous_value': goal['current_value'],
      'p_new_value': newValue,
      'p_notes': notes,
    });
  }
}