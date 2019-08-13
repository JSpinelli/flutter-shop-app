import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/user.dart';

import '../providers/categories.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(3),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: _form,
                      child: Expanded(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              textInputAction: TextInputAction.next,
                              onSaved: (_) {},
                              onFieldSubmitted: (_) {},
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Surname'),
                              textInputAction: TextInputAction.next,
                              onSaved: (_) {},
                              onFieldSubmitted: (_) {},
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Adress'),
                              onSaved: (_) {},
                              onFieldSubmitted: (_) {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(3),
              elevation: 5,
              child: Container(
                  height: 350,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Choose your favorite categories',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: GridView.builder(
                              itemBuilder: (ctx, index) {
                                var name =
                                    Categories.categories.keys.toList()[index];
                                var icon = Categories.categories.values
                                    .toList()[index];
                                return GridTile(
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          icon,
                                          color: userData.isFavorite(name)
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(name),
                                    ],
                                  ),
                                );
                              },
                              itemCount: Categories.categories.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, //Amount of Columns to have
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
