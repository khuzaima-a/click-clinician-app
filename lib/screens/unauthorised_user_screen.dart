import 'package:clickclinician/widgets/shared.dart';
import 'package:flutter/material.dart';
import '../shared/api_calls.dart';

class UnauthorisedUserScreen extends StatefulWidget {
  static const String routeName = "/unuthorisedUserScreen";
  const UnauthorisedUserScreen({super.key});

  @override
  State<UnauthorisedUserScreen> createState() => _UnauthorisedUserScreenState();
}

class _UnauthorisedUserScreenState extends State<UnauthorisedUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 2,
              ),
              const Text(
                'Oops! Looks like you are not a clinician.',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 28.0,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Please check the website to access the Click Clinician portal',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16.0,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ApiCalls.logout(context, 'unauthorised screen');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
