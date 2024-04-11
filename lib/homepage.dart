import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'stock.dart'; // Import stock.dart file to access StockPage widget
import 'package:stockmarket/gainer.dart';
import 'loser.dart';
import 'news.dart';
import 'newspage.dart';
import 'stockchart.dart';
import 'tradebuy.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Center(
          child: Text(
            'Jasmincron Stock Trading App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Center(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white10,
                ),
                accountName: Text(''),
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://scontent.fmnl25-4.fna.fbcdn.net/v/t1.15752-9/434754619_418760264096521_2024454011896680576_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEEEpMi1Ixsf3y8SUKtcGvnf2PZc-R1Q65_Y9lz5HVDrmvuBoborH-5veiSNxhOEXBiflq5dqq12JonZylWNKqt&_nc_ohc=--4dtUrqGUkAb7HwVg0&_nc_ht=scontent.fmnl25-4.fna&oh=03_AdXw3kGilWnykjrZlYz8u5N6kjs0O79HKxbegGOE7Hm3iw&oe=663DEB23'),
                ),
              ),
            ),
            ListTile(
              title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold),),

              onTap: () {
                // Navigate to the home page
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigate to the quote page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockPage()), // Navigate to the StockPage
                );
              },
            ),
            ListTile(
              title: Text('News', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigate to the news page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Top Gainers', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigate to the news page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GainerPage(gainerList: [],)),
                );
              },
            ),
            ListTile(
              title: Text('Loss Gainers', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigate to the news page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoserPage()),
                );
              },
            ),
            ListTile(
              title: Text('Buying Records', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigate to the news page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TradeBuy()),
                );
              },
            ),
            ListTile(
              title: Text('Members', style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Jasmincron Group Members"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://scontent.fmnl25-4.fna.fbcdn.net/v/t1.15752-9/436013295_256914790831657_1885363458409712270_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeG3yDJMahebjgz-yI5OsGkZtCEIIciLOKm0IQghyIs4qfvl7DduQ-pThRw5H6mhPX5W_dPvmn6rE4DpiVbWpC2-&_nc_ohc=_z8LMYtMRhEAb42E4Uu&_nc_ht=scontent.fmnl25-4.fna&oh=03_AdU1CDGMnmYnaGvLxe0Av5PK3vrTuAjjwXGWEVyrR-BquA&oe=663E212D',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Turla, Marc Emerson B."),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://scontent.fmnl25-3.fna.fbcdn.net/v/t1.15752-9/435564077_2444455735765089_1088248525579511601_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGn_g--rUk2y3e86tSDJbEHXJGH9WYWhEZckYf1ZhaERkSPf-fhf1rR-u7x4x3cGy4uPMsqAzhfCzGhvnSVRpxN&_nc_ohc=hA7E78ELZEEAb4TxvDn&_nc_ht=scontent.fmnl25-3.fna&oh=03_AdVa2sO4AzpAScGH7k-UOZ5m3Y8u2g2l5gprkFKHLDaGKg&oe=663E2550',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Daquiz, Mark Angelo C."),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://scontent.fmnl25-4.fna.fbcdn.net/v/t1.15752-9/436770014_1151830272483927_4906224189007626885_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeFQf6htmvRT42uCYvC7bWFeOP5l5_81j8s4_mXn_zWPy7aJ2g8qXzNa0XwzTTlOns-gVI3GayxGVzEWZMct5Kai&_nc_ohc=q7vlHUjy0toAb4yIG8S&_nc_ht=scontent.fmnl25-4.fna&oh=03_AdWxwLpzu2Jlie3oJi42brAtQc2CNZhwcW_sexrJiTogZg&oe=663E1085',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Dullas, Rustine A."),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://scontent.fmnl25-5.fna.fbcdn.net/v/t1.15752-9/420657277_953985423109874_1447991814896513781_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEd16YEGlodKGkIKUd4FASiJxgJ4ZUWpHknGAnhlRakeWw5tkU7dCoIwF4ocJtqAKJk3OKUMfvefs9ykMQ3gf0l&_nc_ohc=CY7j93p0nZ0Ab7yz6OI&_nc_ht=scontent.fmnl25-5.fna&oh=03_AdXmsD6gE7skLvmQhqIpzNcCijhUMQxQwNdj4x_WleZmnw&oe=663E0615',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Ingal, Jasper O"),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              'https://scontent.fmnl25-5.fna.fbcdn.net/v/t1.15752-9/435251104_451744080543729_8694999809033777377_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeF5rtWkPenMYMB6XtuCeBalX7W_B1_Bx3tftb8HX8HHe98WRtuWOs1cHqbYeuA9zUox_Hbf1v7gzlIEwrQenYS3&_nc_ohc=DalWz7V7KPMAb6EeLjr&_nc_ht=scontent.fmnl25-5.fna&oh=03_AdVMVRXjQNa19z-yzTCIUIFJhDfCMec8ZO4x05Xouwm_Vw&oe=663E1D78',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Lim, Criss Paolo H."),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),


          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: [
                // Wrap Image.network with Container to specify height and width
                Container(
                  child: Image.network(
                    'https://www.entrepreneurshipinabox.com/wp-content/uploads/A-Basic-Guide-To-Stock-Trading.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Image.network(
                    'https://cdn.educba.com/academy/wp-content/uploads/2016/07/Stock-Market-Trading.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Image.network(
                    'https://img.freepik.com/premium-photo/stock-market-forex-trading-graph-graphic-concept_73426-96.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
