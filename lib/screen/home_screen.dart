import 'package:flutter/material.dart';
import 'package:meetqa/common/component/home_app_bar.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/const/category_data.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/common/manager/sign_manager.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/screen/data_load_screen.dart';
import 'package:meetqa/common/component/flutter_toast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CategoryCardModel> categorys = cateLists;

  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  DateTime? currentBackPressTime;

  @override
  void initState() {
    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  scrollListener() {
    bool isExpanded = scrollController.offset <
        350 - kToolbarHeight; //스크롤 위치가 350-앱바고정값 보다 작으면 false(열리지않음)

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  Future<void> getUserData() async {
    if (currentUser != null) {
      await SignManager().setNowUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardSize = MediaQuery.of(context).size.width < 600
        ? (MediaQuery.of(context).size.width * 0.7)
        : (MediaQuery.of(context).size.width / 2 * 0.7);

    return WillPopScope(
      onWillPop: OnWillPopController(wantExit: true).backCtlChange,
      child: FutureBuilder<void>(
          future: getUserData(),
          builder: (context, snapshot) {
            return Scaffold(
                //각 항목별 리스트는 여기서 보이게된다.
                body: CustomScrollView(
              controller: scrollController,
              slivers: [
                HomeAppBar(
                    isExpanded: isExpanded, isLoaded: snapshot.connectionState),
                SliverToBoxAdapter(
                  child: Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    ...categorys.map(
                      (e) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DefaultCard(
                            onTap: moveGameScreen,
                            cardSize: cardSize,
                            category: e,
                          ),
                        );
                      },
                    ).toList(),
                  ]),
                )
              ],
            ));
          }),
    );
  }

  moveGameScreen(context, CategoryCardModel category) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DataLoadScreen(cateModel: category),
    ));
  }
}

class DefaultCard extends StatelessWidget {
  final onTap;
  final double cardSize;
  final CategoryCardModel category;
  DefaultCard({
    Key? key,
    required this.onTap,
    required this.cardSize,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => onTap(context, category),
        child: Container(
            height: cardSize,
            width: cardSize,
            decoration: BoxDecoration(
              border: Border.all(color: category.backgroundColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Image.asset(
                  category.imgPath,
                ),
                Text(category.parstCateToString()),
              ],
            )),
      ),
    );
  }
}
