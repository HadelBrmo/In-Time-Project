import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../bloc/chatBloc/chatBloc.dart';
import 'select_members_page.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescController = TextEditingController(); // 👈 حقل الوصف الجديد
  File? _groupImage;

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final inputFillColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: const Text('مجموعة جديدة'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: isDarkMode ? const Color(0xFF333333) : Colors.grey[200],
                        backgroundImage: _groupImage != null ? FileImage(_groupImage!) : null,
                        child: _groupImage == null
                            ? Icon(Icons.group_rounded, size: 50, color: isDarkMode ? Colors.white54 : Colors.grey[400])
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {},
                          child: const CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 18,
                            child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // حقل اسم المجموعة
                TextFormField(
                  controller: _groupNameController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "اسم المجموعة (إجباري)",
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
                    filled: true,
                    fillColor: inputFillColor,
                    prefixIcon: const Icon(Icons.edit_outlined, color: AppColors.primaryColor),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? "الرجاء إدخال اسم المجموعة" : null,
                ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _groupDescController,
                  maxLines: 3,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "وصف المجموعة (اختياري)...",
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
                    filled: true,
                    fillColor: inputFillColor,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.description_outlined, color: AppColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final chatBloc = context.read<ChatBloc>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: chatBloc,
                              child: SelectMembersPage(
                                groupName: _groupNameController.text.trim(),
                                groupDescription: _groupDescController.text.trim(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    label: const Text(
                      "إضافة أعضاء المجموعة",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ).animate().fade(delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}