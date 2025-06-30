import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdv0/partnership_desk.dart';
import 'package:pdv0/src/registration_widget.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PGBC Partnership Desk')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Main Menu')),
            ListTile(
              title: Text('Schedule'),
              onTap: () {
                context.pushReplacement('/schedule');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          //Text("Here's some homepage text."),
          Consumer<ApplicationState>(
            builder:
                (context, appState, _) => AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
          ),
          Consumer<ApplicationState>(
            builder:
                (context, appState, _) => Visibility(
                  visible: appState.loggedIn,
                  child: PartnershipDesk(
                    loggedIn: appState.loggedIn,
                    registerForPartner:
                        (gameTime) =>
                            appState.addPlayerLookingForPartner(gameTime),
                    deregisterForPartner: () => appState.deregister(),
                    registerWithPartner:
                        (gameTime, pname) =>
                            appState.addPlayerWithPartner(gameTime, pname),
                    upcomingGameDate: appState.getUpcomingDayAsString(2),
                    isRegistered: (gameTime, name) => appState.isRegistered(gameTime, name),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
