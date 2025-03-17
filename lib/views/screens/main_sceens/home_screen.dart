import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/views/screens/main_sceens/major_screen.dart';
import 'package:huit_elearn/views/widgets/othongtin.dart';

// ignore: must_be_immutable
class HomeSceen extends StatefulWidget {
  late ScrollController controller;

  HomeSceen({super.key, required ScrollController control}) {
    controller = control;
  }
  @override
  _HomeSceenState createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeSceen> {
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
          icon: Icon(Icons.menu),
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
                    flex: 3,
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
                  Expanded(
                    flex: selectedValue == null ? 1 : 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Colors.grey[200],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    width: double.infinity,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_test.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bạn muốn\ntạo bài kiểm tra?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Tạo ngay",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          "Chọn một khoa",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ),
                    ),
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      context.go("/home/major");
                    },
                    onDetailTap: () {
                      context.go("/detailmajor");
                    },
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      context.push("/home/major");
                    },
                    onDetailTap: () {},
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MajorSceen()),
                      );
                    },
                    onDetailTap: () {},
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MajorSceen()),
                      );
                    },
                    onDetailTap: () {},
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MajorSceen()),
                      );
                    },
                    onDetailTap: () {},
                  ),
                  OThongTin(
                    title: "Công nghệ Thông tin",
                    subtitle: "CNTTfdfdf",
                    logoWidget: Image.asset("assets/images/cnm.jpg"),
                    onContainerTap: () {
                      context.push("/major");
                    },
                    onDetailTap: () {},
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
