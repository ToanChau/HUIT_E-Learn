import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/repositories/faculty_repository.dart';
import 'package:huit_elearn/repositories/subject_repository.dart';
import 'package:huit_elearn/viewModels/upload/upload_bloc.dart';
import 'package:huit_elearn/viewModels/upload/upload_event.dart';
import 'package:huit_elearn/viewModels/upload/upload_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';
import 'package:huit_elearn/views/widgets/dotbox.dart';
import 'package:huit_elearn/views/widgets/stepperline.dart';
import 'package:huit_elearn/views/widgets/uploadcomplete.dart';
import 'package:huit_elearn/views/widgets/uploadprogress.dart';
import 'package:huit_elearn/views/widgets/uploadprogresscomplete.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  var index = 0;
  final _khoaController = TextEditingController();
  final _monController = TextEditingController();
  final _tenTaiLieuController = TextEditingController();
  final _moTaController = TextEditingController();

  final List<String> _stepTitles = ['Tải lên', 'Chi tiết', 'Hoàn thành'];

  final FacultyRepository _facultyRepository = FacultyRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();

  List<Faculty> faculties = [];
  List<Subject> subjects = [];

  Faculty? selectedFaculty;
  Subject? selectedSubject;

  bool isLoadingFaculties = true;
  bool isLoadingSubjects = false;

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    setState(() {
      isLoadingFaculties = true;
    });

    try {
      final loadedFaculties = await _facultyRepository.getAllFaculties();
      setState(() {
        faculties = loadedFaculties;
        isLoadingFaculties = false;
        print('Loading Sucessfull');
      });
    } catch (e) {
      print('Error loading faculties: $e');
      setState(() {
        isLoadingFaculties = false;
      });
    }
  }

  Future<void> _loadSubjects(String maKhoa) async {
    setState(() {
      isLoadingSubjects = true;
      selectedSubject = null;
    });

    try {
      final loadedSubjects = await _subjectRepository.getSubjectsByFaculty(
        maKhoa,
      );
      setState(() {
        subjects = loadedSubjects;
        isLoadingSubjects = false;
      });
    } catch (e) {
      print('Error loading subjects: $e');
      setState(() {
        isLoadingSubjects = false;
      });
    }
  }

  @override
  void dispose() {
    _khoaController.dispose();
    _monController.dispose();
    _tenTaiLieuController.dispose();
    _moTaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener:
          (context, state) => {
            if (state is UploadCancelledState)
              {
                if (state.message != null)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  },
                setState(() {
                  index = 0;
                  selectedFaculty = null;
                  selectedSubject = null;
                  _tenTaiLieuController.clear();
                  _moTaController.clear();
                }),
                context.read<UploadBloc>().add(UploadInitial()),
              },

            if (state is UploadInitialState)
              {
                MainView.hideNav.value = false,
                index = 0,
                setState(() {
                  index = 0;
                  selectedFaculty = null;
                  selectedSubject = null;
                  _tenTaiLieuController.clear();
                  _moTaController.clear();
                }),
              },
            if (state is UploadDetailSuccessState || state is UploadFailState)
              {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state is UploadDetailSuccessState
                                  ? "Tải lên thành công"
                                  : "Lỗi tải lên ! hãy thử lại",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<UploadBloc>().add(
                                        UploadInitial(),
                                      );
                                      index = 0;
                                      Navigator.of(context).pop();
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        "Đồng ý",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        borderRadius: BorderRadius.circular(10),
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
                ),
              },
          },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: NumberedStepper(
                  currentStep:
                      (state is UploadFileSuccessState && index == 2)
                          ? 2
                          : (state is UploadFileSuccessState && index == 1)
                          ? 1
                          : index,
                  stepTitles: _stepTitles,
                ),
              ),
              Flexible(
                flex:
                    ((state is UploadFileSuccessState &&
                                (index == 1 || index == 2)) ||
                            state is UploadDetailSuccessState)
                        ? 1
                        : 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:
                      state is UploadLoadingState
                          ? UploadProgress(
                            fileName: "Đang tải lên...",
                            progress: 0,
                            remainingTime: "Đang tải lên",
                            onCancel: () {
                              context.read<UploadBloc>().add(UploadCancelled());
                            },
                          )
                          : state is UploadProgressState
                          ? UploadProgress(
                            fileName: state.filename,
                            progress: state.progress,
                            remainingTime: state.remainingTime,
                            onCancel: () {
                              context.read<UploadBloc>().add(UploadCancelled());
                            },
                          )
                          : state is UploadFileSuccessState
                          ? index == 0
                              ? UploadProgressComplete(
                                fileName: state.tenTaiLieu,
                              )
                              : Uploadcomplete(
                                fileName: state.tenTaiLieu,
                                fileSize: state.kichThuoc,
                              )
                          : Container(),
                ),
              ),
              Expanded(
                flex: MainView.hideNav.value == true ? 5 : 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      (state is UploadFileSuccessState &&
                              (index == 1 || index == 2))
                          ? UpLoadInPut(state)
                          : DotBox(),
                ),
              ),
              MainView.hideNav.value == true
                  ? Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          (state is UploadLoadingState ||
                                  state is UploadProgressState)
                              ? ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Tiếp tục",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    116,
                                    116,
                                    116,
                                  ),
                                ),
                              )
                              : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (index < 2) {
                                      index++;
                                    } else {
                                      if (selectedFaculty == null ||
                                          selectedSubject == null ||
                                          _tenTaiLieuController.text.isEmpty ||
                                          _moTaController.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Vui lòng điền đầy đủ thông tin',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      _submitDetails();
                                    }
                                  });
                                },
                                child: Text(
                                  index == 2 ? "Tải lên" : "Tiếp tục",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    44,
                                    62,
                                    80,
                                  ),
                                ),
                              ),
                          TextButton(
                            onPressed: () {
                              if (index == 2) {
                                setState(() {
                                  index = 1;
                                });
                              } else {
                                context.read<UploadBloc>().add(
                                  UploadCancelled(),
                                );
                              }
                            },
                            child: FittedBox(
                              child: Text(
                                index != 2 ? "Hủy" : "Quay lại",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    119,
                                    119,
                                    119,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                const Color.fromARGB(0, 246, 245, 245),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget UpLoadInPut(UploadState state) {
    return ListView(
      children: [
        Center(
          child: Text(
            "Mô tả",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text("Khoa")),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child:
              isLoadingFaculties
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonHideUnderline(
                    child: DropdownButton<Faculty>(
                      isExpanded: true,
                      value: selectedFaculty,
                      style: const TextStyle(color: Colors.black),
                      hint: const Text(
                        "Chọn khoa",
                        overflow: TextOverflow.ellipsis,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged:
                          (state is UploadFileSuccessState && index == 2)
                              ? null
                              : ((newValue) {
                                setState(() {
                                  selectedFaculty = newValue;

                                  selectedSubject = null;
                                  if (newValue != null) {
                                    _loadSubjects(newValue.maKhoa);
                                  } else {
                                    subjects = [];
                                  }
                                });
                              }),
                      items:
                          faculties.map((Faculty faculty) {
                            return DropdownMenuItem<Faculty>(
                              value: faculty,
                              child: Text(
                                faculty.tenKhoa,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text("Môn")),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child:
              isLoadingSubjects
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonHideUnderline(
                    child: DropdownButton<Subject>(
                      isExpanded: true,
                      value: selectedSubject,
                      style: const TextStyle(color: Colors.black),
                      hint: Text(
                        selectedFaculty == null
                            ? "Vui lòng chọn khoa trước"
                            : subjects.isEmpty
                            ? "Không có môn học"
                            : "Chọn môn học",
                        overflow: TextOverflow.ellipsis,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged:
                          (state is UploadFileSuccessState && index == 2) ||
                                  selectedFaculty == null
                              ? null
                              : ((newValue) {
                                setState(() {
                                  selectedSubject = newValue;
                                });
                              }),
                      items:
                          subjects.map((Subject subject) {
                            return DropdownMenuItem<Subject>(
                              value: subject,
                              child: Text(
                                subject.tenMH,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tên tài liệu"),
        ),
        SizedBox(
          height: 50,
          child: TextField(
            readOnly: index == 2,
            controller: _tenTaiLieuController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text("Mô tả")),
        Container(
          height: 50,
          child: TextField(
            readOnly: index == 2,
            controller: _moTaController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitDetails() {
    if (selectedFaculty == null ||
        selectedSubject == null ||
        _tenTaiLieuController.text.isEmpty ||
        _moTaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    context.read<UploadBloc>().add(
      UploadDetailSubmitted(
        tenTaiLieu: _tenTaiLieuController.text,
        moTa: _moTaController.text,
        maMH: selectedSubject!.maMH,
      ),
    );
  }
}
