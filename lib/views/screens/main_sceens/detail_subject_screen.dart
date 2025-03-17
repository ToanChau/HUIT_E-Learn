import 'package:flutter/material.dart';

class DetailSubjectScreen extends StatelessWidget {
  const DetailSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.6,
            floating: true,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50), // Chiều cao 
              child: Container(
                color: Colors.black54, // Màu nền 
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lập trình di động",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: size.height * 0.6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/qtkd.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Tổng quan"),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  bottom: 10,
                  right: 15,
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Trường Đại học Công Thương ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text:
                            "Thành phố Hồ Chí Minh (tiếng Anh: Ho Chi Minh City University of Industry and Trade; HUIT)",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text:
                            " là một là một cơ sở giáo dục đại học công lập trực thuộc Bộ Công Thương, đào tạo đa ngành, đa lĩnh vực, có thế mạnh trong lĩnh vực công nghiệp và thương mại, được thành lập ngày 9 tháng 9 năm 1982.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(padding: const EdgeInsets.all(10), child: Text("Cơ sở")),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "140 Lê Trọng Tấn, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh.",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "93 Tân Kỳ Tân Quý, Tân Sơn Nhì, Tân Phú, TP. Hồ Chí Minh.",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "73/1 Nguyễn Đỗ Cung, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Các Khoa"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "73/1 Nguyễn Đỗ Cung, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Các Khoa"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "73/1 Nguyễn Đỗ Cung, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Các Khoa"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "73/1 Nguyễn Đỗ Cung, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Các Khoa"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_sharp),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "73/1 Nguyễn Đỗ Cung, Tây Thạnh, Tân Phú, TP. Hồ Chí Minh",
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Các Khoa"),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}