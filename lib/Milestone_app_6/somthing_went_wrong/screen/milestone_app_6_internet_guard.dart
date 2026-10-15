import 'dart:async';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/somthing_went_wrong/screen/milestone_app_6_something_went_wrong_screen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class MilestoneApp6InternetGuard extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onConnectionRestored;

  const MilestoneApp6InternetGuard({
    super.key,
    required this.child,
    this.onConnectionRestored,
  });

  @override
  State<MilestoneApp6InternetGuard> createState() =>
      _MilestoneApp6InternetGuardState();
}

class _MilestoneApp6InternetGuardState
    extends State<MilestoneApp6InternetGuard>
    with WidgetsBindingObserver {
  final InternetConnection _internetConnection = InternetConnection();

  StreamSubscription<InternetStatus>? _subscription;

  bool _isOffline = false;
  bool _checking = true;
  bool _wasOffline = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkInternet();

    _subscription = _internetConnection.onStatusChange.listen(
          (InternetStatus status) {
        if (!mounted) return;

        final bool isOffline =
            status == InternetStatus.disconnected;

        final bool connectionRestored =
            (_wasOffline || _isOffline) && !isOffline;

        _wasOffline = isOffline;

        setState(() {
          _isOffline = isOffline;
          _checking = false;
        });

        if (connectionRestored) {
          _refreshAfterConnection();
        }
      },
      onError: (Object error) {
        debugPrint('Internet status error: $error');
      },
    );
  }

  Future<void> _refreshAfterConnection() async {
    if (_isRefreshing || !mounted) return;

    _isRefreshing = true;

    try {
      await widget.onConnectionRestored?.call();
    } catch (e) {
      debugPrint('Refresh after internet restored failed: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _checkInternet() async {
    try {
      final bool hasInternet =
      await _internetConnection.hasInternetAccess;

      if (!mounted) return;

      final bool connectionRestored =
          (_wasOffline || _isOffline) && hasInternet;

      _wasOffline = !hasInternet;

      setState(() {
        _isOffline = !hasInternet;
        _checking = false;
      });

      if (connectionRestored) {
        await _refreshAfterConnection();
      }
    } catch (e) {
      debugPrint('Internet check failed: $e');

      if (!mounted) return;

      _wasOffline = true;

      setState(() {
        _isOffline = true;
        _checking = false;
      });
    }
  }

  Future<void> _retry() async {
    await _checkInternet();

    if (!mounted) return;

    if (!_isOffline) {
      await _refreshAfterConnection();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInternet();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,

        if (_checking || _isOffline)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _checking
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : SomethingWentWrongScreen(
                  onRetry: _retry,
                ),
              ),
            ),
          ),
      ],
    );
  }
}