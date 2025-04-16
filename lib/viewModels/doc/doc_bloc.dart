// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/repositories/faculty_repository.dart';
import 'package:huit_elearn/repositories/lecturer_respository.dart';
import 'package:huit_elearn/repositories/subject_repository.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';

class DocBloc extends Bloc<DocEvent, DocState> {
  final FacultyRepository facultyRepository;
  final SubjectRepository subjectRepository;
  final DocumentRepository documentRepository;
  final LecturerRespository lecturerRespository;
  DocBloc({
    required this.facultyRepository,
    required this.subjectRepository,
    required this.documentRepository,
    required this.lecturerRespository,
  }) : super(DocInitialState()) {
    on<DocInitialEvent>(_onDocInitial);
    on<DocChoseDetailFacultyEvent>(_onDocChoseDetailFaculty);
    on<DocChoseFacultyEvent>(_onChoseFaculty);
    on<DocChoseDetailSubjectEvent>(_onChoseDetailSubject);
    on<DocChoseSubjecEvent>(_onChoseSubject);
    on<DocChoseDocEvent>(_onChoseDoc);
    on<DocDownloadEvent>(_onDocDownload);
    on<DocSearchEvent>(_onDocSearch);
    on<SearchOnSearchScreenEvent>(_onSearchOnSearchScreen);
    on<SearchChoseDocEvent>(_onSearchChoseDoc);
  }
  void _onSearchChoseDoc(SearchChoseDocEvent event, Emitter<DocState> emit) {
    emit(SearchChoseDocState(document: event.document));
  }

  void _onSearchOnSearchScreen(
    SearchOnSearchScreenEvent event,
    Emitter<DocState> emit,
  ) {
    emit(SearchScreenstate());
  }

  void _onDocInitial(DocInitialEvent event, Emitter<DocState> emit) async {
    try {
      final faculties = await facultyRepository.getAllFaculties();
      emit(DocLoadedState(faculties));
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải danh sách khoa"));
    }
  }

  void _onDocChoseDetailFaculty(
    DocChoseDetailFacultyEvent event,
    Emitter<DocState> emit,
  ) async {
    emit(DocLoadingState());
    try {
      final lectures = await lecturerRespository.getListLecturerByListId(
        event.faculty.dSGiangVien,
      );
      emit(DocChoseDetailFaculty(faculty: event.faculty, lecturers: lectures));
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải danh sách giảng viên: $e"));
    }
  }

  void _onChoseFaculty(
    DocChoseFacultyEvent event,
    Emitter<DocState> emit,
  ) async {
    try {
      emit(DocLoadingState());
      final subjects = await SubjectRepository().getSubjectsByFaculty(
        event.faculty.maKhoa,
      );
      emit(DocChoseFaculty(faculty: event.faculty, subjects: subjects));
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải danh sách môn học $e"));
    }
  }

  void _onChoseDetailSubject(
    DocChoseDetailSubjectEvent event,
    Emitter<DocState> emit,
  ) async {
    try {
      emit(
        DocChoseDetailSubject(faculty: event.faculty, subject: event.subject),
      );
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải môn học $e"));
    }
  }

  void _onChoseSubject(
    DocChoseSubjecEvent event,
    Emitter<DocState> emit,
  ) async {
    try {
      emit(DocLoadingState());
      final documents = await documentRepository.getListDocumentByMaMH(
        event.subject,
      );
      emit(
        DocChoseSubject(
          faculty: event.faculty,
          subject: event.subject,
          documents: documents,
        ),
      );
      print(documents.length.toString());
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải tài liệu $e"));
    }
  }

  void _onChoseDoc(DocChoseDocEvent event, Emitter<DocState> emit) async {
    try {
      emit(
        DocChoseDoc(
          faculty: event.faculty,
          subject: event.subject,
          document: event.document,
        ),
      );
    } catch (e) {
      emit(DocErrorState(message: "Không thể tải tài liệu $e"));
    }
  }

  void _onDocDownload(DocDownloadEvent event, Emitter<DocState> emit) async {
    try {
      final Document document = event.document;
      final Faculty faculty = (state as DocChoseDoc).faculty;
      final Subject subject = (state as DocChoseDoc).subject;

      emit(
        DocDownloadingState(
          document: document,
          progress: 0,
          remainingSeconds: 0,
          faculty: faculty,
          subject: subject,
        ),
      );

      await documentRepository.downloadDocument(document, (
        progress,
        remainingSeconds,
      ) {
        emit(
          DocDownloadingState(
            document: document,
            progress: progress,
            remainingSeconds: remainingSeconds,
            faculty: faculty,
            subject: subject,
          ),
        );
      });

      emit(
        DocDownloadCompleteState(
          document: document,
          faculty: faculty,
          subject: subject,
        ),
      );

      emit(DocChoseDoc(faculty: faculty, subject: subject, document: document));
    } catch (e) {
      emit(DocErrorState(message: "Tải xuống thất bại: $e"));

      if (state is DocChoseDoc) {
        final docState = state as DocChoseDoc;
        emit(
          DocChoseDoc(
            faculty: docState.faculty,
            subject: docState.subject,
            document: docState.document,
          ),
        );
      }
    }
  }

  void _onDocSearch(DocSearchEvent event, Emitter<DocState> emit) async {
    final currentState = state;
    final searchQuery = event.searchQuery.toLowerCase();
    //ở màn hiển thị khoa
    if (currentState is DocLoadedState && searchQuery.isNotEmpty) {
      final filteredFaculties =
          currentState.faculties
              .where(
                (faculty) =>
                    faculty.tenKhoa.toLowerCase().contains(searchQuery) ||
                    faculty.maKhoa.toLowerCase().contains(searchQuery),
              )
              .toList();

      emit(
        DocSearchState(faculties: filteredFaculties, searchQuery: searchQuery),
      );
      //ở màn tìm kiếm khoa
    } else if (currentState is DocSearchState && searchQuery.isEmpty) {
      final faculties = await facultyRepository.getAllFaculties();
      emit(DocLoadedState(faculties));
    } else if (currentState is DocChoseFaculty && searchQuery.isNotEmpty) {
      final filteredSubjects =
          currentState.subjects
              .where(
                (subject) =>
                    subject.tenMH.toLowerCase().contains(searchQuery) ||
                    subject.maMH.toLowerCase().contains(searchQuery),
              )
              .toList();

      emit(
        DocSearchFacultyState(
          faculty: currentState.faculty,
          subjects: filteredSubjects,
          searchQuery: searchQuery,
        ),
      ); //ở màn chọn tài liệu
    } else if (currentState is DocChoseSubject && searchQuery.isNotEmpty) {
      final filteredDocuments =
          currentState.documents
              .where(
                (document) =>
                    document.tenTaiLieu.toLowerCase().contains(searchQuery) ||
                    document.maTaiLieu.toLowerCase().contains(searchQuery),
              )
              .toList();

      emit(
        DocSearchSubjectState(
          faculty: currentState.faculty,
          subject: currentState.subject,
          documents: filteredDocuments,
          searchQuery: searchQuery,
        ),
      );
    } else if (currentState is DocSearchFacultyState && searchQuery.isEmpty) {
      emit(
        DocChoseFaculty(
          faculty: currentState.faculty,
          subjects: await subjectRepository.getSubjectsByFaculty(
            currentState.faculty.maKhoa,
          ),
        ),
      );
    } else if (currentState is DocSearchSubjectState && searchQuery.isEmpty) {
      emit(
        DocChoseSubject(
          faculty: currentState.faculty,
          subject: currentState.subject,
          documents: await documentRepository.getListDocumentByMaMH(
            currentState.subject,
          ),
        ),
      );
    } else if (currentState is SearchScreenstate && searchQuery.isNotEmpty) {
      final documents =
          (await documentRepository.getListDocmentAllQuery())
            ..where(
              (document) =>
                  document.tenTaiLieu.toLowerCase().contains(searchQuery) ||
                  document.maTaiLieu.toLowerCase().contains(searchQuery),
            ).toList();
      emit(SearchingonScreen(documents: documents));
    } else if (currentState is SearchingonScreen) {
      if (searchQuery.isEmpty) {
        emit(SearchScreenstate());
      } else {
        final documents =
            (await documentRepository.getListDocmentAllQuery())
                .where(
                  (document) =>
                      document.tenTaiLieu.toLowerCase().contains(searchQuery),
                )
                .toList();
        emit(SearchingonScreen(documents: documents));
      }
    }
  }
}
