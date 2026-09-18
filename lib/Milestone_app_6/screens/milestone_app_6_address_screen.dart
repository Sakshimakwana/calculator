import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MilestoneApp6AddressScreen extends StatefulWidget {
  const MilestoneApp6AddressScreen({
    super.key,
  });

  @override
  State<MilestoneApp6AddressScreen> createState() =>
      _MilestoneApp6AddressScreenState();
}

class _MilestoneApp6AddressScreenState
    extends State<MilestoneApp6AddressScreen> {
// ============================================================
// STORAGE KEYS
// ============================================================

  static const String _addressesKey = 'saved_addresses';
  static const String _selectedAddressKey = 'selected_address';

// ============================================================
// CONTROLLERS
// ============================================================

  final TextEditingController _searchController = TextEditingController();

// ============================================================
// STATE
// ============================================================

  List<MilestoneApp6Address> _savedAddresses = [];

  String _selectedAddress = '';

  bool _isLoadingLocation = false;

  String _searchQuery = '';

// ============================================================
// NEARBY LOCATIONS
// ============================================================

  final List<MilestoneApp6NearbyLocation> _nearbyLocations = [
    MilestoneApp6NearbyLocation(
      name: 'Aamrakunj Bunglows',
      address: 'Motera, Ahmedabad, Gujarat',
      distance: '136 m',
    ),
    MilestoneApp6NearbyLocation(
      name: 'Swarnim Business HUB',
      address: 'Visat-Tapovan Highway, Motera, Ahmedabad, Gujarat',
      distance: '161 m',
    ),
    MilestoneApp6NearbyLocation(
      name: 'Hotel Avens INN',
      address:
          'Amrakunj Avis, Above Gwalbhog Banquet, Near Tapovan Circle Visat, Ahmedabad',
      distance: '225 m',
    ),
    MilestoneApp6NearbyLocation(
      name: 'Mccafe By Mcdonalds',
      address: 'Motera, Ahmedabad, Gujarat',
      distance: '250 m',
    ),
  ];

// ============================================================
// INIT
// ============================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    _loadAddresses();
  }

// ============================================================
// DISPOSE
// ============================================================

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

    super.dispose();
  }

// ============================================================
// SEARCH
// ============================================================

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

// ============================================================
// LOAD SAVED ADDRESSES
// ============================================================

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString(_addressesKey);

    final selected = prefs.getString(_selectedAddressKey) ?? '';

    List<MilestoneApp6Address> addresses = [];

    if (savedData != null && savedData.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedData);

        if (decoded is List) {
          addresses = decoded
              .map(
                (item) => MilestoneApp6Address.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        }
      } catch (_) {
        addresses = [];
      }
    }

    if (!mounted) return;

    setState(() {
      _savedAddresses = addresses;
      _selectedAddress = selected;
    });
  }

// ============================================================
// SAVE ADDRESSES
// ============================================================

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _savedAddresses.map((address) => address.toJson()).toList();

    await prefs.setString(
      _addressesKey,
      jsonEncode(data),
    );
  }

// ============================================================
// SAVE SELECTED ADDRESS
// ============================================================

  Future<void> _selectAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _selectedAddressKey,
      address,
    );

    if (!mounted) return;

    setState(() {
      _selectedAddress = address;
    });

    Navigator.pop(context, address);
  }

// ============================================================
// CURRENT LOCATION
// ============================================================

  Future<void> _useCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage(
          'Please enable location services.',
        );

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage(
          'Location permission denied.',
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'Location permission is permanently denied. Please enable it from Settings.',
        );

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      String addressText = '';

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          final parts = <String>[
            if ((place.name ?? '').trim().isNotEmpty) place.name!.trim(),
            if ((place.subLocality ?? '').trim().isNotEmpty)
              place.subLocality!.trim(),
            if ((place.locality ?? '').trim().isNotEmpty)
              place.locality!.trim(),
            if ((place.administrativeArea ?? '').trim().isNotEmpty)
              place.administrativeArea!.trim(),
          ];

          addressText = parts.join(', ');
        }
      } catch (_) {}

      if (addressText.isEmpty) {
        addressText =
            'Current Location (${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)})';
      }

      await _selectAddress(addressText);
    } catch (e) {
      _showMessage(
        'Unable to get your current location.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

// ============================================================
// ADD ADDRESS
// ============================================================

  Future<void> _addAddress() async {
    final result = await _showAddressEditor();

    if (result == null) return;

    final address = MilestoneApp6Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: result.label,
      address: result.address,
      phone: result.phone,
    );

    setState(() {
      _savedAddresses.insert(0, address);
    });

    await _saveAddresses();

// Automatically select newly added address.
    await _selectAddress(address.address);
  }

// ============================================================
// EDIT ADDRESS
// ============================================================

  Future<void> _editAddress(
    MilestoneApp6Address oldAddress,
  ) async {
    final result = await _showAddressEditor(
      existing: oldAddress,
    );

    if (result == null) return;

    final index = _savedAddresses.indexWhere(
      (item) => item.id == oldAddress.id,
    );

    if (index == -1) return;

    final updated = MilestoneApp6Address(
      id: oldAddress.id,
      label: result.label,
      address: result.address,
      phone: result.phone,
    );

    setState(() {
      _savedAddresses[index] = updated;
    });

    await _saveAddresses();

    if (_selectedAddress == oldAddress.address) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _selectedAddressKey,
        updated.address,
      );

      if (mounted) {
        setState(() {
          _selectedAddress = updated.address;
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
    final shouldDelete = await _showDeleteConfirmation(address);

    if (shouldDelete != true) return;

    setState(() {
      _savedAddresses.removeWhere(
        (item) => item.id == address.id,
      );
    });

    await _saveAddresses();

    if (_selectedAddress == address.address) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_selectedAddressKey);

      if (mounted) {
        setState(() {
          _selectedAddress = '';
        });
      }
    }

    _showMessage(
      'Address deleted.',
    );
  }

// ============================================================
// ADDRESS EDITOR
// ============================================================

  Future<MilestoneApp6AddressForm?> _showAddressEditor({
    MilestoneApp6Address? existing,
  }) async {
    final result = await showModalBottomSheet<MilestoneApp6AddressForm>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      elevation: 0,
      builder: (sheetContext) {
        return _AddressEditorSheet(
          initialLabel: existing?.label ?? 'Home',
          initialAddress: existing?.address ?? '',
          initialPhone: existing?.phone ?? '',
          isEditing: existing != null,
        );
      },
    );

    return result;
  }

// ============================================================
// DELETE CONFIRMATION
// ============================================================

  Future<bool?> _showDeleteConfirmation(
    MilestoneApp6Address address,
  ) {
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete address?',
          ),
          content: Text(
            'Are you sure you want to delete your ${address.label} address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

// ============================================================
// MESSAGE
// ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

// ============================================================
// SEARCHED SAVED ADDRESSES
// ============================================================

  List<MilestoneApp6Address> get _filteredSavedAddresses {
    if (_searchQuery.isEmpty) {
      return _savedAddresses;
    }

    return _savedAddresses.where((address) {
      return address.label.toLowerCase().contains(_searchQuery) ||
          address.address.toLowerCase().contains(_searchQuery) ||
          address.phone.toLowerCase().contains(_searchQuery);
    }).toList();
  }

// ============================================================
// SEARCHED NEARBY LOCATIONS
// ============================================================

  List<MilestoneApp6NearbyLocation> get _filteredNearbyLocations {
    if (_searchQuery.isEmpty) {
      return _nearbyLocations;
    }

    return _nearbyLocations.where((location) {
      return location.name.toLowerCase().contains(_searchQuery) ||
          location.address.toLowerCase().contains(_searchQuery);
    }).toList();
  }

// ============================================================
// BUILD
// ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Select a location',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            4,
            14,
            30,
          ),
          children: [
// ==========================================================
// SEARCH BAR
// ==========================================================

            _buildSearchBar(theme),

            const SizedBox(height: 20),

// ==========================================================
// CURRENT LOCATION + ADD ADDRESS
// ==========================================================

            _buildLocationActions(theme),

            const SizedBox(height: 22),

// ==========================================================
// SAVED ADDRESSES
// ==========================================================

            if (_filteredSavedAddresses.isNotEmpty) ...[
              _buildSectionTitle(
                'SAVED ADDRESSES',
                theme,
              ),
              const SizedBox(height: 12),
              ..._filteredSavedAddresses.map(
                (address) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: _buildSavedAddressCard(
                      address,
                      theme,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

// ==========================================================
// NEARBY LOCATIONS
// ==========================================================

            if (_filteredNearbyLocations.isNotEmpty) ...[
              _buildSectionTitle(
                'NEARBY LOCATIONS',
                theme,
              ),
              const SizedBox(height: 12),
              _buildNearbyLocationList(theme),
            ],

// ==========================================================
// EMPTY SEARCH
// ==========================================================

            if (_filteredSavedAddresses.isEmpty &&
                _filteredNearbyLocations.isEmpty)
              _buildNoResults(theme),
          ],
        ),
      ),
    );
  }

// ============================================================
// SEARCH BAR UI
// ============================================================

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      height: 53,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF302F35)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for area, street name...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: theme.hintColor,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 28,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : theme.colorScheme.primary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
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
    final primary = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF202025)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
// ========================================================
// CURRENT LOCATION
// ========================================================

          InkWell(
            onTap: _useCurrentLocation,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      color: primary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoadingLocation
                              ? 'Getting current location...'
                              : 'Use current location',
                          style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use your device location',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoadingLocation)
                    const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.hintColor,
                    ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withOpacity(0.25),
          ),

// ========================================================
// ADD ADDRESS
// ========================================================

          InkWell(
            onTap: _addAddress,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: primary,
                    size: 25,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Add Address',
                      style: TextStyle(
                        color: primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.hintColor,
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
        fontWeight: FontWeight.w600,
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
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
    final isSelected = _selectedAddress == address.address;

    return Material(
      color: theme.brightness == Brightness.dark
          ? const Color(0xFF202025)
          : Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          _selectAddress(address.address);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            8,
            14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// --------------------------------------------------
// ICON
// --------------------------------------------------

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getAddressIcon(
                        address.label,
                      ),
                      color: theme.colorScheme.primary,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 13),

// --------------------------------------------------
// ADDRESS DETAILS
// --------------------------------------------------

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                address.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Selected',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          address.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.80),
                          ),
                        ),
                        if (address.phone.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            'Phone number: ${address.phone}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

// --------------------------------------------------
// MORE
// --------------------------------------------------

                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: theme.hintColor,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editAddress(address);
                      }

                      if (value == 'delete') {
                        _deleteAddress(address);
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 19,
                              ),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                size: 19,
                              ),
                              SizedBox(width: 10),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

// ======================================================
// QUICK ACTIONS
// ======================================================

              Row(
                children: [
                  _buildSmallActionButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {
                      _showAddressOptions(
                        address,
                      );
                    },
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _buildSmallActionButton(
                    icon: Icons.navigation_rounded,
                    onTap: () {
                      _selectAddress(
                        address.address,
                      );
                    },
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _buildSmallActionButton(
                    icon: Icons.edit_location_alt_rounded,
                    onTap: () {
                      _editAddress(address);
                    },
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// ============================================================
// SMALL ACTION BUTTON
// ============================================================

  Widget _buildSmallActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: theme.brightness == Brightness.dark
          ? const Color(0xFF27272D)
          : const Color(0xFFF8F8F8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 15,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

// ============================================================
// ADDRESS OPTIONS
// ============================================================

  void _showAddressOptions(
    MilestoneApp6Address address,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              5,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.check_circle_outline_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text(
                    'Select address',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _selectAddress(
                      address.address,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.edit_location_alt_rounded,
                  ),
                  title: const Text(
                    'Edit address',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _editAddress(address);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                  ),
                  title: const Text(
                    'Delete address',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteAddress(address);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// ============================================================
// NEARBY LOCATIONS
// ============================================================

  Widget _buildNearbyLocationList(
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF202025)
            : Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(
          _filteredNearbyLocations.length,
          (index) {
            final location = _filteredNearbyLocations[index];

            final isLast = index == _filteredNearbyLocations.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    _selectAddress(
                      location.address,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// ------------------------------------------------
// LOCATION ICON + DISTANCE
// ------------------------------------------------

                        SizedBox(
                          width: 42,
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 23,
                                color: theme.iconTheme.color,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                location.distance,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(
                                    0.65,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

// ------------------------------------------------
// LOCATION DETAILS
// ------------------------------------------------

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                location.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.3,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(
                                    0.75,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.dividerColor.withOpacity(0.20),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

// ============================================================
// EMPTY SEARCH
// ============================================================

  Widget _buildNoResults(
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_searching_rounded,
            size: 55,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 15),
          Text(
            'No locations found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try searching another area or street.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

// ============================================================
// ADDRESS ICON
// ============================================================

  IconData _getAddressIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;

      case 'work':
        return Icons.business_center_rounded;

      case 'office':
        return Icons.business_rounded;

      default:
        return Icons.location_on_rounded;
    }
  }
}

// ============================================================================
// ADDRESS MODEL
// ============================================================================

class MilestoneApp6Address {
  final String id;
  final String label;
  final String address;
  final String phone;

  const MilestoneApp6Address({
    required this.id,
    required this.label,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'phone': phone,
    };
  }

  factory MilestoneApp6Address.fromJson(
    Map<String, dynamic> json,
  ) {
    return MilestoneApp6Address(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Home',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

// ============================================================================
// NEARBY LOCATION MODEL
// ============================================================================

class MilestoneApp6NearbyLocation {
  final String name;
  final String address;
  final String distance;

  const MilestoneApp6NearbyLocation({
    required this.name,
    required this.address,
    required this.distance,
  });
}

// ============================================================================
// ADDRESS FORM MODEL
// ============================================================================

class MilestoneApp6AddressForm {
  final String label;
  final String address;
  final String phone;

  const MilestoneApp6AddressForm({
    required this.label,
    required this.address,
    required this.phone,
  });
}

// ============================================================================
// ADDRESS EDITOR SHEET
// ============================================================================

class _AddressEditorSheet extends StatefulWidget {
  final String initialLabel;
  final String initialAddress;
  final String initialPhone;
  final bool isEditing;

  const _AddressEditorSheet({
    required this.initialLabel,
    required this.initialAddress,
    required this.initialPhone,
    required this.isEditing,
  });

  @override
  State<_AddressEditorSheet> createState() => _AddressEditorSheetState();
}

class _AddressEditorSheetState extends State<_AddressEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  final TextEditingController _landmarkController = TextEditingController();

  String _selectedLabel = 'Home';

  @override
  void initState() {
    super.initState();

    _labelController = TextEditingController(
      text: widget.initialLabel,
    );
    _addressController = TextEditingController(
      text: widget.initialAddress,
    );
    _phoneController = TextEditingController(
      text: widget.initialPhone,
    );

    final existingLabel = widget.initialLabel.trim();

    if (existingLabel == 'Home' ||
        existingLabel == 'Work' ||
        existingLabel == 'Other') {
      _selectedLabel = existingLabel;
    } else {
      _selectedLabel = 'Other';
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String finalAddress = _addressController.text.trim();
    final landmark = _landmarkController.text.trim();

    if (landmark.isNotEmpty) {
      finalAddress = '$finalAddress, Near $landmark';
    }

    Navigator.of(context).pop(
      MilestoneApp6AddressForm(
        label: _selectedLabel,
        address: finalAddress,
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primary,
                              primary.withOpacity(0.65),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.20),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isEditing
                                  ? 'Edit your address'
                                  : 'Add a new address',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isEditing
                                  ? 'Update your delivery location'
                                  : 'Where should we deliver your food?',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'SAVE AS',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildLabelChip('Home', Icons.home_rounded, theme),
                      const SizedBox(width: 8),
                      _buildLabelChip('Work', Icons.work_rounded, theme),
                      const SizedBox(width: 8),
                      _buildLabelChip(
                        'Other',
                        Icons.location_on_rounded,
                        theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _buildFieldLabel('FULL ADDRESS', theme),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _addressController,
                    hint: 'House no, building, street, area...',
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                    theme: theme,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFieldLabel('LANDMARK', theme),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _landmarkController,
                    hint: 'e.g. Near Tapovan Circle',
                    icon: Icons.signpost_outlined,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildFieldLabel('PHONE NUMBER', theme),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _phoneController,
                    hint: '+91 XXXXX XXXXX',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: primary.withOpacity(0.10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: primary,
                          size: 19,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'We will use this address for your food delivery.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.35,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primary,
                            primary.withOpacity(0.78),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.isEditing
                                  ? Icons.check_circle_rounded
                                  : Icons.location_on_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isEditing
                                  ? 'Update Address'
                                  : 'Save Address',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildLabelChip(
    String label,
    IconData icon,
    ThemeData theme,
  ) {
    final isSelected = _selectedLabel == label;
    final primary = theme.colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLabel = label;
            _labelController.text = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.10) : theme.cardColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color:
                  isSelected ? primary : theme.dividerColor.withOpacity(0.35),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? primary : theme.hintColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color:
                      isSelected ? primary : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 1.3,
        fontWeight: FontWeight.w700,
        color: theme.hintColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final primary = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.35),
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: theme.hintColor,
          ),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 10,
              bottom: maxLines > 1 ? 38 : 0,
            ),
            child: Icon(
              icon,
              color: primary,
              size: 21,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            0,
            14,
            14,
            14,
          ),
        ),
      ),
    );
  }
}
