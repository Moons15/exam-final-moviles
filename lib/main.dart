import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_exam_final/models/hero.dart';
import 'package:flutter_exam_final/data/moor_database.dart';
import 'package:flutter_exam_final/data/hero_http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => Database()),
          Provider(create: (_) => SuperHeroHTTP()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SuperHero> heroes;
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Barra de búsqueda');
  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _initList(this.context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (this.visibleIcon.icon == Icons.search) {
                  this.visibleIcon = Icon(Icons.cancel);
                  this.searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    onSubmitted: (String text) {
                      _search(text, context);
                    },
                  );
                } else {
                  this.visibleIcon = Icon(Icons.search);
                  this.searchBar = Text('Barra de búsqueda');
                  //Listamos los datos por defecto
                  _initList(context);
                }
              });
            },
          )
        ],
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favourite'),
          ),
        ],
      ),
    );
  }

  Future _initList(BuildContext context) async {
    final httpHero = Provider.of<SuperHeroHTTP>(context);
    print("List Init");
    heroes = List();
    List<SuperHero> temp = await httpHero.allHeroes(http.Client());
    print("After getList");
    setState(() {
      heroes = temp;
      print('setState-list');
    });
    print("Countries size init: " + heroes.length.toString());
  }

  Future _search(String text, BuildContext context) async {
    final httpHero = Provider.of<SuperHeroHTTP>(context);
    print("Busqueda init");
    SuperHero searchTemp = await httpHero.findHero(text);
    setState(() {
      heroes = List();
      heroes.add(searchTemp);
    });
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context);

    if (_selectedIndex == 0) {
      return Column(
        children: [
          Container(),
          SizedBox(height: 8.0),
          Expanded(child: _HeroList(heroes: heroes, database: database))
        ],
      );
    } else {
      return StreamBuilder(
          stream: database.watchAllHeroes,
          builder: (context, AsyncSnapshot<List<HeroDB>> snapshot) {
            final countriesDB = snapshot.data ?? List();

            if (countriesDB.length == 0)
              return Center(
                child: Text('Sin favoritos'),
              );
            return _FavouriteList(favourites: countriesDB, database: database);
          });
    }
  }
}

class _SuperHeroesList extends StatelessWidget {
  final List<SuperHero> heroes;
  final Database database;

  _SuperHeroesList({Key key, this.heroes, this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        return _buildRow(heroes[index], context);
      },
    );
  }

  Widget _buildRow(SuperHero hero, BuildContext context) {
    final heroDB = HeroDB(
      hero: hero.id,
      name: hero.name,
    );

    return StreamBuilder(
        stream: database.getHero(heroDB.hero),
        builder: (context, AsyncSnapshot<HeroDB> snapshot) {
          final snapshotDB = snapshot.data ?? null;
          return Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: ListTile(
                  // leading: Image.asset('assets/world.png'),
                  title: Text(hero.name),
                  subtitle: Text('ID: ' +
                      hero.id.toString() +
                      " | " +
                      "Name: " +
                      hero.name.toString() +
                      " | "),
                  trailing: IconButton(
                    icon: Icon(snapshotDB == null
                        ? Icons.favorite_border
                        : Icons.favorite),
                    onPressed: () {
                      database
                          .addHero(heroDB)
                          .then((value) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(hero.name +
                                      ' registrado como favorito'))))
                          .catchError((e) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Elemento ya se encuentra en la lista de favoritos'))));
                    },
                  )),
            ),
          );
        });
  }
}

class _HeroList extends StatelessWidget {
  final List<SuperHero> heroes;
  final Database database;

  _HeroList({Key key, this.heroes, this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        return _buildRow(heroes[index], context);
      },
    );
  }

  Widget _buildRow(SuperHero hero, BuildContext context) {
    final heroDB = HeroDB(
      hero: hero.id,
      name: hero.name,
    );

    return StreamBuilder(
        stream: database.getHero(heroDB.hero),
        builder: (context, AsyncSnapshot<HeroDB> snapshot) {
          final snapshotDB = snapshot.data ?? null;
          return Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: ListTile(
                  // leading: Image.asset('assets/world.png'),
                  title: Text(hero.name),
                  subtitle: Text('ID: ' +
                      hero.id.toString() +
                      " | " +
                      "Name: " +
                      hero.name.toString() +
                      " | "),
                  trailing: IconButton(
                    icon: Icon(snapshotDB == null
                        ? Icons.favorite_border
                        : Icons.favorite),
                    onPressed: () {
                      database
                          .addHero(heroDB)
                          .then((value) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(hero.name +
                                      ' registrado como favorito'))))
                          .catchError((e) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Elemento ya se encuentra en la lista de favoritos'))));
                    },
                  )),
            ),
          );
        });
  }
}

class _FavouriteList extends StatelessWidget {
  final List<HeroDB> favourites;
  final Database database;

  _FavouriteList({Key key, this.favourites, this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        return _buildRow(favourites[index], context);
      },
    );
  }

  Widget _buildRow(HeroDB hero, BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
        child: ListTile(
            //leading: Image.asset('assets/world.png'),
            title: Text(hero.name),
            subtitle: Text('ID: ' +
                hero.hero.toString() +
                " | " +
                "Name: " +
                hero.name.toString() +
                " | "),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print("Borrando de la BD");
                database
                    .deleteHero(hero)
                    .then((value) => Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Se elimina ' + hero.name + ' de favoritos'))))
                    .catchError((e) => Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Error, nose pudo eliminar de la lista de favoritos'))));
              },
            )),
      ),
    );
  }
}
