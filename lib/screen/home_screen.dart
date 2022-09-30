import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/home_app_bar.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/const/category_data.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/question/data/data_manager.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final List<CategoryCardModel> categorys = cateLists;

  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  DateTime? currentBackPressTime;

  bool isLoading = false;

  @override
  void initState() {
    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //앱 종료 핸들러
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 표시되고 사용자 입력에 응답합니다.
        // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
        // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
        // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
        // inactive가 발생되고 얼마후 pasued가 발생합니다.
        print("inactive");
        break;
      case AppLifecycleState.paused:
        // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
        // 안드로이드의 onPause()와 동일합니다.
        // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        print("paused");
        break;
      case AppLifecycleState.detached:
        // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
        // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
        // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        print("detached");
        if (currentUser != null) {
          SignManager().ticketSave();
        }

        break;
    }
  }

  Future<bool> fetchData() async {
    await getUserData();

    // await DataManager().getDataFlow();
    return true;
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
    print("currentUser: $currentUser");
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
      child: FutureBuilder<bool>(
          future: fetchData(),
          builder: (context, snapshot) {
            return Scaffold(
                //각 항목별 리스트는 여기서 보이게된다.
                body: CustomScrollView(
              controller: scrollController,
              slivers: [
                HomeAppBar(isExpanded: isExpanded, isLoaded: snapshot.data),
                SliverToBoxAdapter(
                  child: Column(children: [
                    const SizedBox(
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

  // moveGameScreen(context, CategoryCardModel category) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (_) => DataLoadScreen(cateModel: category),

  //   ));
  // }

  moveGameScreen(context, CategoryCardModel category) async {
    if (!isLoading) {
      isLoading = true;
      List<QuestionModel> questions = await getQuestions(category);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GameScreen(
                category: category.parstCateToEng(),
                questions: questions,
              )));
      isLoading = false;
    } else {
      return;
    }
  }

  Future<List<QuestionModel>> getQuestions(CategoryCardModel category) {
    final box =
        Hive.box<QuestionModel>("Question_${category.parstCateToEng()}");

    List<QuestionModel> _questions = [];

    for (QuestionModel q in box.values) {
      _questions.add(q);
    }

    return Future.value(_questions);
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
