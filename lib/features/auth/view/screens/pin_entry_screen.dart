import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/auth/view/widgets/pin_entry/pin_pad.dart';
import 'package:ledger_app/features/auth/view/widgets/pin_entry/pin_pad_dots.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({
    required this.repeatCode,
    required this.onSubmit,
    this.onBack,
    this.onBiometrics,
    this.autoTriggerBiometrics = false,
    super.key,
  });

  final bool repeatCode;
  final FutureOr<bool> Function(String) onSubmit;
  final VoidCallback? onBack;
  final FutureOr<bool> Function()? onBiometrics;
  final bool autoTriggerBiometrics;

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  String? _firstPin;
  String _currentPin = '';
  bool _isProcessing = false;
  bool _isError = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(_shakeController);

    if (widget.autoTriggerBiometrics && widget.onBiometrics != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_handleBiometrics());
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _handleKeyPressed(String key) async {
    if (_isProcessing || _currentPin.length >= 4) return;

    setState(() {
      _currentPin += key;
    });

    if (_currentPin.length == 4) {
      await _handlePinComplete();
    }
  }

  Future<void> _handlePinComplete() async {
    setState(() {
      _isProcessing = true;
    });

    if (widget.repeatCode) {
      if (_firstPin == null) {
        setState(() {
          _firstPin = _currentPin;
          _currentPin = '';
          _isProcessing = false;
        });
      } else {
        if (_currentPin == _firstPin) {
          final success = await widget.onSubmit(_currentPin);
          if (success) {
            _triggerSuccess();
          } else {
            await _triggerError();
          }
        } else {
          await _triggerError();
        }
      }
    } else {
      final success = await widget.onSubmit(_currentPin);
      if (success) {
        _triggerSuccess();
      } else {
        await _triggerError();
      }
    }
  }

  Future<void> _handleBiometrics() async {
    if (widget.onBiometrics == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final success = await widget.onBiometrics!();

    if (success) {
      _triggerSuccess();
    } else {
      await _triggerError();
    }
  }

  Future<void> _triggerError() async {
    setState(() {
      _isError = true;
    });

    await _shakeController.forward(from: 0);

    if (mounted) {
      setState(() {
        _isError = false;
        _currentPin = '';
        _isProcessing = false;
      });
    }
  }

  void _triggerSuccess() {
    if (mounted) {
      setState(() {
        _isSuccess = true;
        _isProcessing = false;
      });
    }
  }

  void _handleBackspace() {
    if (_isProcessing || _currentPin.isEmpty) return;

    setState(() {
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
    });
  }

  void _handleBack() {
    if (_isProcessing) return;

    if (widget.repeatCode && _firstPin != null) {
      setState(() {
        _firstPin = null;
        _currentPin = '';
      });
    } else {
      widget.onBack?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: (_firstPin != null || widget.onBack != null)
            ? CupertinoNavigationBarBackButton(onPressed: _handleBack)
            : null,
        middle: Text(_firstPin == null ? l10n.enterPin : l10n.repeatPin),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  final dx = sin(_shakeAnimation.value * pi * 4) * 10;
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: child,
                  );
                },
                child: PinDots(
                  currentLength: _currentPin.length,
                  isError: _isError,
                  isSuccess: _isSuccess,
                ),
              ),
              const SizedBox(height: 64),
              PinPad(
                onKeyPressed: _handleKeyPressed,
                onBackspace: _handleBackspace,
                onBiometricsButton: widget.onBiometrics != null ? _handleBiometrics : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
