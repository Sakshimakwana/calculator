import 'package:flutter/material.dart';

import '../Address/models/milestone_app_6_save_addresses_actions_model_.dart';

class AddressEditorSheet extends StatefulWidget {
  final String initialLabel;
  final String initialAddress;
  final String initialCity;
  final String initialState;
  final String initialPincode;
  final double? initialLatitude;
  final double? initialLongitude;
  final bool isEditing;

  const AddressEditorSheet({
    super.key,
    required this.initialLabel,
    required this.initialAddress,
    this.initialCity = '',
    this.initialState = '',
    this.initialPincode = '',
    this.initialLatitude,
    this.initialLongitude,
    required this.isEditing,
  });

  @override
  State<AddressEditorSheet> createState() => AddressEditorSheetState();
}

class AddressEditorSheetState extends State<AddressEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _landmarkController;

  String _selectedLabel = 'Home';

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController(
      text: widget.initialAddress,
    );

    _cityController = TextEditingController(
      text: widget.initialCity,
    );

    _stateController = TextEditingController(
      text: widget.initialState,
    );

    _pincodeController = TextEditingController(
      text: widget.initialPincode,
    );

    _latitudeController = TextEditingController(
      text: widget.initialLatitude?.toString() ?? '',
    );

    _longitudeController = TextEditingController(
      text: widget.initialLongitude?.toString() ?? '',
    );

    _landmarkController = TextEditingController();

    final label = widget.initialLabel.trim();

    if (label == 'Home' ||
        label == 'Work' ||
        label == 'Other') {
      _selectedLabel = label;
    } else {
      _selectedLabel = 'Other';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _landmarkController.dispose();

    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String finalAddress =
    _addressController.text.trim();

    final landmark =
    _landmarkController.text.trim();

    if (landmark.isNotEmpty) {
      finalAddress =
      '$finalAddress, Near $landmark';
    }

    final latitude = double.tryParse(
      _latitudeController.text.trim(),
    );

    final longitude = double.tryParse(
      _longitudeController.text.trim(),
    );

    if (latitude == null) {
      _showError('Please enter a valid latitude.');
      return;
    }

    if (longitude == null) {
      _showError('Please enter a valid longitude.');
      return;
    }

    Navigator.of(context).pop(
      MilestoneApp6AddressForm(
        label: _selectedLabel.toLowerCase(),
        addressLine: finalAddress,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
              bottom:
              MediaQuery.of(context).viewInsets.bottom +
                  20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor
                            .withOpacity(0.8),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Header
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
                          borderRadius:
                          BorderRadius.circular(16),
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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isEditing
                                  ? 'Edit your address'
                                  : 'Add a new address',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isEditing
                                  ? 'Update your delivery location'
                                  : 'Where should we deliver your food?',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Save as
                  _buildFieldLabel(
                    'SAVE AS',
                    theme,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildLabelChip(
                        'Home',
                        Icons.home_rounded,
                        theme,
                      ),
                      const SizedBox(width: 8),
                      _buildLabelChip(
                        'Work',
                        Icons.work_rounded,
                        theme,
                      ),
                      const SizedBox(width: 8),
                      _buildLabelChip(
                        'Other',
                        Icons.location_on_rounded,
                        theme,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Address
                  _buildFieldLabel(
                    'FULL ADDRESS',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _addressController,
                    hint:
                    'House no, building, street, area...',
                    icon:
                    Icons.location_on_outlined,
                    maxLines: 3,
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your address';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // City
                  _buildFieldLabel(
                    'CITY',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _cityController,
                    hint: 'e.g. Ahmedabad',
                    icon: Icons.location_city_outlined,
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter city';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // State
                  _buildFieldLabel(
                    'STATE',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _stateController,
                    hint: 'e.g. Gujarat',
                    icon: Icons.map_outlined,
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter state';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Pincode
                  _buildFieldLabel(
                    'PINCODE',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _pincodeController,
                    hint: 'e.g. 380001',
                    icon: Icons.pin_drop_outlined,
                    keyboardType:
                    TextInputType.number,
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter pincode';
                      }

                      if (!RegExp(
                        r'^\d{6}$',
                      ).hasMatch(value.trim())) {
                        return 'Enter a valid 6 digit pincode';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Landmark
                  _buildFieldLabel(
                    'LANDMARK',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _landmarkController,
                    hint:
                    'e.g. Near Tapovan Circle',
                    icon:
                    Icons.signpost_outlined,
                    theme: theme,
                  ),

                  const SizedBox(height: 16),

                  // Latitude
                  _buildFieldLabel(
                    'LATITUDE',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller: _latitudeController,
                    hint: 'e.g. 23.0225',
                    icon:
                    Icons.explore_outlined,
                    keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter latitude';
                      }

                      final latitude =
                      double.tryParse(
                        value.trim(),
                      );

                      if (latitude == null) {
                        return 'Enter a valid latitude';
                      }

                      if (latitude < -90 ||
                          latitude > 90) {
                        return 'Latitude must be between -90 and 90';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Longitude
                  _buildFieldLabel(
                    'LONGITUDE',
                    theme,
                  ),

                  const SizedBox(height: 8),

                  _buildTextField(
                    controller:
                    _longitudeController,
                    hint: 'e.g. 72.5714',
                    icon:
                    Icons.explore_outlined,
                    keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    theme: theme,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter longitude';
                      }

                      final longitude =
                      double.tryParse(
                        value.trim(),
                      );

                      if (longitude == null) {
                        return 'Enter a valid longitude';
                      }

                      if (longitude < -180 ||
                          longitude > 180) {
                        return 'Longitude must be between -180 and 180';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Info
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color:
                      primary.withOpacity(0.07),
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color:
                        primary.withOpacity(0.10),
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
                            'City, state and pincode are required for delivery. Latitude and longitude are used to find nearby restaurants.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.35,
                              color: theme
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin:
                          Alignment.centerLeft,
                          end:
                          Alignment.centerRight,
                          colors: [
                            primary,
                            primary.withOpacity(0.78),
                          ],
                        ),
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.transparent,
                          foregroundColor:
                          Colors.white,
                          shadowColor:
                          Colors.transparent,
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.isEditing
                                  ? Icons
                                  .check_circle_rounded
                                  : Icons
                                  .location_on_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isEditing
                                  ? 'Update Address'
                                  : 'Save Address',
                              style:
                              const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w800,
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
    final isSelected =
        _selectedLabel == label;

    final primary =
        theme.colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLabel = label;
          });
        },
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withOpacity(0.10)
                : theme.cardColor,
            borderRadius:
            BorderRadius.circular(13),
            border: Border.all(
              color: isSelected
                  ? primary
                  : theme.dividerColor
                  .withOpacity(0.35),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? primary
                    : theme.hintColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: isSelected
                      ? primary
                      : theme.textTheme
                      .bodyMedium
                      ?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(
      String title,
      ThemeData theme,
      ) {
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
    final primary =
        theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.35),
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization:
        TextCapitalization.sentences,
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
              bottom:
              maxLines > 1 ? 38 : 0,
            ),
            child: Icon(
              icon,
              color: primary,
              size: 21,
            ),
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(
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