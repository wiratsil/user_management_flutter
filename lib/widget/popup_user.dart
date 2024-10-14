import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:user_management/service/api_service.dart';

class PopupUser extends StatefulWidget {
  const PopupUser({
    super.key,
    required this.user,
    required this.isNewUser, // ตัวบอกว่าเป็นผู้ใช้ใหม่หรือไม่
  });
  
  final User user;
  final bool isNewUser;

  @override
  State<PopupUser> createState() => _PopupUserState();
}

class _PopupUserState extends State<PopupUser> {
  final ApiService apiService = ApiService();
  
  // คอนโทรลเลอร์ของ TextField
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    
    // ตั้งค่าเริ่มต้นของคอนโทรลเลอร์ด้วยข้อมูลจาก User (หรือว่างถ้าเป็นการเพิ่มผู้ใช้ใหม่)
    firstNameController = TextEditingController(text: widget.isNewUser ? '' : widget.user.firstName);
    lastNameController = TextEditingController(text: widget.isNewUser ? '' : widget.user.lastName);
    emailController = TextEditingController(text: widget.isNewUser ? '' : widget.user.email);
  }

  @override
  void dispose() {
    // ล้างข้อมูลคอนโทรลเลอร์เมื่อไม่ใช้งาน
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNewUser ? 'Add User' : 'Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'First Name',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Last Name',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // สร้างหรืออัปเดต User
            if (widget.isNewUser) {
              // สร้าง User ใหม่
              final newUser = User(
                id: '', // id อาจจะถูกสร้างอัตโนมัติจาก API หรือกำหนดที่หลัง
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
              );
              await apiService.createUser(newUser); // เรียก API สร้างผู้ใช้ใหม่
            } else {
              // แก้ไขข้อมูลผู้ใช้เดิม
              widget.user.firstName = firstNameController.text;
              widget.user.lastName = lastNameController.text;
              widget.user.email = emailController.text;
              await apiService.updateUser(widget.user.id, widget.user); // เรียก API แก้ไขข้อมูล
            }

            Get.back(); // ปิด Dialog
          },
          child: Text(widget.isNewUser ? 'Add' : 'Edit'),
        ),
      ],
    );
  }
}
