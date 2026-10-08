import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_address_editor.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_cannot_delete_dialog.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_delete_confirmation.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/service/milestone_app_6_address_api.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../models/milestone_app_6_save_addresses_actions_model_.dart';
import '../models/milestone_app_6_address_model.dart';
import '../../state/milestone_app_6_state.dart';

class AddressScreenLogic {
  AddressScreenLogic({
    required BuildContext context,
    required MilestoneApp6State state,
    required VoidCallback onChanged,
  })  : _context = context,
        _state = state,
        _onChanged = onChanged;

  final BuildContext _context;
  final MilestoneApp6State _state;
  final VoidCallback _onChanged;

  final MilestoneApp6AddressApi _addressApi =
  MilestoneApp6AddressApi();

  final TextEditingController searchController =
  TextEditingController();

  List<MilestoneApp6Address> savedAddresses = [];

  bool isLoadingAddresses = true;
  bool isLoadingLocation = false;
  bool isSavingAddress = false;
  bool isUpdatingAddress = false;
  bool isDeletingAddress = false;

  String searchQuery = '';

  void initialize() {
    searchController.addListener(onSearchChanged);
    loadAddresses();
  }

  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
  }

  void onSearchChanged() {
    searchQuery = searchController.text.trim().toLowerCase();
    _notify();
  }

  void clearSearch() {
    searchController.clear();
  }

  List<MilestoneApp6Address> get filteredAddresses {
    if (searchQuery.isEmpty) {
      return savedAddresses;
    }

    return savedAddresses.where((address) {
      final label = address.label.toLowerCase();
      final addressText = address.fullAddress.toLowerCase();
      final city = address.city.toLowerCase();

      return label.contains(searchQuery) ||
          addressText.contains(searchQuery) ||
          city.contains(searchQuery);
    }).toList();
  }

  // ------------------------------------------------------------
  // LOAD ADDRESSES
  // ------------------------------------------------------------

  Future<void> loadAddresses() async {
    try {
      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!_context.mounted) return;

        _context.go('/login');
        return;
      }

      isLoadingAddresses = true;
      _notify();

      final addresses = await _addressApi.fetchAddresses(
        token: token,
        page: 1,
        search: null,
      );

      if (!_context.mounted) return;

      savedAddresses = addresses;
      isLoadingAddresses = false;
      _notify();

      debugPrint('');
      debugPrint('========== ADDRESS LIST ==========');
      debugPrint('TOTAL ADDRESSES: ${addresses.length}');

      for (final address in addresses) {
        debugPrint(
          'ID: ${address.id} | '
              'LABEL: ${address.label} | '
              'ADDRESS: ${address.fullAddress}',
        );
      }

      debugPrint('==================================');
    } catch (e) {
      if (!_context.mounted) return;

      isLoadingAddresses = false;
      _notify();

      showMessage(
        'Failed to load addresses: $e',
      );
    }
  }

  Future<void> selectAddress(
      MilestoneApp6Address address,
      ) async {
    if (address.id <= 0) {
      showMessage('Invalid address ID.');
      return;
    }

    try {
      await AddressStorage.saveSelectedAddressId(
        address.id,
      );

      _state.setAddress(address);

      if (!_context.mounted) return;

      _context.go('/home');
    } catch (e) {
      if (!_context.mounted) return;

      showMessage(
        'Unable to select address: $e',
      );
    }
  }

  Future<void> addAddress({
    double? latitude,
    double? longitude,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
  }) async {
    if (savedAddresses.length >= 3) {
      showMessage(
        'You can save maximum 3 addresses.',
      );
      return;
    }

    final result = await showAddressEditor(
      initialAddress: addressLine ?? '',
      initialCity: city ?? '',
      initialState: state ?? '',
      initialPincode: pincode ?? '',
      initialLatitude: latitude,
      initialLongitude: longitude,
      initialLabel: 'home',
    );

    if (result == null) {
      return;
    }

    await saveNewAddress(result);
  }

  Future<void> saveNewAddress(
      MilestoneApp6AddressForm form,
      ) async {
    if (isSavingAddress) {
      return;
    }

    try {
      isSavingAddress = true;
      _notify();

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!_context.mounted) return;

        _context.go('/login');
        return;
      }

      final bool isDefault = savedAddresses.isEmpty;

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
      debugPrint('==========================================');
      debugPrint('          ADD ADDRESS FROM UI             ');
      debugPrint('==========================================');
      debugPrint('REQUEST BODY:');
      debugPrint(body.toString());
      debugPrint('==========================================');

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

      await AddressStorage.saveSelectedAddressId(
        savedAddress.id,
      );

      _state.setAddress(savedAddress);

      await loadAddresses();

      if (!_context.mounted) return;

      showMessage(
        'Address added successfully.',
      );

      _context.go('/home');
    } catch (e) {
      if (!_context.mounted) return;

      showMessage(
        'Failed to save address: $e',
      );
    } finally {
      isSavingAddress = false;
      _notify();
    }
  }

  Future<void> editAddress(
      MilestoneApp6Address address,
      ) async {
    final result = await showAddressEditor(
      initialAddress: address.address,
      initialCity: address.city,
      initialState: address.state,
      initialPincode: address.pincode,
      initialLatitude: address.latitude,
      initialLongitude: address.longitude,
      initialLabel: address.label,
    );

    if (result == null) {
      return;
    }

    await updateAddress(
      address,
      result,
    );
  }

  Future<void> updateAddress(
      MilestoneApp6Address oldAddress,
      MilestoneApp6AddressForm form,
      ) async {
    if (isUpdatingAddress) {
      return;
    }

    try {
      isUpdatingAddress = true;
      _notify();

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!_context.mounted) return;

        _context.go('/login');
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
        'is_default': oldAddress.id == selectedId,
      };

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('           UPDATE ADDRESS UI              ');
      debugPrint('==========================================');
      debugPrint('ADDRESS ID: ${oldAddress.id}');
      debugPrint('REQUEST BODY:');
      debugPrint(body.toString());
      debugPrint('==========================================');

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

      if (oldAddress.id == selectedId) {
        await AddressStorage.saveSelectedAddressId(
          updatedAddress.id,
        );

        _state.setAddress(updatedAddress);
      }

      await loadAddresses();

      if (!_context.mounted) return;

      showMessage(
        'Address updated successfully.',
      );
    } catch (e) {
      if (!_context.mounted) return;

      showMessage(
        'Failed to update address: $e',
      );
    } finally {
      isUpdatingAddress = false;
      _notify();
    }
  }

  Future<void> deleteAddress(
      MilestoneApp6Address address,
      ) async {
    if (savedAddresses.length <= 1) {
      showCannotDeletePopup();
      return;
    }

    final confirmed =
    await showDeleteConfirmation(address);

    if (confirmed != true) {
      return;
    }

    await performDeleteAddress(address);
  }

  Future<void> performDeleteAddress(
      MilestoneApp6Address address,
      ) async {
    if (isDeletingAddress) {
      return;
    }

    try {
      isDeletingAddress = true;
      _notify();

      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!_context.mounted) return;

        _context.go('/login');
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

      await loadAddresses();

      if (wasSelected &&
          savedAddresses.isNotEmpty) {
        final newAddress =
            savedAddresses.first;

        await AddressStorage.saveSelectedAddressId(
          newAddress.id,
        );

        _state.setAddress(newAddress);
      }

      if (!_context.mounted) return;

      showMessage(
        'Address deleted successfully.',
      );
    } catch (e) {
      if (!_context.mounted) return;

      showMessage(
        'Failed to delete address: $e',
      );
    } finally {
      isDeletingAddress = false;
      _notify();
    }
  }

  Future<bool?> showDeleteConfirmation(
      MilestoneApp6Address address,
      ) {
    return showDialog<bool>(
      context: _context,
      builder: (dialogContext) {
        return AddressWidgetsDeleteConfirmation(
          addressLabel: displayLabel(
            address.label,
          ),
        );
      },
    );
  }

  void showCannotDeletePopup() {
    showDialog<void>(
      context: _context,
      builder: (dialogContext) {
        return const AddressWidgetsCannotDeleteDialog();
      },
    );
  }

  // ------------------------------------------------------------
  // CURRENT LOCATION
  // ------------------------------------------------------------

  Future<void> useCurrentLocation() async {
    if (isLoadingLocation) {
      return;
    }

    try {
      isLoadingLocation = true;
      _notify();

      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        showMessage(
          'Please enable location services.',
        );
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        showMessage(
          'Location permission denied.',
        );
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        showMessage(
          'Location permission is permanently '
              'denied. Enable it from Settings.',
        );
        return;
      }

      final position =
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.high,
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
          final place = placemarks.first;

          city = (place.locality ??
              place.subAdministrativeArea ??
              '')
              .trim();

          state =
              (place.administrativeArea ?? '')
                  .trim();

          pincode =
              (place.postalCode ?? '').trim();

          final parts = <String>[
            if ((place.name ?? '').trim().isNotEmpty)
              place.name!.trim(),

            if ((place.street ?? '').trim().isNotEmpty)
              place.street!.trim(),

            if ((place.subLocality ?? '').trim().isNotEmpty)
              place.subLocality!.trim(),

            if (city.isNotEmpty)
              city,

            if (state.isNotEmpty)
              state,

            if (pincode.isNotEmpty)
              pincode,
          ];

          addressText = parts.join(', ');
        }
      } catch (_) {
        // Coordinates are still available.
      }

      if (addressText.isEmpty) {
        addressText =
        'Current Location '
            '(${position.latitude.toStringAsFixed(6)}, '
            '${position.longitude.toStringAsFixed(6)})';
      }

      await addAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        addressLine: addressText,
        city: city,
        state: state,
        pincode: pincode,
      );
    } catch (e) {
      if (_context.mounted) {
        showMessage(
          'Unable to get your current location: $e',
        );
      }
    } finally {
      isLoadingLocation = false;
      _notify();
    }
  }

  Future<MilestoneApp6AddressForm?>
  showAddressEditor({
    String initialAddress = '',
    String initialCity = '',
    String initialState = '',
    String initialPincode = '',
    double? initialLatitude,
    double? initialLongitude,
    String initialLabel = 'home',
  }) async {
    return showModalBottomSheet<
        MilestoneApp6AddressForm>(
      context: _context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return AddressWidgetsAddressEditor(
          initialAddress: initialAddress,
          initialCity: initialCity,
          initialState: initialState,
          initialPincode: initialPincode,
          initialLatitude: initialLatitude,
          initialLongitude: initialLongitude,
          initialLabel: initialLabel,
        );
      },
    );
  }

  void showMessage(String message) {
    if (!_context.mounted) return;

    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(
            seconds: 3,
          ),
        ),
      );
  }

  String displayLabel(String label) {
    if (label.isEmpty) {
      return 'Address';
    }

    return label[0].toUpperCase() +
        label.substring(1);
  }

  void _notify() {
    _onChanged();
  }
}