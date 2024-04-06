import 'package:flutter/material.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AuthorizationResult? _result;
  final solanaClient = SolanaClient(
    rpcUrl: Uri.parse("https://api.devnet.solana.com"),
    websocketUrl: Uri.parse("wss://api.devnet.solana.com"),
  );
  final int lamportsPerSol = 1000000000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Solana Flutter Example"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  /// step 1
                  final localScenario = await LocalAssociationScenario.create();

                  /// step 2
                  localScenario.startActivityForResult(null).ignore();

                  /// step 3
                  final client = await localScenario.start();

                  /// step 4
                  final result = await client.authorize(
                    identityUri: Uri.parse(
                        'https://solana.com'), // replace with your url
                    iconUri: Uri.parse(
                        'favicon.ico'), // replace with your icon (this has to be relative to the above URL)
                    identityName: 'Solana', // replace with your dapp name
                    cluster: 'devnet',
                  );

                  /// step 5
                  localScenario.close();

                  setState(() {
                    _result = result;
                  });
                },
                child: const Text("Authorize"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await solanaClient.requestAirdrop(
                      /// Ed25519HDPublicKey is the main class that represents public
                      /// key in the solana dart library
                      address: Ed25519HDPublicKey(
                        _result!.publicKey.toList(),
                      ),
                      lamports: 1 * lamportsPerSol,
                    );
                  } catch (e) {
                    print("$e");
                  }
                },
                child: const Text("Request Airdrop"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Generate and Sign Transactions"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
