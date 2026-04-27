import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vpn_bloc.dart';

class VpnStatusScreen extends StatefulWidget {
  const VpnStatusScreen({super.key});

  @override
  State<VpnStatusScreen> createState() => _VpnStatusScreenState();
}

class _VpnStatusScreenState extends State<VpnStatusScreen> {
  final List<Map<String, String>> _countries = const [
    {'name': 'USA', 'flag': '🇺🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'Japan', 'flag': '🇯🇵'},
    {'name': 'Netherlands', 'flag': '🇳🇱'},
    {'name': 'UK', 'flag': '🇬🇧'},
  ];

  bool _canPop = false;

  void _safePop() {
    if (_canPop) return;
    HapticFeedback.selectionClick();
    setState(() {
      _canPop = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _safePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VPN Status'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _safePop,
          ),
        ),
        body: BlocBuilder<VpnBloc, VpnState>(
          builder: (context, state) {
            bool isConnected = state is VpnConnected;
            bool isConnecting = state is VpnConnecting;
            String statusText = 'Disconnected';
            if (isConnected) statusText = 'Connected to ${(state).country}';
            if (isConnecting) statusText = 'Connecting...';

            return Column(
              children: [
                const SizedBox(height: 40),
                // Big Status Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isConnected ? Colors.green : Colors.grey,
                      width: 4,
                    ),
                    boxShadow: isConnected
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.security,
                    size: 80,
                    color: isConnected ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Enable / Disable Toggle & Auto Select
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Enable Free VPN',
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        value: isConnected || isConnecting,
                        activeThumbColor: const Color(0xFFC026D3),
                        onChanged: (val) {
                          if (val) {
                            context.read<VpnBloc>().add(AutoConnectVpnEvent());
                          } else {
                            context.read<VpnBloc>().add(DisconnectVpnEvent());
                          }
                        },
                      ),
                    ],
                  ),
                ),

                if (isConnecting)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Color(0xFFC026D3)),
                  ),

                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Available Locations',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Country List
                Expanded(
                  child: ListView.builder(
                    itemCount: _countries.length,
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      final isThisConnected =
                          isConnected && (state).country == country['name'];

                      return ListTile(
                        leading: Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(
                          country['name']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: isThisConnected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(Icons.wifi, color: Colors.white54),
                        onTap: () {
                          context.read<VpnBloc>().add(
                            ConnectVpnEvent(country: country['name']),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
