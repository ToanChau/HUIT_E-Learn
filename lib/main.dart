import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/repositories/faculty_repository.dart';
import 'package:huit_elearn/repositories/lecturer_respository.dart';
import 'package:huit_elearn/repositories/question_respository.dart';
import 'package:huit_elearn/repositories/subject_repository.dart';
import 'package:huit_elearn/repositories/test_repository.dart';
import 'package:huit_elearn/repositories/user_repository.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_event.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_bloc.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_bloc.dart';
import 'package:huit_elearn/viewModels/library/library_bloc.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_bloc.dart';
import 'package:huit_elearn/viewModels/upload/upload_bloc.dart';
import 'package:huit_elearn/views/app.dart';

// void main() {
//   runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase khởi tạo thành công!");
  } catch (e) {
    print("Lỗi khởi tạo Firebase: $e");
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckLogin()),
        ),
        BlocProvider<UploadBloc>(
          create:
              (context) => UploadBloc(
                documentRepository: DocumentRepository(),
                authBloc: context.read<AuthBloc>(),
              ),
        ),
        BlocProvider<CreatetestBloc>(
      create:
          (context) => CreatetestBloc(
            facultyRepository: FacultyRepository(),
            subjectRepository: SubjectRepository(),
            testRepository: TestRepository(),
            questionRespository: QuestionRespository(),
          )..add(CreateTestInitialEvent()),
        ),
         BlocProvider<DocBloc>(
      create:
          (context) => DocBloc(
            facultyRepository: FacultyRepository(),
            subjectRepository: SubjectRepository(),
            documentRepository: DocumentRepository(),
            lecturerRespository: LecturerRespository(),
          )..add(DocInitialEvent()),
        ),

        BlocProvider<TaketestBloc>(create: (context)=>TaketestBloc()),
        BlocProvider<LibraryBloc>(create: (context)=>LibraryBloc()),
        BlocProvider<ProfileEditBloc>(
            create: (context) => ProfileEditBloc(authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
      ],
      child: MyApp(),
    ),
  );
}
