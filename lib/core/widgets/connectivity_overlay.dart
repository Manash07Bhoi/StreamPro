import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity_bloc.dart';
import 'package:lottie/lottie.dart';

class ConnectivityOverlay extends StatelessWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Back Online ✓',
                  style: TextStyle(fontFamily: 'Poppins')),
              backgroundColor: AppColors.colorSuccess,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            child,
            if (state is ConnectivityOffline)
              Positioned.fill(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.95),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/offline_state.json',
                          height: 200,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.wifi_off,
                                  size: 80, color: AppColors.colorError),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No Internet Connection',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Check your connection and try again.',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppColors.colorTextSecondary),
                        ),
                        const SizedBox(height: 32),
                        OutlinedButton(
                          onPressed: () {
                            // The BLoC auto monitors, but user might want a manual refresh feel
                            context
                                .read<ConnectivityBloc>()
                                .add(StartMonitoring());
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: AppColors.colorPrimary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Try Again',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
