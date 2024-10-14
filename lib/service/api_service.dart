import 'package:dio/dio.dart';

class ApiService {
  Dio _dio = Dio();
  final String url = 'https://to-do-app-safe-b1e7156c1ae8.herokuapp.com';
  // ฟังก์ชัน GET: ใช้เพื่อดึงข้อมูล
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get('$url/users');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // ฟังก์ชัน POST: ใช้เพื่อสร้างข้อมูลใหม่
  Future<void> createUser(User user) async {
    try {
      final response = await _dio.post(
        '$url/users',
        data: {
          'first': user.firstName,
          'last': user.lastName,
          'email': user.email,
        },
      );

      if (response.statusCode == 201) {
        print('User created successfully');
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // ฟังก์ชัน PUT: ใช้เพื่ออัปเดตข้อมูล
  Future<void> updateUser(String id, User user) async {
    try {
      final response = await _dio.put(
        '$url/users/$id',
        data: {
          'first': user.firstName,
          'last': user.lastName,
          'email': user.email,
        },
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // ฟังก์ชัน DELETE: ใช้เพื่อลบข้อมูล
  Future<void> deleteUser(String id) async {
    try {
      final response = await _dio.delete('$url/users/$id');

      if (response.statusCode == 204) {
        print('User deleted successfully');
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}

// โมเดล User สำหรับจัดการข้อมูลผู้ใช้
class User {
  final String id;
  late String firstName;
  late String lastName;
  late String email;

  User({
    required this.id, // อัปเดตโมเดลให้มี _id
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // การแปลง JSON เป็น Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'], // กำหนดให้ _id จาก JSON
      firstName: json['first'],
      lastName: json['last'],
      email: json['email'],
    );
  }

  // การแปลง Object เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'first': firstName,
      'last': lastName,
      'email': email,
    };
  }
}
