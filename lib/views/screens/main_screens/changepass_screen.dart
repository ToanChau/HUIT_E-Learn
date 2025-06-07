import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/changepass/changepass_bloc.dart';
import 'package:huit_elearn/viewModels/changepass/changepass_event.dart';
import 'package:huit_elearn/viewModels/changepass/changepass_state.dart';

class ChangepassScreen extends StatefulWidget {
  const ChangepassScreen({super.key});

  @override
  State<ChangepassScreen> createState() => _ChangepassScreenState();
}

class _ChangepassScreenState extends State<ChangepassScreen> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final ChangepassBloc _changepassBloc = ChangepassBloc();
  bool _obscureCurrentPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  @override
  void initState() {
    super.initState();
    _changepassBloc.add(ChangepassInitialEvent());
  }

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    _changepassBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _changepassBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Đổi mật khẩu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: BlocConsumer<ChangepassBloc, ChangepassState>(
          listener: (context, state) {
            if (state is ChangePassCompleteState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đổi mật khẩu thành công'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is ChangePassErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: buildPasswordField(
                      label: "Mật khẩu hiện tại",
                      controller: _currentPassController,
                      obscureText: _obscureCurrentPass,
                      toggleObscureText: () {
                        setState(() {
                          _obscureCurrentPass = !_obscureCurrentPass;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: buildPasswordField(
                      label: "Mật khẩu mới",
                      controller: _newPassController,
                      obscureText: _obscureNewPass,
                      toggleObscureText: () {
                        setState(() {
                          _obscureNewPass = !_obscureNewPass;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: buildPasswordField(
                      label: "Xác nhận mật khẩu mới",
                      controller: _confirmPassController,
                      obscureText: _obscureConfirmPass,
                      toggleObscureText: () {
                        setState(() {
                          _obscureConfirmPass = !_obscureConfirmPass;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state is ChangingPassState
                                ? null
                                : () {
                                    _changepassBloc.add(
                                      ChangingpassEvent(
                                        currentPass: _currentPassController.text,
                                        newPass: _newPassController.text,
                                        confirmPass: _confirmPassController.text,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 44, 62, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: state is ChangingPassState
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Lưu",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleObscureText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleObscureText,
        ),
      ),
    );
  }
}