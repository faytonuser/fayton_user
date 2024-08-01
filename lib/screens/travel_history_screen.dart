import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/models/request_model.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/driver_profile_screen.dart';
import 'package:userapp/widgets/profile_menu.dart';

class TravelHistoryScreen extends StatefulWidget {
  const TravelHistoryScreen({super.key});

  @override
  State<TravelHistoryScreen> createState() => _TravelHistoryScreenState();
}

class _TravelHistoryScreenState extends State<TravelHistoryScreen> {
  @override
  void initState() {
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var requestProvider = Provider.of<RequestProvider>(context);
    return Scaffold(
        body: ListView.builder(
      itemCount: requestProvider.requestList.length,
      itemBuilder: (context, index) {
        if(requestProvider.requestList.isEmpty){
          return Center(child: Text("Səyahət tapılmadı"),);
        }
        return ProfileMenu(
          text: requestProvider.requestList[index].fromLocation +
              " - " +
              requestProvider.requestList[index].toLocation,
          icon: "assets/icons/Location point.svg",
          fromHistory: true,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DriverProfileScreen(
                    driverId: requestProvider.requestList[index].driverId),
              ),
            );
          },
        );
      },
    ));
  }
}
