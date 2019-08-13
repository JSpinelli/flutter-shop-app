import 'package:flutter/material.dart';

import '../providers/categories.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(3),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(
                        'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                        height: 150,
                        width: 150,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      )
                    ],
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
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Surname'),
                            textInputAction: TextInputAction.next,
                            onSaved: (_) {},
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Adress'),
                            onSaved: (_) {},
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
                height: 400,
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
                        child: GridView.builder(
                          itemBuilder: (ctx, index) {
                            return GridTile(
                              child: Column(
                                children: <Widget>[
                                  Categories.categories.values.toList()[index],
                                  Text(
                                      Categories.categories.keys.toList()[index]),
                                ],
                              ),
                            );
                          },
                          itemCount: Categories.categories.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, //Amount of Columns to have
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
