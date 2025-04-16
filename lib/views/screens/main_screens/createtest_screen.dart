import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_bloc.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_event.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_state.dart';
import 'package:huit_elearn/views/screens/main_screens/taketest_screen.dart';
import 'package:huit_elearn/views/widgets/othongtin.dart';
import 'package:huit_elearn/views/widgets/testbox.dart';

class CreateTestScreen extends StatefulWidget {
  const CreateTestScreen({super.key});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  String? doKho;
  TextEditingController _soCauHoiController = TextEditingController();
  TextEditingController _thoiGianController = TextEditingController();
  TextEditingController _tenDeController = TextEditingController();

  void setTextBox() {
    if (doKho == "Dễ") {
      _soCauHoiController.text = "30 câu";
      _thoiGianController.text = "30 phút";
    } else if (doKho == "Khó") {
      _soCauHoiController.text = "40 câu";
      _thoiGianController.text = "35 phút";
    } else {
      _soCauHoiController.text = "50 câu";
      _thoiGianController.text = "60 phút";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    final List<String> dropdownItems = ["Dễ", "Trung Bình", "Khó"];

    if (authState is! AuthAuthenticated) {
      return Center(child: Text("Vui lòng đăng nhập để xem bài kiểm tra"));
    }

    final userID = (authState).user.maNguoiDung;
    return Scaffold(
      body: BlocBuilder<CreatetestBloc, CreatetestState>(
        builder: (context, state) {
          if (state is CreateTestInitialState ||
              state is CreateTestLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CreateTestLoadedState) {
            return Column(
              children: [
                Center(
                  child: Flexible(
                    child: Text(
                      "Chọn một khoa",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.faculties.length,
                    itemBuilder: (context, index) {
                      final faculty = state.faculties[index];
                      return OThongTin(
                        isHaveDetail: false,
                        title: faculty.tenKhoa,
                        subtitle: faculty.maKhoa,
                        logoWidget:
                            faculty.anhKhoa.isNotEmpty
                                ? Image.network(faculty.anhKhoa)
                                : Image.asset("assets/images/cntt.jpg"),
                        onContainerTap: () {
                          context.read<CreatetestBloc>().add(
                            ChoseFacultyEvent(faculty),
                          );
                        },
                        onDetailTap: () {},
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is ChoseFacultyState) {
            return Column(
              children: [
                Center(
                  child: Flexible(
                    child: Text(
                      state.faculty.tenKhoa,
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.subjects.length,
                    itemBuilder: (context, index) {
                      final Subject = state.subjects[index];
                      return OThongTin(
                        isHaveDetail: false,
                        title: Subject.tenMH,
                        subtitle: Subject.maMH,
                        logoWidget:
                            Subject.anhMon.isNotEmpty
                                ? Image.network(Subject.anhMon)
                                : Image.asset("assets/images/cntt.jpg"),
                        onContainerTap: () {
                          context.read<CreatetestBloc>().add(
                            ChoseSubjectEvent(
                              subject: state.subjects[index],
                              userID: userID,
                              faculty: state.faculty,
                            ),
                          );
                        },
                        onDetailTap: () {},
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is ChoseTestState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => TaketestScreen(
                        questions: state.questions,
                        test: state.test,
                        subject: state.subject,
                        faculty: state.faculty,
                      ),
                ),
              );
            });
            return SizedBox.shrink();
          }
          if (state is CreatedgNomalTestState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => TaketestScreen(
                        questions: state.questions,
                        test: state.test,
                        subject: state.subject,
                        faculty: state.faculty,
                      ),
                ),
              );
            });
            return SizedBox.shrink();
          }
          if (state is ChoseSubjectState) {
            return GridView.builder(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.7,
              ),
              itemCount: state.tests.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      context.read<CreatetestBloc>().add(
                        ChoseCreateTestEvent(
                          useId: userID,
                          subject: state.currentSubject,
                          faculty: state.faculty,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Color.fromARGB(255, 121, 33, 243),
                          weight: 900,
                        ),
                      ),
                    ),
                  );
                }
                final test = state.tests[index - 1];
                return TestBox(context, test, index, () {
                  context.read<CreatetestBloc>().add(
                    ChoseTestEvent(test, state.currentSubject, state.faculty),
                  );
                });
              },
            );
          }
          if (state is ChoseCreateTestState) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Tạo đề mới',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text("Độ khó"),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 50,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  onChanged: (newValue) {
                                    setState(() {
                                      doKho = newValue;
                                      setTextBox();
                                    });
                                  },
                                  isExpanded: true,
                                  value: doKho,
                                  style: const TextStyle(color: Colors.black),
                                  hint: Text("Chọn mức độ khó của đề"),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items:
                                      dropdownItems.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text("Đặt tên cho đề"),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged:
                                  (value) => {
                                    setState(() {
                                      _tenDeController.text = value;
                                    }),
                                  },
                              controller: _tenDeController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Text("Số lượng câu hỏi"),
                            const SizedBox(height: 8),
                            TextField(
                              readOnly: true,
                              controller: _soCauHoiController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text("Thời gian"),
                            const SizedBox(height: 8),
                            TextField(
                              readOnly: true,
                              controller: _thoiGianController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                (_tenDeController.text.isNotEmpty &&
                                        _soCauHoiController.text.isNotEmpty &&
                                        _thoiGianController.text.isNotEmpty)
                                    ? () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Bạn muốn tạo đề bằng AI không?",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "Lưu ý: Đề được tạo ra từ AI có thể có sai sót và chỉ mang tính chất tham khảo",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            context.read<CreatetestBloc>().add(
                                                              CreatingNomalTestEvent(
                                                                testName:
                                                                    _tenDeController
                                                                        .text,
                                                                subject:
                                                                    state
                                                                        .subject,
                                                                faculty:
                                                                    state
                                                                        .faculty,
                                                                useId: userID,
                                                                level:
                                                                    doKho ??
                                                                    "Dễ",
                                                              ),
                                                            );
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: FittedBox(
                                                            child: Text(
                                                              "Tạo đề thường",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                  255,
                                                                  44,
                                                                  62,
                                                                  80,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(flex: 1),
                                                      Expanded(
                                                        flex: 5,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            context.read<CreatetestBloc>().add(
                                                              CreatingRAGTestEvent(
                                                                testName:
                                                                    _tenDeController
                                                                        .text,
                                                                subject:
                                                                    state
                                                                        .subject,
                                                                faculty:
                                                                    state
                                                                        .faculty,
                                                                useId: userID,
                                                                level:
                                                                    doKho ??
                                                                    "Dễ",
                                                              ),
                                                            );
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: FittedBox(
                                                            child: Text(
                                                              "Đồng ý",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                  255,
                                                                  44,
                                                                  62,
                                                                  80,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 44, 62, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Bắt đầu làm bài",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CreateTestErrorState) {
            return Column(
              children: [
                Center(child: Text(state.message)),
                ElevatedButton(
                  onPressed: () {
                    context.read<CreatetestBloc>().add(
                      CreateTestInitialEvent(),
                    );
                  },
                  child: FittedBox(
                    child: Text(
                      "Quay lại",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 44, 62, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
