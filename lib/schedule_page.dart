import 'package:flutter/material.dart';
import 'package:pdv0/partnership_desk.dart';
import 'src/widgets.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming games')),
      body: ListView(
        children: <Widget>[
          Consumer<ApplicationState>(
            builder:
                (context, appState, _) => Column(
                  children: [
                    if (appState.loggedIn) ...[
                      PartnershipDesk(
                        registerForPartner:
                            () => appState.addPlayerToPartnershipDesk(),
                        players: appState.players,
                        deregisterForPartner: () {},
                      ),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
