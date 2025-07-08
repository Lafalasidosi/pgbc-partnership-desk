import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:pdv0/partnership_desk.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PGBC Partnership Desk')),
      body: Column(
        children: <Widget>[
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
                  child: Column(
                    children: [
                      PartnershipDesk(
                        registerForPartner:
                            (gameTime) =>
                                appState.addPlayerLookingForPartner(gameTime),
                        deregisterForPartner: () => appState.deregister(),
                        registerWithPartner:
                            (gameTime, pname) =>
                                appState.addPlayerWithPartner(gameTime, pname),
                        upcomingGameDate: appState.getUpcomingDayAsString(2),
                        registeredPlayers: appState.registeredPlayers,
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 85, 185, 63),
        unselectedItemColor: const Color.fromARGB(255, 93, 96, 92),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
        ]
      ),
    );
  }
}
