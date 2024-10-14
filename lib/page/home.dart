import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:user_management/core/app_style.dart';
import 'package:user_management/service/api_service.dart';
import 'package:user_management/widget/popup_user.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>>? futureUsers;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.fetchUsers(); // โหลดข้อมูลเมื่อเริ่มต้น
  }

  Future<void> _refreshUsers() async {
    setState(() {
      futureUsers = apiService.fetchUsers(); // รีเฟรชข้อมูล
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "User",
              style: TextStyle(fontSize: 30),
            ),
            Wrap(
              children: [
                TextButton(
                  onPressed: () async {
                    await Get.dialog(PopupUser(
                      user:
                          User(id: '', firstName: '', lastName: '', email: ''),
                      isNewUser: true,
                    ));
                    _refreshUsers(); // รีเฟรชข้อมูลหลังจากเพิ่มผู้ใช้ใหม่
                  },
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                TextButton(
                  onPressed: _refreshUsers,
                  child: const Icon(Icons.refresh, color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: futureUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }

                    // แสดงข้อมูล User เป็น List
                    final users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return UserCard(user);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget UserCard(User user) {
    return Card(
      child: Row(
        children: [
          Image.asset('asset/images/male.png', height: 75),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.firstName, style: headLine4),
                    const SizedBox(width: 10),
                    Text(user.lastName, style: headLine4),
                  ],
                ),
                const SizedBox(height: 10),
                Text(user.email, style: headLine6),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // ปุ่มแก้ไข
          TextButton(
            onPressed: () async {
              await Get.dialog(PopupUser(
                user: user,
                isNewUser: false,
              ));
              _refreshUsers(); // รีเฟรชข้อมูลหลังจากแก้ไขข้อมูล
            },
            child: const Icon(Icons.edit),
          ),
          // ปุ่มลบ
          TextButton(
            onPressed: () async {
              final confirm = await _showDeleteConfirmationDialog();
              if (confirm) {
                await apiService.deleteUser(user.id).then(
                    (value) => _refreshUsers()); // เรียก API เพื่อลบผู้ใช้
                // รีเฟรชข้อมูลหลังจากลบผู้ใช้
              }
            },
            child: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับแสดง Dialog ยืนยันการลบผู้ใช้
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
