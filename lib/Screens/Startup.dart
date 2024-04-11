import 'package:flutter/material.dart';
import 'package:m_yoga/Screens/rUready.dart';

import '../model/model.dart';
import '../services/yogadb.dart';

class Startup extends StatefulWidget {
  String Yogakey;
  YogaSummary yogaSum;
  Startup({required this.Yogakey, required this.yogaSum});

  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReadAllYoga();
  }

  late List<Yoga> AllYogaWorkOuts;
  bool isLoading =  true;
  Future ReadAllYoga() async {
    this.AllYogaWorkOuts =
        await YogaDatabase.instance.readAllYoga(widget.yogaSum.YogaWorkOutName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(body: Container(),) : Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => rUready(YogaTableName: widget.yogaSum.YogaWorkOutName,)));
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: const Text(
              "START",
              style: TextStyle(fontSize: 20),
            )),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: Text(widget.yogaSum.YogaWorkOutName),
              background: Image.asset(
                widget.yogaSum.BackImg.toString(),
                fit: BoxFit.cover,
              ),
            ),

          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.yogaSum.TimeTaken} Mins || ${widget.yogaSum.TotalNoOfWork} Workouts",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 2,
                          ),

                      itemBuilder: (context, index) => ListTile(
                            leading: Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  AllYogaWorkOuts[index].YogaImgUrl,
                                  fit: BoxFit.cover,
                                )),
                            title: Text(
                              AllYogaWorkOuts[index].YogaTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                             AllYogaWorkOuts[index].Seconds ? "00:${AllYogaWorkOuts[index].SecondsOrTimes}" : "x${AllYogaWorkOuts[index].SecondsOrTimes}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                      itemCount: AllYogaWorkOuts.length)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
