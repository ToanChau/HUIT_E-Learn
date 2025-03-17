import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required ScrollController control}) {
    controller = control;
  }

  late ScrollController controller = ScrollController();

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode_rounded)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/user.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: widget.controller,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: size.height * 0.05,
            floating: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm...",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Colors.grey[200],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Container()],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
