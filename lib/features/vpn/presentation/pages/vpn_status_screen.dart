import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vpn_bloc.dart';

class VpnStatusScreen extends StatelessWidget {
  const VpnStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<VpnBloc, VpnState>(
        builder: (context, state) {
          bool isConnected = state is VpnConnected;
          bool isConnecting = state is VpnConnecting;
          String statusText = 'Disconnected';
          if (isConnected) statusText = 'Connected to ${(state).country}';
          if (isConnecting) statusText = 'Connecting...';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 100,
                  color: isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  statusText,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                if (isConnecting)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected ? Colors.red : const Color(0xFFC026D3),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (isConnected) {
                        context.read<VpnBloc>().add(DisconnectVpnEvent());
                      } else {
                        context.read<VpnBloc>().add(ConnectVpnEvent());
                      }
                    },
                    child: Text(
                      isConnected ? 'Disconnect' : 'Quick Connect',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
