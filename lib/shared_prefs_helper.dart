import 'dart:convert';
import 'package:obatin/obat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'history_entry.dart';

class SharedPreferencesHelper {
  static const String _usersKey = 'users';
  static const String _loggedInUserKey = 'loggedInUser';
  static const String _privacyPolicyAgreedKey = 'privacyPolicyAgreed';

  // Save a new user to the list of users
  Future<bool> saveUser(User user) async {
    final users = await getUsers();

    // Check if user already exists
    if (users.any((u) => u.namaLansia == user.namaLansia)) {
      return false; // User already exists
    }

    users.add(user);
    await _saveUsers(users);
    return true;
  }

  // Get all registered users
  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersString = prefs.getString(_usersKey);
    if (usersString == null) {
      return [];
    }
    final List<dynamic> decodedUsers = jsonDecode(usersString);
    return decodedUsers.map((json) => User.fromMap(json)).toList();
  }

  // Authenticate user
  Future<User?> loginUser(String username, String password) async {
    final users = await getUsers();
    try {
      final user = users.firstWhere(
        (u) => u.namaLansia == username && u.password == password,
      );
      await saveLoggedInUser(user.namaLansia);
      return user;
    } catch (e) {
      return null; // User not found or password incorrect
    }
  }

  // Save the username of the currently logged-in user
  Future<void> saveLoggedInUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInUserKey, username);
  }

  // Get the currently logged-in user's data
  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString(_loggedInUserKey);
    if (username == null) {
      return null;
    }
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u.namaLansia == username);
    } catch (e) {
      return null; // Should not happen if loggedInUserKey is valid
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }

  // Add a medication to a user's list
  Future<void> addMedication(String username, Obat obat) async {
    final users = await getUsers();
    final userIndex = users.indexWhere((u) => u.namaLansia == username);
    if (userIndex != -1) {
      users[userIndex].medications.add(obat);
      await _saveUsers(users);
    }
  }

  // Get a user's medication list
  Future<List<Obat>> getMedications(String username) async {
    final user = await getLoggedInUser();
    return user?.medications ?? [];
  }

  // Add a history entry to a user's list
  Future<void> addHistoryEntry(String username, HistoryEntry entry) async {
    final users = await getUsers();
    final userIndex = users.indexWhere((u) => u.namaLansia == username);
    if (userIndex != -1) {
      users[userIndex].history.add(entry);
      await _saveUsers(users);
    }
  }

  // Get a user's history list
  Future<List<HistoryEntry>> getHistory(String username) async {
    final user = await getLoggedInUser();
    return user?.history ?? [];
  }

  // Update a user's data
  Future<void> updateUser(User user) async {
    final users = await getUsers();
    final userIndex = users.indexWhere((u) => u.namaLansia == user.namaLansia);
    if (userIndex != -1) {
      users[userIndex] = user;
      await _saveUsers(users);
    }
  }

  // Update password for a user
  Future<bool> updatePassword(String username, String newPassword) async {
    final users = await getUsers();
    final userIndex = users.indexWhere((u) => u.namaLansia == username);
    if (userIndex != -1) {
      final updatedUser = User(
        namaPerawat: users[userIndex].namaPerawat,
        nomorPerawat: users[userIndex].nomorPerawat,
        namaLansia: users[userIndex].namaLansia,
        password: newPassword,
        umur: users[userIndex].umur,
        prioritasPenyakit: users[userIndex].prioritasPenyakit,
        emergencyNumber: users[userIndex].emergencyNumber,
        profilePicturePath: users[userIndex].profilePicturePath,
        medications: users[userIndex].medications,
        history: users[userIndex].history,
      );
      users[userIndex] = updatedUser;
      await _saveUsers(users);
      return true;
    }
    return false;
  }

  // Delete account
  Future<void> deleteAccount() async {
    final user = await getLoggedInUser();
    if (user != null) {
      final users = await getUsers();
      users.removeWhere((u) => u.namaLansia == user.namaLansia);
      await _saveUsers(users);
      await logout(); // Also log out the user
    }
  }

  // Check if privacy policy has been agreed to
  Future<bool> getPrivacyPolicyAgreed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyPolicyAgreedKey) ?? false;
  }

  // Set privacy policy agreement
  Future<void> setPrivacyPolicyAgreed(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyPolicyAgreedKey, agreed);
  }

  // Private helper to save the list of users
  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedUsers = jsonEncode(
      users.map((u) => u.toMap()).toList(),
    );
    await prefs.setString(_usersKey, encodedUsers);
  }

  // Ensure default user for testing exists
  Future<void> ensureDefaultUserExists() async {
    final users = await getUsers();

    if (!users.any((user) => user.namaLansia == 'devobatin')) {
      final defaultUser = User(
        namaPerawat: 'Dev Caregiver',
        nomorPerawat: '+6281234567890',
        namaLansia: 'devobatin',
        password: 'obatinsehat67',
        emergencyNumber: '+6281234567890',
      );
      users.add(defaultUser);
      await _saveUsers(users);
    }
  }
}
