import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hibir/constant.dart';
import 'package:hibir/edit_profile_screen/edit_profile_view.dart';
import 'package:hibir/login_screen/login_screen_view.dart';
import 'package:hibir/models/api_response.dart';
import 'package:hibir/models/post.dart';
import 'package:hibir/screens/content_screen.dart';
import 'package:hibir/search_screen/search_screen_view.dart';
import 'package:hibir/services/post_service.dart';
import 'package:hibir/services/user_service.dart';
import 'package:hibir/upload_video_screen/upload_video.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  int userId = 0;
  PageController _pageController = PageController();
  List<Post> _postList = [];
  bool _loading = true;

  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<Post>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false)
          });
    } else {
      _showErrorDialog('${response.error}');
    }
  }

  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false)
          });
    } else {
      _showErrorDialog('${response.error}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 114, 159, 255),
        selectedFontSize: 15,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            _pageController.jumpToPage(value);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: [
            Stack(
              children: [
                _loading
                    ? Center(child: CircularProgressIndicator())
                    : Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return ContentScreen(
                            post: _postList[index],
                          );
                        },
                        itemCount: _postList.length,
                        scrollDirection: Axis.vertical,
                      ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            iconSize: 22,
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const UploadView()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),
                          IconButton(
                            iconSize: 22,
                            onPressed: () {
                              logout().then((value) => {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginView()),
                                        (route) => false)
                                  });
                            },
                            icon: const Icon(Icons.logout_sharp),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SearchView(),
            EditView(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
