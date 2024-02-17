import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looksbeyond/models/clients.dart';
import 'package:looksbeyond/pages/Booking/booking.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/BrandsNearBy.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/CategoryList.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/RecentlyViewedShops.dart';
import 'package:looksbeyond/pages/FAQ/FAQScreen.dart';
import 'package:looksbeyond/pages/Profile/Profile.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    BookingScreen(),
    Profile(),
    FAQScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        fixedColor: Color(0xFFfbab66),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            activeIcon: Icon(Icons.space_dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            activeIcon: Icon(Icons.question_answer),
            label: 'FAQs',
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Client> ClientList = [
    Client(
      name: 'Client A',
      address: 'Address of Client A',
      imageUrl:
          'https://www.emotivebrand.com/wp-content/uploads/2016/09/tumblr_o05v3eZmyT1ugn1wu_og_1280-1080x675.png',
    ),
    Client(
      name: 'Client B',
      address: 'Address of Client B',
      imageUrl:
          'https://www.emotivebrand.com/wp-content/uploads/2016/09/tumblr_o05v3eZmyT1ugn1wu_og_1280-1080x675.png',
    ),
    Client(
      name: 'Client C',
      address: 'Address of Client C',
      imageUrl:
          'https://www.emotivebrand.com/wp-content/uploads/2016/09/tumblr_o05v3eZmyT1ugn1wu_og_1280-1080x675.png',
    ),
    Client(
      name: 'Client D',
      address: 'Address of Client D',
      imageUrl:
          'https://www.emotivebrand.com/wp-content/uploads/2016/09/tumblr_o05v3eZmyT1ugn1wu_og_1280-1080x675.png',
    ),
    Client(
      name: 'Client E',
      address: 'Address of Client E',
      imageUrl:
          'https://www.emotivebrand.com/wp-content/uploads/2016/09/tumblr_o05v3eZmyT1ugn1wu_og_1280-1080x675.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String? userEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/img/login_logo_black.svg',
          height: 50,
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                "Hi, user name",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("/search");
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.search,
                          ),
                        ),
                        Text(
                          "Search for services",
                          style: TextStyle(fontSize: 17, color: Colors.black38),
                        ),
                      ],
                    ),
                  )),

              /// TODO: FILTERS
              SizedBox(height: 20.0),
              Text("Categories"),
              SizedBox(height: 10.0),
              CategoryList(),
              SizedBox(height: 20.0),
              Text("Recently Viewed"),
              SizedBox(height: 10.0),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ClientList.length,
                  itemBuilder: (context, index) {
                    return RecentlyViewedDashboard(client: ClientList[index]);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Text("Popular Brands Nearby"),
              SizedBox(height: 10.0),
              //TODO: GET FROM FIREBASE
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(),
                children:
                    ClientList.map((client) => BrandsNearBy(client: client))
                        .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
