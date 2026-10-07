import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/models/milestone_app_6_save_addresses_actions_model_.dart';

class AddressWidgetsAddressEditor extends StatefulWidget {
  final String initialAddress;
  final String initialCity;
  final String initialState;
  final String initialPincode;

  final double? initialLatitude;
  final double? initialLongitude;

  final String initialLabel;

  const AddressWidgetsAddressEditor({
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
  State<AddressWidgetsAddressEditor> createState() =>
      _AddressWidgetsAddressEditorState();
}

class _AddressWidgetsAddressEditorState
    extends State<AddressWidgetsAddressEditor> {
  // ===========================================================================
  // FORM
  // ===========================================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // ===========================================================================
  // CONTROLLERS
  // ===========================================================================

  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  // ===========================================================================
  // STATE
  // ===========================================================================

  late String _selectedLabel;

  bool _isGettingLocation = false;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _selectedLabel =
        _normalizeLabel(widget.initialLabel);

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

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

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

  // ===========================================================================
  // NORMALIZE LABEL
  // ===========================================================================

  String _normalizeLabel(String value) {
    final label = value.trim().toLowerCase();

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

  // ===========================================================================
  // CURRENT LOCATION
  // ===========================================================================

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) {
      return;
    }

    try {
      setState(() {
        _isGettingLocation = true;
      });

      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

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
        await Geolocator.requestPermission();
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
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _latitudeController.text =
          position.latitude.toStringAsFixed(6);

      _longitudeController.text =
          position.longitude.toStringAsFixed(6);

      try {
        final placemarks =
        await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          final city =
          (place.locality ??
              place.subAdministrativeArea ??
              '')
              .trim();

          final state =
          (place.administrativeArea ?? '')
              .trim();

          final pincode =
          (place.postalCode ?? '')
              .trim();

          _cityController.text = city;
          _stateController.text = state;
          _pincodeController.text = pincode;

          final parts = <String>[
            if ((place.name ?? '')
                .trim()
                .isNotEmpty)
              place.name!.trim(),

            if ((place.street ?? '')
                .trim()
                .isNotEmpty)
              place.street!.trim(),

            if ((place.subLocality ?? '')
                .trim()
                .isNotEmpty)
              place.subLocality!.trim(),

            if (city.isNotEmpty) city,

            if (state.isNotEmpty) state,

            if (pincode.isNotEmpty) pincode,
          ];

          if (parts.isNotEmpty) {
            _addressController.text =
                parts.join(', ');
          }
        }
      } catch (_) {
        // Coordinates are still available.
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

  // ===========================================================================
  // SAVE
  // ===========================================================================

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final latitude =
    double.tryParse(
      _latitudeController.text.trim(),
    );

    final longitude =
    double.tryParse(
      _longitudeController.text.trim(),
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

    if (latitude < -90 || latitude > 90) {
      _showMessage(
        'Latitude must be between -90 and 90.',
      );
      return;
    }

    if (longitude < -180 || longitude > 180) {
      _showMessage(
        'Longitude must be between -180 and 180.',
      );
      return;
    }

    final form = MilestoneApp6AddressForm(
      label: _selectedLabel,
      addressLine:
      _addressController.text.trim(),
      city:
      _cityController.text.trim(),
      state:
      _stateController.text.trim(),
      pincode:
      _pincodeController.text.trim(),
      latitude: latitude,
      longitude: longitude,
    );

    Navigator.of(context).pop(form);
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bottom =
        MediaQuery.of(context)
            .viewInsets
            .bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottom,
      ),
      child: Container(
        constraints:
        const BoxConstraints(
          maxHeight: 760,
        ),
        decoration: BoxDecoration(
          color:
          theme.scaffoldBackgroundColor,
          borderRadius:
          const BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // HANDLE
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration:
                    BoxDecoration(
                      color:
                      theme.dividerColor,
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Address Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // LABEL
                const Text(
                  'Save address as',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                _buildLabelSelector(theme),

                const SizedBox(height: 20),

                // ADDRESS
                _buildField(
                  context,
                  controller:
                  _addressController,
                  label: 'Address line',
                  hint:
                  'House no, street, area...',
                  icon:
                  Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return
                        'Address line is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // CITY
                _buildField(
                  context,
                  controller:
                  _cityController,
                  label: 'City',
                  hint: 'e.g. Ahmedabad',
                  icon:
                  Icons.location_city_outlined,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'City is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // STATE
                _buildField(
                  context,
                  controller:
                  _stateController,
                  label: 'State',
                  hint: 'e.g. Gujarat',
                  icon: Icons.map_outlined,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'State is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // PINCODE
                _buildField(
                  context,
                  controller:
                  _pincodeController,
                  label: 'Pincode',
                  hint: 'e.g. 380001',
                  icon:
                  Icons.pin_drop_outlined,
                  keyboardType:
                  TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return
                        'Pincode is required';
                    }

                    if (!RegExp(
                      r'^\d{6}$',
                    ).hasMatch(
                      value.trim(),
                    )) {
                      return
                        'Enter a valid 6 digit pincode';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // CURRENT LOCATION
                SizedBox(
                  width: double.infinity,
                  child:
                  OutlinedButton.icon(
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
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(
                      Icons
                          .my_location_rounded,
                    ),
                    label: Text(
                      _isGettingLocation
                          ? 'Getting location...'
                          : 'Use Current Location',
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // COORDINATES
                const Text(
                  'Location Coordinates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildField(
                        context,
                        controller:
                        _latitudeController,
                        label: 'Latitude',
                        hint: '23.0225',
                        icon:
                        Icons.north_rounded,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Required';
                          }

                          final number =
                          double.tryParse(
                            value.trim(),
                          );

                          if (number == null) {
                            return 'Invalid';
                          }

                          if (number < -90 ||
                              number > 90) {
                            return 'Invalid range';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        context,
                        controller:
                        _longitudeController,
                        label: 'Longitude',
                        hint: '72.5714',
                        icon:
                        Icons.east_rounded,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Required';
                          }

                          final number =
                          double.tryParse(
                            value.trim(),
                          );

                          if (number == null) {
                            return 'Invalid';
                          }

                          if (number < -180 ||
                              number > 180) {
                            return 'Invalid range';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Latitude: -90 to 90  •  '
                      'Longitude: -180 to 180',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.hintColor,
                  ),
                ),

                const SizedBox(height: 25),

                // SAVE
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary,
                      foregroundColor:
                      Colors.white,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Save Address',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
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

  // ===========================================================================
  // LABEL SELECTOR
  // ===========================================================================

  Widget _buildLabelSelector(
      ThemeData theme,
      ) {
    return Row(
      children: [
        Expanded(
          child: _buildLabelChip(
            label: 'Home',
            value: 'home',
            icon: Icons.home_rounded,
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildLabelChip(
            label: 'Work',
            value: 'work',
            icon:
            Icons.business_center_rounded,
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildLabelChip(
            label: 'Other',
            value: 'other',
            icon:
            Icons.location_on_rounded,
            theme: theme,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // LABEL CHIP
  // ===========================================================================

  Widget _buildLabelChip({
    required String label,
    required String value,
    required IconData icon,
    required ThemeData theme,
  }) {
    final selected =
        _selectedLabel == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _selectedLabel = value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              .withOpacity(0.10)
              : theme.colorScheme.surface,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 21,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.hintColor,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w700,
                color: selected
                    ? theme.colorScheme.primary
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TEXT FIELD
  // ===========================================================================

  Widget _buildField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required String hint,
        required IconData icon,
        String? Function(String?)? validator,
        int maxLines = 1,
        TextInputType? keyboardType,
      }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding:
          const EdgeInsets.only(
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
        fillColor:
        theme.colorScheme.surface,
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(13),
          borderSide:
          BorderSide.none,
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(13),
          borderSide: BorderSide(
            color: theme.dividerColor,
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(13),
          borderSide: BorderSide(
            color:
            theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(13),
          borderSide:
          const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(13),
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