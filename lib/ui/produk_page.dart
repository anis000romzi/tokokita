import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  DateTime timeBackPressed = DateTime.now();
  final List imagelist = [
    ['lib/images/BLACKFOREST.jpg', 'Black Forest'],
    ['lib/images/LAVACAKE.jpeg', 'Lava Cake'],
    ['lib/images/BROWNIES.jpg', 'Brownies'],
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= Duration(seconds: 2);

          timeBackPressed = DateTime.now();

          if (isExitWarning) {
            final message = 'Tekan sekali lagi untuk keluar';
            Fluttertoast.showToast(msg: message, fontSize: 18);

            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Toko Kue'),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Logout'),
                  trailing: Icon(Icons.logout),
                  onTap: () async {
                    await LogoutBloc.logout().then((value) {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => LoginPage()));
                    });
                  },
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Center(
                  child: Text('Selamat Datang!',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
              Center(child: Text('Kue Rekomendasi hari ini adalah...\n')),
              CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: imagelist
                    .map((e) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Container(
                                width: 116.0,
                                height: 174.0,
                                foregroundDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0, 0.2, 0.8, 1],
                                  ),
                                ),
                                child: Image.asset(
                                  e[0],
                                  width: 1050,
                                  height: 350,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    e[1],
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Center(
                  child: Text('\nDaftar Kue',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
              ItemProduk(
                  produk: Produk(
                      namaProduk: 'Black Forest',
                      hargaProduk: 60000,
                      deskripsiProduk: 'Kue lezat dengan krim yang lembut',
                      image: 'lib/images/BLACKFOREST.jpg')),
              ItemProduk(
                  produk: Produk(
                      namaProduk: 'Lava Cake',
                      hargaProduk: 70000,
                      deskripsiProduk: 'Kue coklat dengan isi coklat melimpah',
                      image: 'lib/images/LAVACAKE.jpeg')),
              ItemProduk(
                  produk: Produk(
                      namaProduk: 'Brownies',
                      hargaProduk: 42000,
                      deskripsiProduk: 'Kue coklat dengan taburan choco cips',
                      image: 'lib/images/BROWNIES.jpg')),
            ],
          ),
        ));
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  ItemProduk({this.produk});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ProdukDetail(
                            produk: produk,
                          )));
            },
            child: Card(
              child: ListTile(
                title: Text(produk.namaProduk),
                subtitle: Text("Rp. ${produk.hargaProduk.toString()}"),
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 100,
                    minHeight: 100,
                    maxWidth: 100,
                    maxHeight: 100,
                  ),
                  child: new Image.asset(produk.image, fit: BoxFit.cover),
                ),
              ),
            )));
  }
}
