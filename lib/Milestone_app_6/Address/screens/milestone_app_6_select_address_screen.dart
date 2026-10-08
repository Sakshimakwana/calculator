import 'dart:async';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_add_button.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_card.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_empty_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_load_more_button.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_current_location_button.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/select_address/select_address_search_field.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/service/milestone_app_6_address_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/milestone_app_6_address_model.dart';

class MilestoneApp6SelectAddressScreen
    extends StatefulWidget {
  const MilestoneApp6SelectAddressScreen({
    super.key,
  });

  @override
  State<MilestoneApp6SelectAddressScreen>
  createState() =>
      _MilestoneApp6SelectAddressScreenState();
}

class _MilestoneApp6SelectAddressScreenState
    extends State<
        MilestoneApp6SelectAddressScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final MilestoneApp6AddressApi _addressApi =
  MilestoneApp6AddressApi();

  List<MilestoneApp6Address> _addresses = [];

  bool _isLoading = true;
  bool _isSearching = false;
  bool _isLoadingMore = false;

  int _currentPage = 1;
  bool _hasMorePages = false;

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();

    _fetchAddresses();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  Future<String?> _getToken() async {
    return AuthStorage.token;
  }

  Future<void> _fetchAddresses({
    bool refresh = false,
    String? search,
  }) async {
    try {
      if (refresh) {
        setState(() {
          _currentPage = 1;
          _isLoading = true;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
      }

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      final addresses =
      await _addressApi.fetchAddresses(
        token: token,
        page: 1,
        search: search,
      );

      if (!mounted) return;

      setState(() {
        _addresses = addresses;
        _currentPage = 1;
        _isLoading = false;
        _isSearching = false;

        // The backend gives pagination separately.
        // We handle "load more" conservatively.
        _hasMorePages =
            addresses.length >= 2;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isSearching = false;
      });

      _showMessage(
        'Unable to load addresses.',
      );
    }
  }

  Future<void> _loadMoreAddresses() async {
    if (_isLoadingMore ||
        !_hasMorePages) {
      return;
    }

    try {
      setState(() {
        _isLoadingMore = true;
      });

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      final nextPage = _currentPage + 1;

      final addresses =
      await _addressApi.fetchAddresses(
        token: token,
        page: nextPage,
        search: _searchController.text,
      );

      if (!mounted) return;

      setState(() {
        _addresses.addAll(addresses);

        _currentPage = nextPage;

        _hasMorePages =
            addresses.length >= 2;

        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      _showMessage(
        'Unable to load more addresses.',
      );
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
          () {
        _searchAddresses(value);
      },
    );
  }

  Future<void> _searchAddresses(
      String value,
      ) async {
    final query = value.trim();

    setState(() {
      _isSearching = true;
    });

    await _fetchAddresses(
      refresh: true,
      search: query.isEmpty ? null : query,
    );
  }

  Future<void> _selectAddress(
      MilestoneApp6Address address,
      ) async {
    if (address.id <= 0) {
      _showMessage(
        'Invalid address ID.',
      );
      return;
    }

    await AddressStorage.saveSelectedAddressId(
      address.id,
    );

    if (!mounted) return;

    context.go('/home');
  }

  void _addNewAddress() {
    context.push('/add-address');
  }

  Future<void> _useCurrentLocation() async {
    /*
      Keep your existing geolocator implementation here.

      IMPORTANT:

      Current location should eventually result in
      a backend address ID.

      Home should use:

      address_id = backendAddress.id

      NOT latitude/longitude directly.
    */

    _showMessage(
      'Use current location flow will create/select an address.',
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 625,
              ),
              child: Container(
                padding:
                const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color:
                    const Color(0xFFE5E5E5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 25,
                      offset:
                      Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Select Address',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Select a delivery address to explore restaurants near you.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                        Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 22),

                    MilestoneApp6SelectAddressSearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      isSearching: _isSearching,
                    ),

                    const SizedBox(height: 15),

                    _buildAddressList(),

                    const SizedBox(height: 15),

                    if (_hasMorePages)
                      MilestoneApp6SelectAddressLoadMoreButton(
                        onPressed: _loadMoreAddresses,
                        isLoading: _isLoadingMore,
                      ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 56,
                      child:
                      MilestoneApp6SelectAddressLocationButton(
                        onPressed: _useCurrentLocation,
                        isLoading: _isLoading,
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      height: 50,
                      child:
                      MilestoneApp6SelectAddressAddButton(
                        onPressed: _addNewAddress,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    if (_isLoading) {
      return const Padding(
        padding:
        EdgeInsets.symmetric(
          vertical: 35,
        ),
        child: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }
    if (_addresses.isEmpty) {
      return const MilestoneApp6SelectAddressEmptyState();
    }
    return Column(
      children: _addresses
          .map(
            (address) =>
            Padding(
              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),
              child:
              MilestoneApp6SelectAddressCard(
                address: address,
                onTap: () => _selectAddress(address),
              ),
            ),
      )
          .toList(),
    );
  }
}