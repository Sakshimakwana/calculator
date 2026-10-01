import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_address_api.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../modelss/milestone_app_6_address_form.dart';
import '../../models/milestone_app_6_address_model.dart';
import '../state/milestone_app_6_state.dart';

class MilestoneApp6AddressScreen
    extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6AddressScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6AddressScreen>
  createState() =>
      _MilestoneApp6AddressScreenState();
}

class _MilestoneApp6AddressScreenState
    extends State<MilestoneApp6AddressScreen> {
  // ============================================================
  // API
  // ============================================================

  final MilestoneApp6AddressApi _addressApi =
  MilestoneApp6AddressApi();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController
  _searchController =
  TextEditingController();

  // ============================================================
  // DATA
  // ============================================================

  List<MilestoneApp6Address>
  _savedAddresses = [];

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoadingAddresses = true;
  bool _isLoadingLocation = false;
  bool _isSavingAddress = false;
  bool _isUpdatingAddress = false;
  bool _isDeletingAddress = false;

  String _searchQuery = '';

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(
      _onSearchChanged,
    );

    _loadAddresses();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchController.removeListener(
      _onSearchChanged,
    );

    _searchController.dispose();

    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {
      _searchQuery =
          _searchController.text
              .trim()
              .toLowerCase();
    });
  }

  // ============================================================
  // LOAD ADDRESSES
  // ============================================================

  Future<void> _loadAddresses() async {
    try {
      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      if (mounted) {
        setState(() {
          _isLoadingAddresses = true;
        });
      }

      final addresses =
      await _addressApi.fetchAddresses(
        token: token,
        page: 1,
        search: null,
      );

      if (!mounted) return;

      setState(() {
        _savedAddresses = addresses;
        _isLoadingAddresses = false;
      });

      debugPrint('');
      debugPrint(
          '========== ADDRESS LIST =========='
      );
      debugPrint(
        'TOTAL ADDRESSES: ${addresses.length}',
      );

      for (final address in addresses) {
        debugPrint(
          'ID: ${address.id} | '
              'LABEL: ${address.label} | '
              'ADDRESS: ${address.fullAddress}',
        );
      }

      debugPrint(
          '=================================='
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingAddresses = false;
      });

      _showMessage(
        'Failed to load addresses: $e',
      );
    }
  }

  // ============================================================
  // SELECT ADDRESS
  // ============================================================

  Future<void> _selectAddress(
      MilestoneApp6Address address,
      ) async {
    if (address.id <= 0) {
      _showMessage(
        'Invalid address ID.',
      );
      return;
    }

    try {
      await AddressStorage
          .saveSelectedAddressId(
        address.id,
      );

      widget.state.setAddress(
        address,
      );

      if (!mounted) return;

      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to select address: $e',
      );
    }
  }

  // ============================================================
  // ADD ADDRESS
  // ============================================================

  Future<void> _addAddress({
    double? latitude,
    double? longitude,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
  }) async {
    // Maximum 3 addresses.
    if (_savedAddresses.length >= 3) {
      _showMessage(
        'You can save maximum 3 addresses.',
      );
      return;
    }

    final result =
    await _showAddressEditor(
      initialLatitude: latitude,
      initialLongitude: longitude,
      initialAddress:
      addressLine,
      initialCity: city,
      initialState: state,
      initialPincode: pincode,
    );

    if (result == null) return;

    await _saveNewAddress(result);
  }

  // ============================================================
  // SAVE NEW ADDRESS
  // ============================================================

  Future<void> _saveNewAddress(
      MilestoneApp6AddressForm form,
      ) async {
    if (_isSavingAddress) {
      return;
    }

    try {
      setState(() {
        _isSavingAddress = true;
      });

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      // First address becomes default.
      final bool isDefault =
          _savedAddresses.isEmpty;

      final body = <String, dynamic>{
        'label': form.label,
        'address_line': form.addressLine,
        'city': form.city,
        'state': form.state,
        'pincode': form.pincode,
        'latitude': form.latitude,
        'longitude': form.longitude,
        'is_default': isDefault,
      };

      debugPrint('');
      debugPrint(
          '=========================================='
      );
      debugPrint(
          '          ADD ADDRESS FROM UI             '
      );
      debugPrint(
          '=========================================='
      );
      debugPrint(
          'REQUEST BODY:'
      );
      debugPrint(
        body.toString(),
      );
      debugPrint(
          '=========================================='
      );

      final savedAddress =
      await _addressApi.storeAddress(
        token: token,
        body: body,
      );

      if (savedAddress.id <= 0) {
        throw Exception(
          'Invalid address ID returned by backend.',
        );
      }

      // Select newly created address.
      await AddressStorage
          .saveSelectedAddressId(
        savedAddress.id,
      );

      widget.state.setAddress(
        savedAddress,
      );

      await _loadAddresses();

      if (!mounted) return;

      _showMessage(
        'Address added successfully.',
      );

      // Continue to home.
      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to save address: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingAddress = false;
        });
      }
    }
  }

  // ============================================================
  // EDIT ADDRESS
  // ============================================================

  Future<void> _editAddress(
      MilestoneApp6Address address,
      ) async {
    final result =
    await _showAddressEditor(
      initialAddress:
      address.address,
      initialCity:
      address.city,
      initialState:
      address.state,
      initialPincode:
      address.pincode,
      initialLatitude:
      address.latitude,
      initialLongitude:
      address.longitude,
      initialLabel:
      address.label,
    );

    if (result == null) {
      return;
    }

    await _updateAddress(
      address,
      result,
    );
  }

  // ============================================================
  // UPDATE ADDRESS
  // ============================================================

  Future<void> _updateAddress(
      MilestoneApp6Address oldAddress,
      MilestoneApp6AddressForm form,
      ) async {
    if (_isUpdatingAddress) {
      return;
    }

    try {
      setState(() {
        _isUpdatingAddress = true;
      });

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      final selectedId =
          AddressStorage.selectedAddressId;

      final body = <String, dynamic>{
        'label': form.label,
        'address_line': form.addressLine,
        'city': form.city,
        'state': form.state,
        'pincode': form.pincode,
        'latitude': form.latitude,
        'longitude': form.longitude,

        // Backend requires true/false.
        'is_default':
        oldAddress.id == selectedId,
      };

      debugPrint('');
      debugPrint(
          '=========================================='
      );
      debugPrint(
          '           UPDATE ADDRESS UI              '
      );
      debugPrint(
          '=========================================='
      );
      debugPrint(
        'ADDRESS ID: ${oldAddress.id}',
      );
      debugPrint(
          'REQUEST BODY:'
      );
      debugPrint(
        body.toString(),
      );
      debugPrint(
          '=========================================='
      );

      final updatedAddress =
      await _addressApi.updateAddress(
        token: token,
        addressId: oldAddress.id,
        body: body,
      );

      if (updatedAddress.id <= 0) {
        throw Exception(
          'Invalid updated address ID.',
        );
      }

      // Keep selected address synchronized.
      if (oldAddress.id == selectedId) {
        await AddressStorage
            .saveSelectedAddressId(
          updatedAddress.id,
        );

        widget.state.setAddress(
          updatedAddress,
        );
      }

      // Refresh from backend.
      await _loadAddresses();

      if (!mounted) return;

      _showMessage(
        'Address updated successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to update address: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingAddress = false;
        });
      }
    }
  }

  // ============================================================
  // DELETE ADDRESS
  // ============================================================

  Future<void> _deleteAddress(
      MilestoneApp6Address address,
      ) async {
    // Cannot delete only address.
    if (_savedAddresses.length <= 1) {
      _showCannotDeletePopup();
      return;
    }

    final confirmed =
    await _showDeleteConfirmation(
      address,
    );

    if (confirmed != true) {
      return;
    }

    await _performDeleteAddress(
      address,
    );
  }

  // ============================================================
  // PERFORM DELETE
  // ============================================================

  Future<void> _performDeleteAddress(
      MilestoneApp6Address address,
      ) async {
    if (_isDeletingAddress) {
      return;
    }

    try {
      setState(() {
        _isDeletingAddress = true;
      });

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      final selectedId =
          AddressStorage.selectedAddressId;

      final bool wasSelected =
          selectedId == address.id;

      await _addressApi.deleteAddress(
        token: token,
        addressId: address.id,
      );

      // Refresh list from API.
      await _loadAddresses();

      // If selected address was deleted,
      // select another existing address.
      if (wasSelected &&
          _savedAddresses.isNotEmpty) {
        final newAddress =
            _savedAddresses.first;

        await AddressStorage
            .saveSelectedAddressId(
          newAddress.id,
        );

        widget.state.setAddress(
          newAddress,
        );
      }

      if (!mounted) return;

      _showMessage(
        'Address deleted successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to delete address: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingAddress = false;
        });
      }
    }
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  Future<bool?> _showDeleteConfirmation(
      MilestoneApp6Address address,
      ) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete address?',
          ),
          content: Text(
            'Are you sure you want to delete '
                '${_displayLabel(address.label)} '
                'address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CANNOT DELETE ONLY ADDRESS
  // ============================================================

  void _showCannotDeletePopup() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Cannot delete address',
          ),
          content: const Text(
            'You must keep at least one '
                'saved address.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> _useCurrentLocation() async {
    if (_isLoadingLocation) {
      return;
    }

    try {
      setState(() {
        _isLoadingLocation = true;
      });

      final serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage(
          'Please enable location services.',
        );
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator
            .requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        _showMessage(
          'Location permission denied.',
        );
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        _showMessage(
          'Location permission is permanently '
              'denied. Enable it from Settings.',
        );
        return;
      }

      final position =
      await Geolocator
          .getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy:
          LocationAccuracy.high,
        ),
      );

      String addressText = '';
      String city = '';
      String state = '';
      String pincode = '';

      try {
        final placemarks =
        await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place =
              placemarks.first;

          city =
              (place.locality ??
                  place
                      .subAdministrativeArea ??
                  '')
                  .trim();

          state =
              (place.administrativeArea ??
                  '')
                  .trim();

          pincode =
              (place.postalCode ??
                  '')
                  .trim();

          final parts =
          <String>[
            if ((place.name ??
                '')
                .trim()
                .isNotEmpty)
              place.name!.trim(),

            if ((place.street ??
                '')
                .trim()
                .isNotEmpty)
              place.street!.trim(),

            if ((place.subLocality ??
                '')
                .trim()
                .isNotEmpty)
              place.subLocality!
                  .trim(),

            if (city.isNotEmpty)
              city,

            if (state.isNotEmpty)
              state,

            if (pincode.isNotEmpty)
              pincode,
          ];

          addressText =
              parts.join(', ');
        }
      } catch (_) {
        // Coordinates still available.
      }

      if (addressText.isEmpty) {
        addressText =
        'Current Location '
            '(${position.latitude.toStringAsFixed(6)}, '
            '${position.longitude.toStringAsFixed(6)})';
      }

      await _addAddress(
        latitude:
        position.latitude,
        longitude:
        position.longitude,
        addressLine:
        addressText,
        city: city,
        state: state,
        pincode: pincode,
      );
    } catch (e) {
      if (mounted) {
        _showMessage(
          'Unable to get your current location: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // ADDRESS EDITOR
  // ============================================================

  Future<MilestoneApp6AddressForm?>
  _showAddressEditor({
    double? initialLatitude,
    double? initialLongitude,
    String? initialAddress,
    String? initialCity,
    String? initialState,
    String? initialPincode,
    String? initialLabel,
  }) {
    return showModalBottomSheet<
        MilestoneApp6AddressForm>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:
      Colors.transparent,
      barrierColor:
      Colors.black.withOpacity(0.55),
      builder: (sheetContext) {
        return MilestoneApp6AddressEditor(
          initialAddress:
          initialAddress ?? '',
          initialCity:
          initialCity ?? '',
          initialState:
          initialState ?? '',
          initialPincode:
          initialPincode ?? '',
          initialLatitude:
          initialLatitude,
          initialLongitude:
          initialLongitude,
          initialLabel:
          initialLabel ?? 'home',
        );
      },
    );
  }

  // ============================================================
  // FILTERED ADDRESSES
  // ============================================================

  List<MilestoneApp6Address>
  get _filteredAddresses {
    if (_searchQuery.isEmpty) {
      return _savedAddresses;
    }

    return _savedAddresses.where(
          (address) {
        final label =
        address.label.toLowerCase();

        final addressText =
        address.fullAddress
            .toLowerCase();

        final city =
        address.city.toLowerCase();

        return label.contains(
          _searchQuery,
        ) ||
            addressText.contains(
              _searchQuery,
            ) ||
            city.contains(
              _searchQuery,
            );
      },
    ).toList();
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
          duration:
          const Duration(
            seconds: 3,
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
        theme.scaffoldBackgroundColor,
        surfaceTintColor:
        Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Select a location',
          style: TextStyle(
            fontSize: 21,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding:
          const EdgeInsets.fromLTRB(
            14,
            4,
            14,
            30,
          ),
          children: [
            _buildSearchBar(theme),

            const SizedBox(
              height: 20,
            ),

            _buildLocationActions(
              theme,
            ),

            const SizedBox(
              height: 24,
            ),

            if (_isLoadingAddresses)
              const Padding(
                padding:
                EdgeInsets.only(
                  top: 50,
                ),
                child: Center(
                  child:
                  CircularProgressIndicator(),
                ),
              )
            else if (_filteredAddresses
                .isNotEmpty) ...[
              _buildSectionTitle(
                'SAVED ADDRESSES',
                theme,
              ),

              const SizedBox(
                height: 12,
              ),

              ..._filteredAddresses.map(
                    (address) => Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child:
                  _buildSavedAddressCard(
                    address,
                    theme,
                  ),
                ),
              ),
            ] else
              _buildEmptyState(
                theme,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar(
      ThemeData theme,
      ) {
    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF302F35)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.20),
        ),
      ),
      child: TextField(
        controller:
        _searchController,
        style: const TextStyle(
          fontSize: 15,
          fontWeight:
          FontWeight.w500,
        ),
        decoration:
        InputDecoration(
          border:
          InputBorder.none,
          hintText:
          'Search saved addresses...',
          hintStyle: TextStyle(
            fontSize: 15,
            color:
            theme.hintColor,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 27,
            color:
            theme.colorScheme
                .primary,
          ),
          suffixIcon:
          _searchController
              .text
              .isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController
                  .clear();
            },
            icon:
            const Icon(
              Icons
                  .close_rounded,
            ),
          )
              : null,
          contentPadding:
          const EdgeInsets
              .symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOCATION ACTIONS
  // ============================================================

  Widget _buildLocationActions(
      ThemeData theme,
      ) {
    final primary =
        theme.colorScheme.primary;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final canAdd =
        _savedAddresses.length < 3;

    return Container(
      decoration:
      BoxDecoration(
        color: isDark
            ? const Color(0xFF202025)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Column(
        children: [
          // ======================================================
          // CURRENT LOCATION
          // ======================================================

          InkWell(
            onTap:
            _isLoadingLocation
                ? null
                : _useCurrentLocation,
            child: Padding(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration:
                    BoxDecoration(
                      color: primary
                          .withOpacity(
                        0.10,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .my_location_rounded,
                      color: primary,
                      size: 23,
                    ),
                  ),

                  const SizedBox(
                    width: 16,
                  ),

                  Expanded(
                    child:
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          _isLoadingLocation
                              ? 'Getting current location...'
                              : 'Use current location',
                          style:
                          TextStyle(
                            color:
                            primary,
                            fontSize: 15,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Use your device location',
                          style:
                          TextStyle(
                            fontSize: 13,
                            color: theme
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(
                              0.65,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_isLoadingLocation)
                    const SizedBox(
                      width: 19,
                      height: 19,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(
                      Icons
                          .chevron_right_rounded,
                      color:
                      theme.hintColor,
                    ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: theme
                .dividerColor
                .withOpacity(
              0.20,
            ),
          ),

          // ======================================================
          // ADD ADDRESS
          // ======================================================

          InkWell(
            onTap:
            (_isSavingAddress ||
                !canAdd)
                ? null
                : () =>
                _addAddress(),
            child: Padding(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: canAdd
                        ? primary
                        : theme
                        .disabledColor,
                    size: 25,
                  ),

                  const SizedBox(
                    width: 16,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          canAdd
                              ? 'Add Address'
                              : 'Maximum 3 addresses reached',
                          style:
                          TextStyle(
                            color: canAdd
                                ? primary
                                : theme
                                .disabledColor,
                            fontSize: 15,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                        if (!canAdd)
                          const SizedBox(
                            height: 3,
                          ),
                        if (!canAdd)
                          Text(
                            'Delete an address before adding another.',
                            style:
                            TextStyle(
                              fontSize: 12,
                              color: theme
                                  .hintColor,
                            ),
                          ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons
                        .chevron_right_rounded,
                    color:
                    theme.hintColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
      String title,
      ThemeData theme,
      ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        letterSpacing: 1.5,
        fontWeight:
        FontWeight.w600,
        color: theme
            .textTheme
            .bodyMedium
            ?.color
            ?.withOpacity(
          0.75,
        ),
      ),
    );
  }

  // ============================================================
  // SAVED ADDRESS CARD
  // ============================================================

  Widget _buildSavedAddressCard(
      MilestoneApp6Address address,
      ThemeData theme,
      ) {
    final selectedId =
        AddressStorage.selectedAddressId;

    final isSelected =
        selectedId == address.id;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final canDelete =
        _savedAddresses.length > 1;

    return Material(
      color: isDark
          ? const Color(0xFF202025)
          : Colors.white,
      borderRadius:
      BorderRadius.circular(17),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(17),
        onTap: () =>
            _selectAddress(
              address,
            ),
        child: Padding(
          padding:
          const EdgeInsets
              .fromLTRB(
            16,
            16,
            8,
            16,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                BoxDecoration(
                  color: theme
                      .colorScheme
                      .primary
                      .withOpacity(
                    0.08,
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(
                    11,
                  ),
                ),
                child: Icon(
                  _getAddressIcon(
                    address.label,
                  ),
                  color: theme
                      .colorScheme
                      .primary,
                  size: 23,
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                          Text(
                            _displayLabel(
                              address
                                  .label,
                            ),
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontSize:
                              15,
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),
                        ),

                        if (isSelected)
                          Container(
                            margin:
                            const EdgeInsets
                                .only(
                              right: 6,
                            ),
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              8,
                              vertical:
                              4,
                            ),
                            decoration:
                            BoxDecoration(
                              color: theme
                                  .colorScheme
                                  .primary
                                  .withOpacity(
                                0.10,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(
                                6,
                              ),
                            ),
                            child: Text(
                              'Selected',
                              style:
                              TextStyle(
                                color: theme
                                    .colorScheme
                                    .primary,
                                fontSize:
                                9,
                                fontWeight:
                                FontWeight
                                    .w700,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      address.fullAddress,
                      maxLines: 3,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: theme
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(
                          0.80,
                        ),
                      ),
                    ),

                    if (address.latitude !=
                        null &&
                        address.longitude !=
                            null) ...[
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .location_on_outlined,
                            size: 14,
                            color: theme
                                .hintColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              '${address.latitude!.toStringAsFixed(6)}, '
                                  '${address.longitude!.toStringAsFixed(6)}',
                              style:
                              TextStyle(
                                fontSize:
                                10,
                                color: theme
                                    .hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ==================================================
              // THREE DOT MENU
              // ==================================================

              PopupMenuButton<
                  String>(
                tooltip:
                'Address options',
                onSelected:
                    (value) {
                  if (value ==
                      'edit') {
                    _editAddress(
                      address,
                    );
                  }

                  if (value ==
                      'delete') {
                    _deleteAddress(
                      address,
                    );
                  }
                },
                itemBuilder:
                    (context) {
                  return [
                    const PopupMenuItem<
                        String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .edit_outlined,
                            size: 20,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Edit',
                          ),
                        ],
                      ),
                    ),

                    // Delete only when
                    // more than one exists.
                    if (canDelete)
                      const PopupMenuItem<
                          String>(
                        value:
                        'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons
                                  .delete_outline,
                              color:
                              Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Delete',
                              style:
                              TextStyle(
                                color:
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ];
                },
                icon: Icon(
                  Icons
                      .more_vert_rounded,
                  color:
                  theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
      ThemeData theme,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        top: 85,
      ),
      child: Column(
        children: [
          Icon(
            Icons
                .location_searching_rounded,
            size: 62,
            color:
            Colors.grey.shade400,
          ),

          const SizedBox(
            height: 18,
          ),

          const Text(
            'No saved addresses',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            'Add an address to continue.',
            style: TextStyle(
              fontSize: 13,
              color:
              theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS ICON
  // ============================================================

  IconData _getAddressIcon(
      String label,
      ) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;

      case 'work':
        return Icons
            .business_center_rounded;

      case 'office':
        return Icons
            .business_rounded;

      case 'other':
        return Icons
            .location_on_rounded;

      default:
        return Icons
            .location_on_rounded;
    }
  }

  // ============================================================
  // DISPLAY LABEL
  // ============================================================

  String _displayLabel(
      String label,
      ) {
    if (label.isEmpty) {
      return 'Address';
    }

    return label[0].toUpperCase() +
        label.substring(1);
  }
}

// ============================================================================
// ADDRESS EDITOR
// ============================================================================

class MilestoneApp6AddressEditor
    extends StatefulWidget {
  final String initialAddress;
  final String initialCity;
  final String initialState;
  final String initialPincode;

  final double? initialLatitude;
  final double? initialLongitude;

  final String initialLabel;

  const MilestoneApp6AddressEditor({
    super.key,
    this.initialAddress = '',
    this.initialCity = '',
    this.initialState = '',
    this.initialPincode = '',
    this.initialLatitude,
    this.initialLongitude,
    this.initialLabel = 'home',
  });

  @override
  State<MilestoneApp6AddressEditor>
  createState() =>
      _MilestoneApp6AddressEditorState();
}

class _MilestoneApp6AddressEditorState
    extends State<
        MilestoneApp6AddressEditor> {
  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState>
  _formKey =
  GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController
  _addressController;

  late final TextEditingController
  _cityController;

  late final TextEditingController
  _stateController;

  late final TextEditingController
  _pincodeController;

  late final TextEditingController
  _latitudeController;

  late final TextEditingController
  _longitudeController;

  // ============================================================
  // STATE
  // ============================================================

  late String _selectedLabel;

  bool _isGettingLocation = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _selectedLabel =
        _normalizeLabel(
          widget.initialLabel,
        );

    _addressController =
        TextEditingController(
          text: widget.initialAddress,
        );

    _cityController =
        TextEditingController(
          text: widget.initialCity,
        );

    _stateController =
        TextEditingController(
          text: widget.initialState,
        );

    _pincodeController =
        TextEditingController(
          text: widget.initialPincode,
        );

    _latitudeController =
        TextEditingController(
          text: widget.initialLatitude
              ?.toStringAsFixed(6) ??
              '',
        );

    _longitudeController =
        TextEditingController(
          text: widget.initialLongitude
              ?.toStringAsFixed(6) ??
              '',
        );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    super.dispose();
  }

  // ============================================================
  // NORMALIZE LABEL
  // ============================================================

  String _normalizeLabel(
      String value,
      ) {
    final label =
    value.trim().toLowerCase();

    if (label == 'home' ||
        label == 'work' ||
        label == 'other') {
      return label;
    }

    if (label == 'office') {
      return 'work';
    }

    return 'home';
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) {
      return;
    }

    try {
      setState(() {
        _isGettingLocation = true;
      });

      final serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage(
          'Please enable location services.',
        );
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator
            .requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        _showMessage(
          'Location permission denied.',
        );
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        _showMessage(
          'Location permission is permanently denied.',
        );
        return;
      }

      final position =
      await Geolocator
          .getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy:
          LocationAccuracy.high,
        ),
      );

      _latitudeController.text =
          position.latitude
              .toStringAsFixed(6);

      _longitudeController.text =
          position.longitude
              .toStringAsFixed(6);

      try {
        final placemarks =
        await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place =
              placemarks.first;

          final city =
          (place.locality ??
              place
                  .subAdministrativeArea ??
              '')
              .trim();

          final state =
          (place.administrativeArea ??
              '')
              .trim();

          final pincode =
          (place.postalCode ??
              '')
              .trim();

          _cityController.text =
              city;

          _stateController.text =
              state;

          _pincodeController.text =
              pincode;

          final parts =
          <String>[
            if ((place.name ??
                '')
                .trim()
                .isNotEmpty)
              place.name!.trim(),

            if ((place.street ??
                '')
                .trim()
                .isNotEmpty)
              place.street!.trim(),

            if ((place.subLocality ??
                '')
                .trim()
                .isNotEmpty)
              place.subLocality!
                  .trim(),

            if (city.isNotEmpty)
              city,

            if (state.isNotEmpty)
              state,

            if (pincode.isNotEmpty)
              pincode,
          ];

          if (parts.isNotEmpty) {
            _addressController.text =
                parts.join(', ');
          }
        }
      } catch (_) {
        // Coordinates are still valid.
      }

      if (mounted) {
        setState(() {});
      }

      _showMessage(
        'Current location added.',
      );
    } catch (e) {
      if (mounted) {
        _showMessage(
          'Unable to get current location: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // SAVE FORM
  // ============================================================

  void _save() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final latitude =
    double.tryParse(
      _latitudeController.text
          .trim(),
    );

    final longitude =
    double.tryParse(
      _longitudeController.text
          .trim(),
    );

    if (latitude == null) {
      _showMessage(
        'Enter a valid latitude.',
      );
      return;
    }

    if (longitude == null) {
      _showMessage(
        'Enter a valid longitude.',
      );
      return;
    }

    if (latitude < -90 ||
        latitude > 90) {
      _showMessage(
        'Latitude must be between -90 and 90.',
      );
      return;
    }

    if (longitude < -180 ||
        longitude > 180) {
      _showMessage(
        'Longitude must be between -180 and 180.',
      );
      return;
    }

    final form =
    MilestoneApp6AddressForm(
      label:
      _selectedLabel,

      addressLine:
      _addressController.text
          .trim(),

      city:
      _cityController.text
          .trim(),

      state:
      _stateController.text
          .trim(),

      pincode:
      _pincodeController.text
          .trim(),

      latitude:
      latitude,

      longitude:
      longitude,
    );

    Navigator.of(context)
        .pop(form);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
          Text(message),
          behavior:
          SnackBarBehavior
              .floating,
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final bottom =
        MediaQuery.of(context)
            .viewInsets
            .bottom;

    return Padding(
      padding:
      EdgeInsets.only(
        bottom: bottom,
      ),
      child: Container(
        constraints:
        const BoxConstraints(
          maxHeight: 760,
        ),
        decoration:
        BoxDecoration(
          color: theme
              .scaffoldBackgroundColor,
          borderRadius:
          const BorderRadius
              .vertical(
            top: Radius.circular(
              26,
            ),
          ),
        ),
        child:
        SingleChildScrollView(
          padding:
          const EdgeInsets
              .fromLTRB(
            20,
            12,
            20,
            25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                // ==================================================
                // HANDLE
                // ==================================================

                Center(
                  child:
                  Container(
                    width: 42,
                    height: 4,
                    decoration:
                    BoxDecoration(
                      color: theme
                          .dividerColor,
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // TITLE
                // ==================================================

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Address Details',
                        style:
                        TextStyle(
                          fontSize:
                          20,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .close_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // LABEL
                // ==================================================

                const Text(
                  'Save address as',
                  style:
                  TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight
                        .w700,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                _buildLabelSelector(
                  theme,
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // ADDRESS
                // ==================================================

                _buildField(
                  controller:
                  _addressController,
                  label:
                  'Address line',
                  hint:
                  'House no, street, area...',
                  icon: Icons
                      .location_on_outlined,
                  maxLines: 3,
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Address line is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // CITY
                // ==================================================

                _buildField(
                  controller:
                  _cityController,
                  label: 'City',
                  hint:
                  'e.g. Ahmedabad',
                  icon: Icons
                      .location_city_outlined,
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'City is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // STATE
                // ==================================================

                _buildField(
                  controller:
                  _stateController,
                  label: 'State',
                  hint:
                  'e.g. Gujarat',
                  icon: Icons
                      .map_outlined,
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'State is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // PINCODE
                // ==================================================

                _buildField(
                  controller:
                  _pincodeController,
                  label:
                  'Pincode',
                  hint:
                  'e.g. 380001',
                  icon: Icons
                      .pin_drop_outlined,
                  keyboardType:
                  TextInputType
                      .number,
                  validator:
                      (value) {
                    if (value ==
                        null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Pincode is required';
                    }

                    if (!RegExp(
                      r'^\d{6}$',
                    ).hasMatch(
                      value.trim(),
                    )) {
                      return 'Enter a valid 6 digit pincode';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // CURRENT LOCATION
                // ==================================================

                SizedBox(
                  width:
                  double.infinity,
                  child:
                  OutlinedButton
                      .icon(
                    onPressed:
                    _isGettingLocation
                        ? null
                        : _getCurrentLocation,
                    icon:
                    _isGettingLocation
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                      ),
                    )
                        : const Icon(
                      Icons
                          .my_location_rounded,
                    ),
                    label:
                    Text(
                      _isGettingLocation
                          ? 'Getting location...'
                          : 'Use Current Location',
                    ),
                    style:
                    OutlinedButton
                        .styleFrom(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 14,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // COORDINATES
                // ==================================================

                const Text(
                  'Location Coordinates',
                  style:
                  TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight
                        .w700,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                      _buildField(
                        controller:
                        _latitudeController,
                        label:
                        'Latitude',
                        hint:
                        '23.0225',
                        icon: Icons
                            .north_rounded,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal:
                          true,
                          signed:
                          true,
                        ),
                        validator:
                            (value) {
                          if (value ==
                              null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Required';
                          }

                          final number =
                          double.tryParse(
                            value
                                .trim(),
                          );

                          if (number ==
                              null) {
                            return 'Invalid';
                          }

                          if (number <
                              -90 ||
                              number >
                                  90) {
                            return 'Invalid range';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      _buildField(
                        controller:
                        _longitudeController,
                        label:
                        'Longitude',
                        hint:
                        '72.5714',
                        icon: Icons
                            .east_rounded,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal:
                          true,
                          signed:
                          true,
                        ),
                        validator:
                            (value) {
                          if (value ==
                              null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Required';
                          }

                          final number =
                          double.tryParse(
                            value
                                .trim(),
                          );

                          if (number ==
                              null) {
                            return 'Invalid';
                          }

                          if (number <
                              -180 ||
                              number >
                                  180) {
                            return 'Invalid range';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Latitude: -90 to 90  •  '
                      'Longitude: -180 to 180',
                  style:
                  TextStyle(
                    fontSize: 11,
                    color:
                    theme.hintColor,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // ==================================================
                // SAVE
                // ==================================================

                SizedBox(
                  width:
                  double.infinity,
                  height: 52,
                  child:
                  ElevatedButton(
                    onPressed:
                    _save,
                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      theme
                          .colorScheme
                          .primary,
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
                    child:
                    const Text(
                      'Save Address',
                      style:
                      TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL SELECTOR
  // ============================================================

  Widget _buildLabelSelector(
      ThemeData theme,
      ) {
    return Row(
      children: [
        _buildLabelChip(
          label: 'Home',
          value: 'home',
          icon:
          Icons.home_rounded,
          theme: theme,
        ),

        const SizedBox(
          width: 10,
        ),

        _buildLabelChip(
          label: 'Work',
          value: 'work',
          icon: Icons
              .business_center_rounded,
          theme: theme,
        ),

        const SizedBox(
          width: 10,
        ),

        _buildLabelChip(
          label: 'Other',
          value: 'other',
          icon: Icons
              .location_on_rounded,
          theme: theme,
        ),
      ],
    );
  }

  // ============================================================
  // LABEL CHIP
  // ============================================================

  Widget _buildLabelChip({
    required String label,
    required String value,
    required IconData icon,
    required ThemeData theme,
  }) {
    final selected =
        _selectedLabel == value;

    return Expanded(
      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        onTap: () {
          setState(() {
            _selectedLabel = value;
          });
        },
        child:
        AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 180,
          ),
          padding:
          const EdgeInsets
              .symmetric(
            vertical: 13,
            horizontal: 8,
          ),
          decoration:
          BoxDecoration(
            color: selected
                ? theme
                .colorScheme
                .primary
                .withOpacity(
              0.10,
            )
                : theme
                .colorScheme
                .surface,
            borderRadius:
            BorderRadius.circular(
              12,
            ),
            border: Border.all(
              color: selected
                  ? theme
                  .colorScheme
                  .primary
                  : theme
                  .dividerColor,
              width:
              selected
                  ? 1.5
                  : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected
                    ? theme
                    .colorScheme
                    .primary
                    : theme
                    .hintColor,
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                label,
                style:
                TextStyle(
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w700,
                  color: selected
                      ? theme
                      .colorScheme
                      .primary
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildField({
    required TextEditingController
    controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)?
    validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final theme =
    Theme.of(context);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType:
      keyboardType,
      validator: validator,
      style:
      const TextStyle(
        fontSize: 14,
      ),
      decoration:
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding:
          const EdgeInsets
              .only(
            left: 4,
            right: 4,
          ),
          child: Icon(
            icon,
            size: 21,
          ),
        ),
        alignLabelWithHint:
        maxLines > 1,
        filled: true,
        fillColor: theme
            .colorScheme
            .surface,
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
          borderSide:
          BorderSide.none,
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
          borderSide:
          BorderSide(
            color:
            theme.dividerColor,
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
          borderSide:
          BorderSide(
            color: theme
                .colorScheme
                .primary,
            width: 1.5,
          ),
        ),
        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
          borderSide:
          const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
          borderSide:
          const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}