import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market/components/manor_temparature_widget.dart';
import 'package:carrot_market/repository/contents_repository.dart';
import 'package:carrot_market/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ContentRepository contentRepository = new ContentRepository();
  late Size size;
  late List<Map<String, String>> imgList;
  int _current = 0;
  double scrollPositionToAlpha = 0;
  final ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTwean;
  late bool isMyFavoriteContent = false;

  @override
  void initState() {
    super.initState();
    contentRepository = new ContentRepository();

    _animationController = AnimationController(vsync: this);
    _colorTwean = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollPositionToAlpha = 255;
          return;
        }
        scrollPositionToAlpha = _controller.offset;
        _animationController.value = scrollPositionToAlpha / 255;
      });
    });

    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool ck = await contentRepository.isMyFavoriteContent(widget.data["cid"]!);
    setState(() {
      isMyFavoriteContent = ck;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      {"id": "0", "url": widget.data["image"]!},
      {"id": "1", "url": widget.data["image"]!},
      {"id": "2", "url": widget.data["image"]!},
      {"id": "3", "url": widget.data["image"]!},
      {"id": "4", "url": widget.data["image"]!},
    ];
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTwean,
        builder: (context, child) => Icon(icon, color: _colorTwean.value));
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.share),
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.more_vert),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _makeSliderWidget() {
    return Stack(
      children: [
        Hero(
          tag: widget.data["cid"]!,
          child: CarouselSlider(
            options: CarouselOptions(
              height: size.width,
              initialPage: 0,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imgList.map((map) {
              return Image.asset(
                map["url"]!,
                width: size.width,
                fit: BoxFit.fill,
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == int.parse(entry.value["id"]!)
                          ? 0.9
                          : 0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: Container(
          //     width: 50,
          //     height: 50,
          //     child: Image.asset("assets/images/user.png"),
          //   ),
          // )
          CircleAvatar(
            radius: 20,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("재미있는사람",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("제주시 도담동"),
            ],
          ),
          Expanded(child: ManorTemparature(manorTemp: 37.5))
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"]!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "모두보기",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderWidget(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(
              List.generate(20, (index) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(color: Colors.grey, height: 120),
                      ),
                      Text("상품 제목", style: TextStyle(fontSize: 14)),
                      Text("가격",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ]);
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(children: [
        GestureDetector(
          onTap: () async {
            if (isMyFavoriteContent) {
              await contentRepository
                  .deleteMyFavoriteContent(widget.data['cid']!);
            } else {
              await contentRepository.addMyFavoriteContent(widget.data);
            }
            setState(() {
              isMyFavoriteContent = !isMyFavoriteContent;
            });

            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   duration: Duration(microseconds: 1000),
            //   content: Text(
            //       isMyFavoriteContent ? "관심목록에 추가됐습니다." : "관심목록에서 제거됐습니다."),
            // ));
            scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                duration: Duration(microseconds: 1000),
                content: Text(
                    isMyFavoriteContent ? "관심목록에 추가됐습니다." : "관심목록에서 제거됐습니다."),
              ),
            );
          },
          child: SvgPicture.asset(
            isMyFavoriteContent
                ? "assets/svg/heart_on.svg"
                : "assets/svg/heart_off.svg",
            width: 25,
            height: 25,
            color: Color(0xfff08f4f),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 10),
          width: 1,
          height: 40,
          color: Colors.grey.withOpacity(0.3),
        ),
        Column(
          children: [
            Text(
              DataUtils.calcStringToWon(widget.data["price"]!),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "가격제안불가",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            )
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xfff08f4f),
                ),
                child: Text(
                  "채팅으로 거래하기",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
