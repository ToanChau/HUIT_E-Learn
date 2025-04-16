import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/viewModels/doc/doc_bloc.dart';
import 'package:huit_elearn/viewModels/doc/doc_event.dart';
import 'package:huit_elearn/viewModels/doc/doc_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';

class SliverAppbarDetailCustom extends StatelessWidget {
  final String uRLImage;
  final String Name;
  final String Subtitle;
  const SliverAppbarDetailCustom({
    Key? key,
    required this.uRLImage,
    required this.Name,
    required this.Subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      toolbarHeight: size.height * 0.05,
      expandedHeight: size.height * 0.5,
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        onPressed: () {
          var state = BlocProvider.of<DocBloc>(context).state;
          if(state is SearchChoseDocState)
          {
            context.read<DocBloc>().add(SearchOnSearchScreenEvent());
            MainView.hideNav.value = false;
          }
          if (state is DocChoseDetailFaculty || state is DocLoadingState) {
            context.read<DocBloc>().add(DocInitialEvent());
            MainView.hideNav.value = false;
          }
          if (state is DocChoseDetailSubject) {
            context.read<DocBloc>().add(
              DocChoseFacultyEvent(faculty: state.faculty),
            );
            MainView.hideNav.value = false;
          }
          if(state is DocChoseDoc){
             context.read<DocBloc>().add(
              DocChoseSubjecEvent(faculty: state.faculty,subject: state.subject),
            );
            MainView.hideNav.value = false;
          }
          context.pop();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: Center(
            child: Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(width: 1.5),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(uRLImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.12),
        child: Container(
          width: double.infinity, 
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, 
            vertical: size.height * 0.015,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                Subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size.width * 0.04, 
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
