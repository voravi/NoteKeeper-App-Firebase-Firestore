import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper_app_firebase_miner2/helpers/firebase_cloud_helper.dart';
import 'package:notekeeper_app_firebase_miner2/utils/colours.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String title = "";
  String desc = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateDescController = TextEditingController();

  GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();


  // Future<List<Student>>? stuData;

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   stuData = StudentHelper.studentHelper.fetchAllData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text("Note Keeper"),
      ),
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () async {
          insertNoteData(context);
        },
        child: const Icon(Icons.add),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseCloudHelper.firebaseCloudHelper.fetchAllData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;

            return ListView.builder(
              itemCount: queryDocumentSnapshot.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;
                //image = base64Decode(data['image']);
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: Text("${i+1}"),
                    title: Text("${data["title"]}",style: TextStyle(fontSize: 17),),
                    subtitle: Text("${data["desc"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            updateData(context, id: queryDocumentSnapshot[i].id, updateTitle: data["title"], updateDesc: data["desc"]);
                          },
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                           deleteOneData(id: queryDocumentSnapshot[i].id);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  insertNoteData(BuildContext context) {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Insert Record"),
            content: Form(
              key: insertFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter title first";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          title = val!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                        hintText: "Enter title",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: descController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter description";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          desc = val!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                        alignLabelWithHint: true,
                        hintText: "Enter Description...",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(

                onPressed: () async {
                  if (insertFormKey.currentState!.validate()) {
                    insertFormKey.currentState!.save();

                    log(title, name: "title");
                    log(desc, name: "description");

                    await FirebaseCloudHelper.firebaseCloudHelper.insertData(title: title,desc: desc);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Failed To Add data"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  titleController.clear();
                  descController.clear();

                  setState(() {
                    title = "";
                    desc = "";
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                child: const Text("save"),
              ),
              OutlinedButton(
                onPressed: () {
                  titleController.clear();
                  descController.clear();

                  setState(() {
                    title = "";
                    desc = "";
                  });

                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          );
        });
  }

  updateData(BuildContext context, {required String id, required String updateTitle, required String updateDesc}) {
    updateTitleController.text = updateTitle;
    updateDescController.text = updateDesc;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Record"),
            content: Form(
              key: updateFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextFormField(
                      controller: updateTitleController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter title";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          title = val!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                        hintText: "Enter title",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: updateDescController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter description";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          desc = val!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                        alignLabelWithHint: true,
                        hintText: "Enter description...",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (updateFormKey.currentState!.validate()) {
                    updateFormKey.currentState!.save();

                    await FirebaseCloudHelper.firebaseCloudHelper.updateData(id: id, title: title,desc: desc);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Failed To Update data"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  updateTitleController.clear();
                  updateDescController.clear();

                  setState(() {
                    title = "";
                    desc = "";
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
              OutlinedButton(
                onPressed: () {
                  updateTitleController.clear();
                  updateDescController.clear();

                  setState(() {
                    title = "";
                    desc = "";
                  });

                  Navigator.pop(context);
                },
                child: const Text("cancel"),
              ),
            ],
          );
        });
  }

  deleteOneData({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text(
          "Are you sure to delete this data permanently",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {
              FirebaseCloudHelper.firebaseCloudHelper.deleteData(deleteId: id);

              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
