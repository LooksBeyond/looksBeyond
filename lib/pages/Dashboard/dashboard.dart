import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looksbeyond/models/brand.dart';
import 'package:looksbeyond/models/logged_in_user.dart';
import 'package:looksbeyond/pages/Booking/booking.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/BrandsNearBy.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/CategoryList.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/RecentlyViewedShops.dart';
import 'package:looksbeyond/pages/FAQ/FAQScreen.dart';
import 'package:looksbeyond/pages/Profile/Profile.dart';
import 'package:looksbeyond/pages/Search/searchScreen.dart';
import 'package:looksbeyond/provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class BottomNavBarScreen extends StatefulWidget {
  static const String pageName = '/dashboard';

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
  late AuthenticationProvider authenticationProvider;
  late LoggedInUser loggedInUser;
  List<Brand> ClientList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    loggedInUser = authenticationProvider.loggedInUser!;
  }

  @override
  Widget build(BuildContext context) {
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
                "Hi, ${loggedInUser.name}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SearchScreen.pageName);
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
              // Text("Recently Viewed"),
              // SizedBox(height: 10.0),
              // SizedBox(
              //   height: 100,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: ClientList.length,
              //     itemBuilder: (context, index) {
              //       return RecentlyViewedDashboard(client: ClientList[index]);
              //     },
              //   ),
              // ),
              SizedBox(height: 20.0),
              Text("Popular Brands"),
              SizedBox(height: 10.0),
              //TODO: GET FROM FIREBASE
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('brands').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  List<Brand> brands = snapshot.data!.docs.map((doc) {
                    return Brand.fromFirebase(doc);
                  }).toList();

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    children: brands
                        .map((brand) => BrandsNearBy(brand: brand))
                        .toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
