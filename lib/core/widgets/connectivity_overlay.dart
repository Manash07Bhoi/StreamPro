import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity_bloc.dart';

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;
  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  OverlayEntry? _offlineOverlay;

  void _showOfflineOverlay() {
    if (_offlineOverlay != null) return;
    _offlineOverlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black87,
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
                const Icon(Icons.wifi_off, size: 80, color: Colors.white),
                const SizedBox(height: 24),
                Text('No Internet Connection', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text('Check your connection and try again.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
             ]
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_offlineOverlay!);
  }

  void _hideOfflineOverlay() {
    _offlineOverlay?.remove();
    _offlineOverlay = null;
  }

  void _showOnlineSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Back Online ✓'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          _showOfflineOverlay();
        } else if (state is ConnectivityOnline) {
          _hideOfflineOverlay();
          _showOnlineSnackbar();
        }
      },
      child: widget.child,
    );
  }
}
