import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/views/widgets/othongtin.dart';

// ignore: must_be_immutable
class SubjectSceen extends StatefulWidget {
  String tenMon = "Tên Môn";

  SubjectSceen({Key? key}) : super(key: key);

  @override
  _SubjectSceenState createState() => _SubjectSceenState();
}

class _SubjectSceenState extends State<SubjectSceen> {
  final List<String> dropdownItems = [
    "Tùy chọn 1",
    "Tùy chọn 2rrrrrrrrrrrrrrrrrrrr",
    "Tùy chọn 3",
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.pop();
          },
        ),
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
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(50, 194, 194, 194),
            expandedHeight: size.height * 0.06,
            floating: true,
            primary: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm...",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                  Expanded(
                    flex: selectedValue == null ? 1 : 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedValue,
                      style: TextStyle(color: Colors.black),
                      hint: Text("Chọn", overflow: TextOverflow.ellipsis),
                      icon: Icon(Icons.keyboard_arrow_down),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      items:
                          dropdownItems.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            widget.tenMon,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        ),
                      ),
                    ),
                    OThongTin(
                      title: "Bài giảng 1",
                      subtitle: "CNTTfdfdf",
                      logoWidget: Image.asset("assets/images/cnm.jpg"),
                      onContainerTap: () {
                       
                      },
                      onDetailTap: () {},
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
