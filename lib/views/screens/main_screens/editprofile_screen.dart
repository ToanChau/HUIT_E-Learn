import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/repositories/user_repository.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_bloc.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_event.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dOBController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  late ProfileEditBloc _profileEditBloc;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _profileEditBloc = ProfileEditBloc(
      userRepository: UserRepository(),
      authBloc: context.read<AuthBloc>(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dOBController.dispose();
    _gioiTinhController.dispose();
    _profileEditBloc.close();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dOBController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _profileEditBloc.add(
        ProfileAvatarChangedEvent(avatarFile: _selectedImage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentstate = context.watch<AuthBloc>().state;
    late UserModel user;
    if (currentstate is AuthAuthenticated) {
      user = currentstate.user;
      if (_nameController.text.isEmpty) {
        _nameController.text = user.tenNguoiDung ?? '';
        _gioiTinhController.text = user.gioiTinh;
        _selectedDate = user.ngaySinh;
        _dOBController.text = DateFormat('dd/MM/yyyy').format(user.ngaySinh);

        _profileEditBloc.add(ProfileEditInitialEvent(user: user));
      }
    } else {
      return Scaffold(body: Center(child: Text('Chưa đăng nhập')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tài khoản',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocProvider.value(
        value: _profileEditBloc,
        child: BlocConsumer<ProfileEditBloc, ProfileEditState>(
          listener: (context, state) {
            if (state is ProfileEditError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ProfileEditSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cập nhật thông tin thành công')),
              );
              context.read<ProfileEditBloc>().add(
                ProfileEditInitialEvent(user: user),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Email của bạn",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            user.eMail,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Photo Profile",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                              as ImageProvider
                                          : (user.anhDaiDien != null &&
                                              user.anhDaiDien!.isNotEmpty)
                                          ? NetworkImage(user.anhDaiDien!)
                                          : AssetImage("assets/images/user.jpg")
                                              as ImageProvider,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        190,
                                        190,
                                        190,
                                      ),
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    color: Colors.black,
                                    onPressed: _pickImage,
                                    icon: Icon(Icons.edit, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _buildTextField(
                                lable: "Họ và tên",
                                controller: _nameController,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                lable: "Giới tính",
                                controller: _gioiTinhController,
                              ),
                              SizedBox(height: 16),
                              _buildDateField(
                                label: "Ngày sinh",
                                controller: _dOBController,
                                onTap: () => _selectDate(context),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child:
                                    state is ProfileEditLoadingState
                                        ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                        : ElevatedButton(
                                          onPressed: () {
                                            _profileEditBloc.add(
                                              ProfileEditSubmitEvent(
                                                name: _nameController.text,
                                                dOB:
                                                    _selectedDate ??
                                                    user.ngaySinh,
                                                gender:
                                                    _gioiTinhController.text,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Lưu",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              44,
                                              62,
                                              80,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String lable,
    required TextEditingController controller,
  }) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            lable,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextField(
            cursorColor: Colors.black,
            cursorHeight: 20,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextField(
            readOnly: true,
            controller: controller,
            style: TextStyle(fontSize: 12),
            onTap: onTap,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today, size: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[350] ?? Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
