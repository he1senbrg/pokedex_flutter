import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';


import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:m3_carousel/m3_carousel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'PokemonDetails.dart';

var pageIndex = 0;
var isDrawerSelected = [true,false,false];

List<int> rPoke= [];

void main() {
  while (rPoke.length <= 10) {
    int rNum = Random().nextInt(1025) + 1;
    if (rPoke.contains(rNum) == false) {
      rPoke.add(rNum);
    }
  }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'No !dea',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'No !dea'),
    );
  }
}





class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> images = [
      { "image": "assets/images/n1.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
      { "image": "assets/images/n2.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
      { "image": "assets/images/n3.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
      { "image": "assets/images/n4.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
      { "image": "assets/images/n5.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
      { "image": "assets/images/n6.jpg", "title": "" ,"link" : "https://tcg.pokemon.com/assets/img/home/wallpapers/wallpaper-55.jpg"},
    ];


    List<String> pNames = ["Pikachu","Charmander","Lucario","Ditto","Bulbasaur"];

    final FocusScopeNode focusNode = FocusScopeNode();
    bool didJustDismiss = false;



    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        isDrawerSelected[0] = true;
        isDrawerSelected[1] = false;
        isDrawerSelected[2] = false;
        return Scaffold(
          resizeToAvoidBottomInset: false,
            // drawerScrimColor: Colors.transparent,
            backgroundColor: const Color(0x00171717),
            appBar: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: const Color(0x00171717),
                automaticallyImplyLeading: true,
                title :
                FocusScope(
                node: focusNode,
                onFocusChange: (isFocused) {
                if (didJustDismiss && isFocused) {
                didJustDismiss = false;
                focusNode.unfocus();
                }
                },
                    child:
                    SearchBar(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                          return const Color(0xff1b1e1e);
                        }
                        return const Color(0xff1b1e1e);

                      }),
                      shape: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        );

                      }),
                      hintText: 'Search Pokédex',
                      leading: const Icon(Icons.search),
                      onSubmitted: (String value) {
                        PokemonDetails p1 = PokemonDetails(value);
                        p1.fetchData().then((value2) {
                          int pId = value2['id'];
                          String pName = value2['name'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsPage(title: "Details",idNum: pId.toInt())),
                          );
                        });
                      },
                    ),
                ),

            ),

            drawer:
                const CustomDrawer(),

            body:
              SizedBox(
                  height: MediaQuery.of(context).size.height - 50,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(margin: const EdgeInsets.only(left: 10,top: 20),child: const Text("Wallpapers",style: TextStyle(fontSize: 30),),),
                          Container(
                            margin: const EdgeInsets.only(top: 5,bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: M3Carousel(
                              autoSlide: true,
                              autoPlayDelay: 5000,
                              trailingChildWidth: 80,
                              visible: 2,
                              height: 200,
                              borderRadius: 20,
                              slideAnimationDuration: 300,
                              titleFadeAnimationDuration: 300,
                              children: images,
                            ),
                          ),
                          Container(margin: const EdgeInsets.only(left: 10,bottom:5),child: const Text("Random",style: TextStyle(fontSize: 30),),),

                          SizedBox(
                            height: MediaQuery.of(context).size.height - 463,
                            child:
                            GridView.count(
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(10, (index) {
                                var img = rPoke[index] + 1;
                                return Center(
                                  child: GridItem(
                                    imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$img.png",
                                    title: img.toString(),
                                    page: DetailsPage(title: "Details",idNum: img,),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],))
              )
              ,
        );
      },
    );
  }
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Scaffold(
            backgroundColor: const Color(0x00171717),
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: const Color(0x00171717),
              title: const Text('Settings'),
            )
        );
      },
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();

}


class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top:30,bottom: 10,left: 10,right: 10),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child:
          Drawer(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),

              // backgroundColor: const Color(0xE61A1D1D),
              backgroundColor: const Color(0xFF17060D),
              child:
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top:5),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text("Pokédex",style: TextStyle(fontSize: 30),),
                    ),
                    const Divider(),
                    Expanded(child:
                    ListView(
                      padding: EdgeInsets.zero,
                      children:    const [
                        ListTile(
                          title: DrawerItem(
                            icon: Icons.home,
                            title: "Home",
                            page: MyHomePage(title: "Home"),
                            index: 0,
                          ),
                        ),
                        ListTile(
                          title: DrawerItem(
                            icon: Icons.all_inclusive,
                            title: "All",
                            page: AllPage(title: "All"),
                            index: 1,
                          ),
                        ),
                      ],
                    ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child:  Column(
                        children: [
                          const Divider(),
                          ListTile(
                              title: ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text("Settings"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SettingsPage(title: "Settings")),
                                  );
                                },
                              )
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              )
          ),),),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key, required this.icon, required this.title, required this.page , required this.index});

  final IconData icon;
  final String title;
  final StatefulWidget page;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (pageIndex != index) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );

          for (var i = 0; i < isDrawerSelected.length; i++) {
            if (i == index) {
              isDrawerSelected[i] = true;
            } else {
              isDrawerSelected[i] = false;
            }
          }

          pageIndex = index;
        }
      },
    );
  }
}

/*
  return MaterialButton(
      height: 45,
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      onPressed: () {
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child:  Row(
        children: [
          Icon(icon),
          Container(margin: const EdgeInsets.only(left: 20),child: Text(title,style: const TextStyle(fontSize: 20),),)
        ],
      ),
    );
*/

class AllPage extends StatefulWidget {
  const AllPage({super.key, required this.title});

  final String title;


  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {

  List<String> pNames = ["Pikachu","Charmander","Lucario","Ditto","Bulbasaur"];

  final FocusScopeNode focusNode = FocusScopeNode();
  bool didJustDismiss = false;

  @override
  Widget build(BuildContext context) {

    isDrawerSelected[0] = false;
    isDrawerSelected[1] = true;
    isDrawerSelected[2] = false;



    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Scaffold(
            backgroundColor: const Color(0x00171717),
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: const Color(0x00171717),
            automaticallyImplyLeading: true,
            title :
            FocusScope(
                node: focusNode,
                onFocusChange: (isFocused) {
                  if (didJustDismiss && isFocused) {
                    didJustDismiss = false;
                    focusNode.unfocus();
                  }
                },
                child:
                 const Text("All",style: TextStyle(fontSize: 20),),

          ),
          ),

          drawer:
            const CustomDrawer(),

          body:
              Container(
                margin: const EdgeInsets.only(top: 10),
                child:
                GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(1025, (index) {
                    var img = index + 1;
                    return Center(
                      child: GridItem(
                        imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$img.png",
                        title: '$img',
                        page: DetailsPage(title: "nothing",idNum: img,),
                      ),
                    );
                  }),
                ),
              )
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.imgUrl, required this.title, required this.page});

  final String imgUrl;
  final String title;
  final StatefulWidget page;

  @override
  Widget build(BuildContext context) {
    PokemonDetails p1 = PokemonDetails(title.toString());

    return FutureBuilder(
        future: p1.fetchData(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Map<String, dynamic>? pData = snapshot.data;
            String pName = pData!['forms'][0]['name'];
            return MaterialButton(
              color: const Color(0xFF151515),
              minWidth: 230,
              shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              child:  Column(
                children: [
                  Hero(
                    tag: imgUrl,
                    child:
                    Image.network(imgUrl),
                  ),
                  Container(child: Text(pName.toUpperCase(),style: const TextStyle(fontSize: 11),),)
                ],
              ),
            );
          } else {
            return const Text('No data available');
          }
        }
    );
  }
}


class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.title, required this.idNum});

  final String title;
  final int idNum;


  @override
  State<DetailsPage> createState() => _DetailsPageState();


}

class _DetailsPageState extends State<DetailsPage> {
  int idNum = 0;

  @override
  void initState() {
    super.initState();
    idNum = widget.idNum;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        PokemonDetails p1 = PokemonDetails(idNum.toString());

        return FutureBuilder<Map<String, dynamic>>(
          future: p1.fetchData(), // This returns a Future<Map<String, dynamic>>
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading, show a loading indicator
              return Scaffold(
                backgroundColor: const Color(0x00171717),
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: const Color(0x00171717),
                  title: const Text('Details'),
                ),
                body:
                SizedBox(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 250,
                                child: Hero(
                                  tag: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png",
                                  child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png"),
                                ),
                              ),
                              const Center(child: CircularProgressIndicator()),
                            ]
                        )
                    )
                ),
              );
            } else if (snapshot.hasError) {
              // If there's an error, show an error message
              return Scaffold(
                backgroundColor: const Color(0x00171717),
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: const Color(0x00171717),
                  title: const Text('Details'),
                ),
                body:
                SizedBox(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        SizedBox(
                        height: 250,
                        child: Hero(
                          tag: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png",
                          child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png"),
                        ),
                      ),
                      Center(child: Text('Error: ${snapshot.error}')),
                      ]
                      )
                    )
                ),
              );
            } else if (snapshot.hasData) {
              // If the future completed successfully, use the data
              Map<String, dynamic>? pData = snapshot.data;
              String pName = pData!['forms'][0]['name'];
              String weight = pData['weight'].toString();
              String height = pData['height'].toString();

              String abilities = "";
              for (var ability in pData['abilities']) {
                abilities += (ability['ability']['name']);
                if (ability != pData['abilities'].last) {
                  abilities += ', ';
                }
              }

              String types = '';
              for (var type in pData['types']) {
                types += (type['type']['name']);
                if (type != pData['types'].last) {
                  types += ', ';
                }
              }

              Map<String,int> stats = {};
              for (var stat in pData['stats']) {
                stats[stat['stat']['name']] = stat['base_stat'];
              }

              List<String> moves = [];
              for (var move in pData['moves']) {
                moves.add(move['move']['name']);
              }

              print(stats);

              return Scaffold(
                backgroundColor: const Color(0x00171717),
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: const Color(0x00171717),
                  title: const Text('Details'),
                ),
                body: SizedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          child: Hero(
                            tag: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png",
                            child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$idNum.png"),
                          ),
                        ),Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(pName.toUpperCase(), style: const TextStyle(fontSize: 30)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          decoration: BoxDecoration(
                            color: const Color(0x802b2b2b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: () {
                                List<Widget> widgets = [];
                                for (var stat in stats.keys) {
                                  widgets.add(Container(
                                    margin: const EdgeInsets.all(5),
                                    child:
                                    CircularPercentIndicator(
                                      arcType: ArcType.FULL,
                                      radius: 40.0,
                                      lineWidth: 7.0,
                                      animation: true,
                                      animationDuration: 500,
                                      percent: (stats[stat]! / 255) ,
                                      center:  Text(stats[stat].toString(), style: const TextStyle( fontSize: 20.0),),
                                      footer: Text(stat.toUpperCase(), style: const TextStyle( fontSize: 12.0),),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      arcBackgroundColor: const Color(0x802b2b2b),

                                    ),
                                  ));
                                }
                                return widgets;
                              }(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0x802b2b2b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child:  Text('Height : $height', style: const TextStyle(fontSize: 20)),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                child:  Text('Weight : $weight', style: const TextStyle(fontSize: 20)),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                child:  Text('Types : $types', style: const TextStyle(fontSize: 20)),
                              ),
                              Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Text('Abilities : $abilities', style: const TextStyle(fontSize: 20)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          decoration: BoxDecoration(
                            color: const Color(0x802b2b2b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                  children: () {
                                    List<Widget> widgets = [];
                                    for (var move in moves) {
                                      widgets.add(Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF17060D),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(5),
                                          child:
                                          Text(move, style: const TextStyle(fontSize: 20))
                                      ));
                                    }
                                    return widgets;
                                  }(),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // Handle other cases, although unlikely
              return Scaffold(
                backgroundColor: const Color(0x00171717),
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: const Color(0x00171717),
                  title: const Text('Details'),
                ),
                body: Center(child: Text('No data available')),
              );
            }
          },
        );
      },
    );
  }
}



class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key, required this.title});

  final String title;


  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  List<String> pNames = ["Pikachu","Charmander","Lucario","Ditto","Bulbasaur"];

  final FocusScopeNode focusNode = FocusScopeNode();
  bool didJustDismiss = false;

  @override
  Widget build(BuildContext context) {

    isDrawerSelected[0] = false;
    isDrawerSelected[1] = false;
    isDrawerSelected[2] = true;


    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Scaffold(
            backgroundColor: const Color(0x00171717),
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: const Color(0x00171717),
              automaticallyImplyLeading: true,
              title :
              FocusScope(
                  node: focusNode,
                  onFocusChange: (isFocused) {
                    if (didJustDismiss && isFocused) {
                      didJustDismiss = false;
                      focusNode.unfocus();
                    }
                  },
                  child:
                  SearchAnchor.bar(
                    barShape: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        );
                      }
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      );

                    }),

                    viewShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    viewConstraints: const BoxConstraints(minHeight: 100, maxHeight: 400,),
                    barHintText: 'Search Favourites',
                    barBackgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xff1b1e1e);
                      }
                      return const Color(0xff1b1e1e);
                    }),
                    viewBackgroundColor: const Color(0xff1b1e1e),
                    isFullScreen: false,
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<Widget>.generate(
                        5,
                            (int index) {
                          return ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            title: Text(pNames[index]),
                            onTap: () {
                              didJustDismiss = true;
                              controller.closeView(null);
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      );
                    },)),

            ),

            drawer:
            const CustomDrawer(),

            body:
            Container(
              margin: const EdgeInsets.only(top: 10),
              child:
              GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(10, (index) {
                  var img = index + 1;
                  return Center(
                    child: GridItem(
                      imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$img.png",
                      title: '$img',
                      page: DetailsPage(title: "nothing",idNum: img,),
                    ),
                  );
                }),
              ),
            )
        );
      },
    );
  }
}
