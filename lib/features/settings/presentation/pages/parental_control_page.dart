import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../blocs/settings_bloc.dart';
import 'package:go_router/go_router.dart';

class ParentalControlPage extends StatefulWidget {
  const ParentalControlPage({super.key});

  @override
  State<ParentalControlPage> createState() => _ParentalControlPageState();
}

class _ParentalControlPageState extends State<ParentalControlPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorText = '';

  void _onKeyPress(String digit) {
    setState(() {
      _errorText = '';
      if (!_isConfirming) {
        if (_pin.length < 4) {
          _pin += digit;
          if (_pin.length == 4) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                setState(() {
                  _isConfirming = true;
                });
              }
            });
          }
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += digit;
          if (_confirmPin.length == 4) {
            if (_pin == _confirmPin) {
              context.read<SettingsBloc>().add(EnableParentalControl(_pin));
              context.pop();
            } else {
              _errorText = 'PINs do not match. Try again.';
              _pin = '';
              _confirmPin = '';
              _isConfirming = false;
            }
          }
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      _errorText = '';
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Parental Controls', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is ParentalPinError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final config = sl<SettingsBloc>().state is SettingsLoaded
              ? (sl<SettingsBloc>().state as SettingsLoaded).config
              : (sl<SettingsBloc>().state is SettingsActionSuccess ? (sl<SettingsBloc>().state as SettingsActionSuccess).config : null);

          if (config == null) return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));

          if (config.parentalControlEnabled) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Color(0xFF10B981)),
                  const SizedBox(height: 16),
                  const Text('Parental Controls Active', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder for entering current PIN to disable
                      context.read<SettingsBloc>().add(DisableParentalControl(config.parentalPin));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                    child: const Text('Disable Parental Controls', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isConfirming ? 'Confirm PIN' : 'Enter a 4-digit PIN',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'This PIN will be required to watch R-rated content.',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final currentStr = _isConfirming ? _confirmPin : _pin;
                  final isFilled = index < currentStr.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? const Color(0xFFC026D3) : const Color(0xFF242424),
                    ),
                  );
                }),
              ),
              if (_errorText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(_errorText, style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFFEF4444))),
              ],
              const SizedBox(height: 64),
              _buildNumpad(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (j) {
              final digit = (i * 3 + j + 1).toString();
              return _buildDialButton(digit, () => _onKeyPress(digit));
            }),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80),
            _buildDialButton('0', () => _onKeyPress('0')),
            _buildDialButton('⌫', _onBackspace, isIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _buildDialButton(String label, VoidCallback onTap, {bool isIcon = false}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(shape: const CircleBorder()),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: isIcon ? const Color(0xFF9CA3AF) : Colors.white,
          ),
        ),
      ),
    );
  }
}
