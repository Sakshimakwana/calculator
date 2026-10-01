import 'dart:async';
import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_address_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/milestone_app_6_address_model.dart';


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

                    _buildSearchField(),

                    const SizedBox(height: 15),

                    _buildAddressList(),

                    const SizedBox(height: 15),

                    if (_hasMorePages)
                      TextButton(
                        onPressed:
                        _loadMoreAddresses,
                        child: _isLoadingMore
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Load more addresses',
                          style: TextStyle(
                            color:
                            Color(0xFFE05A67),
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 56,
                      child:
                      ElevatedButton.icon(
                        onPressed:
                        _useCurrentLocation,
                        icon: const Icon(
                          Icons.my_location_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'Use current location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(
                            0xFFE05A67,
                          ),
                          foregroundColor:
                          Colors.white,
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      height: 50,
                      child:
                      OutlinedButton.icon(
                        onPressed:
                        _addNewAddress,
                        icon: const Icon(
                          Icons.add,
                          size: 19,
                        ),
                        label: const Text(
                          'Add New Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        style:
                        OutlinedButton.styleFrom(
                          foregroundColor:
                          const Color(
                            0xFFE05A67,
                          ),
                          side:
                          const BorderSide(
                            color:
                            Color(0xFFE05A67),
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),
                        ),
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText:
        'Search saved addresses...',
        hintStyle: const TextStyle(
          color: Color(0xFFAAAAAA),
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF9AA4B2),
        ),
        suffixIcon: _isSearching
            ? const Padding(
          padding:
          EdgeInsets.all(14),
          child:
          SizedBox(
            height: 18,
            width: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide:
          const BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide:
          const BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide:
          const BorderSide(
            color: Color(0xFFE05A67),
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
      return Container(
        padding:
        const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color:
          const Color(0xFFFFF8F8),
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 42,
              color:
              Color(0xFFE05A67),
            ),
            SizedBox(height: 10),
            Text(
              'No saved addresses found.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Add a new delivery address to continue.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                Color(0xFF777777),
              ),
            ),
          ],
        ),
      );
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
              _buildAddressCard(
                address,
              ),
            ),
      )
          .toList(),
    );
  }

  Widget _buildAddressCard(
      MilestoneApp6Address address,
      ) {
    return InkWell(
      onTap: () =>
          _selectAddress(address),
      borderRadius:
      BorderRadius.circular(14),
      child: Container(
        padding:
        const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color:
            const Color(0xFFE3E3E3),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color:
                const Color(0xFFFFF1F2),
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),
              child: Icon(
                address.label
                    .toLowerCase() ==
                    'work'
                    ? Icons
                    .work_outline_rounded
                    : Icons
                    .home_outlined,
                color:
                const Color(
                  0xFFE05A67,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label,
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    address.fullAddress,
                    style:
                    const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color:
                      Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color:
              Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
    );
  }
}